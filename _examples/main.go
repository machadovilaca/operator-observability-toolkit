package main

import (
	"fmt"
	"net/http"
	"time"

	"github.com/prometheus/client_golang/prometheus/promhttp"

	"github.com/rhobs/operator-observability-toolkit/examples/metrics"
)

func main() {
	metrics.SetupMetrics()

	// Production operators should use controller-runtime's metrics server with
	// kube-rbac-proxy or SecureServing for TLS and authentication.
	mux := http.NewServeMux()
	mux.Handle("/metrics", promhttp.Handler())
	srv := &http.Server{
		Addr:              "127.0.0.1:2112",
		ReadHeaderTimeout: 10 * time.Second,
		Handler:           mux,
	}
	go srv.ListenAndServe()

	fmt.Println("Server started on 127.0.0.1:2112")

	v := 0.0

	for {
		metrics.IncrementReconcileCountMetric()
		metrics.IncrementReconcileActionMetric("sleep")

		metrics.SetPerSecondData("source1", v)
		v = v + 1

		time.Sleep(1 * time.Second)
	}
}
