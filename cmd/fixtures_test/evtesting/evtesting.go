package evtesting

import (
	"testing"
)

type T testing.T

func (t *T) EvFatal(args ...interface{}) {
	t.Fatal(args...)
}

func (t *T) EvFatalf(format string, args ...interface{}) {
	t.Fatalf(format, args...)
}
