GOIMPORTS_VERSION ?= v0.33.0
GOLANGCI_LINT_VERSION ?= v2.12.2
GOVULNCHECK_VERSION ?= v1.6.0

all: goimport goclean lint test

sanity: goimport goclean check-diff

goclean:
	go version
	go fmt ./...
	go mod tidy -v
	go mod vendor
	git add -N vendor

goimport:
	go run golang.org/x/tools/cmd/goimports@${GOIMPORTS_VERSION} -w -local="github.com/rhobs/operator-observability-toolkit"  $(shell find . -type f -name '*.go' ! -path "*/vendor/*" )

test:
	go test -v ./pkg/...

lint:
	go run github.com/golangci/golangci-lint/v2/cmd/golangci-lint@${GOLANGCI_LINT_VERSION} run

govulncheck:
	go run golang.org/x/vuln/cmd/govulncheck@${GOVULNCHECK_VERSION} ./...

check-diff:
	git difftool -y --trust-exit-code

e2e-functional:
	go test -v ./e2e/functional
