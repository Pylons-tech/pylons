package evtesting

import (
	"testing"

	"github.com/stretchr/testify/require"
)

type T struct {
	origin *testing.T
}

var listeners = make(map[string]func())

func NewT(origin *testing.T) T {
	newT := T{
		origin: origin,
	}
	return newT
}

func (t *T) Fatal(args ...interface{}) {
	t.DispatchEvent("FAIL")
	t.origin.Fatal(args...)
}

func (t *T) Fatalf(format string, args ...interface{}) {
	t.DispatchEvent("FAIL")
	t.origin.Fatalf(format, args...)
}

func (t *T) MustTrue(value bool) {
	require.True(t.origin, value)
}

func (t *T) Parallel() {
	t.origin.Parallel()
}

func (t *T) Log(args ...interface{}) {
	t.origin.Log(args...)
}

func (t *T) Run(name string, f func(t *T)) bool {
	return t.origin.Run(name, func(t *testing.T) {
		newT := T{
			origin: t,
		}
		f(&newT)
	})
}

func (t *T) AddEventListener(event string, listener func()) {
	listeners[event] = listener
}

func (t *T) DispatchEvent(event string) {
	if listener, ok := listeners[event]; ok {
		listener()
	}
}
