package evtesting

import (
	"log"
	"testing"

	"github.com/stretchr/testify/require"
)

type T struct {
	origin    *testing.T
	useLogPkg bool
}

var listeners = make(map[string]func())

func NewT(origin *testing.T) T {
	newT := T{
		origin:    origin,
		useLogPkg: false,
	}
	if origin == nil {
		orgT := testing.T{}
		newT.origin = &orgT
		newT.useLogPkg = true
	}
	return newT
}

func (t *T) Fatal(args ...interface{}) {
	t.DispatchEvent("FAIL")
	if t.useLogPkg {
		log.Fatal(args...)
	} else {
		t.origin.Fatal(args...)
	}
}

func (t *T) Fatalf(format string, args ...interface{}) {
	t.DispatchEvent("FAIL")
	if t.useLogPkg {
		log.Fatalf(format, args...)
	} else {
		t.origin.Fatalf(format, args...)
	}
}

func (t *T) MustTrue(value bool) {
	if value == false {
		t.DispatchEvent("FAIL")
	}
	if t.useLogPkg {
		if value == false {
			log.Fatal("MustTrue validation failed")
		}
	} else {
		require.True(t.origin, value)
	}
}

func (t *T) MustNil(err error) {
	if err != nil {
		t.Log("comparing \"", err, "\" to nil")
	}
	t.MustTrue(err == nil)
}

func (t *T) Parallel() {
	t.origin.Parallel()
}

func (t *T) Log(args ...interface{}) {
	if t.useLogPkg {
		log.Println(args...)
	} else {
		t.origin.Log(args...)
	}
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
