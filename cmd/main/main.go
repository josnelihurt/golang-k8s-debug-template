package main

import (
	"net"

	"github.com/go-kit/kit/log/level"
	kitlog "github.com/go-kit/log"
	"github.com/gorilla/mux"
	"github.com/oklog/oklog/pkg/group"

	"fmt"
	stdlog "log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
)

func hello(w http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(w, "hello\n")
}

func main() {
	var err error
	logger := kitlog.NewJSONLogger(kitlog.NewSyncWriter(os.Stdout))
	stdlog.SetOutput(kitlog.NewStdlibAdapter(logger))
	level.Debug(logger).Log(">", "starting app")
	var g group.Group
	{
		g.Add(func() error {
			c := make(chan os.Signal, 1)
			signal.Notify(c, syscall.SIGINT, syscall.SIGTERM)
			select {
			case sig := <-c:
				return fmt.Errorf("received signal %s", sig)
			}
		}, func(err error) {
			level.Error(logger).Log(">", "exit signal", "error", err)
		})
	}
	{
		rtr := mux.NewRouter()
		rtr.HandleFunc("/hello", hello)
		listener, err := net.Listen("tcp", ":80")
		if err != nil {
			_ = logger.Log("init", "HTTP", "err", err)
			os.Exit(1)
		}
		g.Add(func() error {
			return http.Serve(listener, rtr)
		}, func(err error) {
			listener.Close()
			level.Error(logger).Log(">", "http is closing", "error", err)
		})
	}

	if err = g.Run(); err != nil {
		level.Error(logger).Log(">", "exiting", "error", err)
		os.Exit(1)
	}
}
