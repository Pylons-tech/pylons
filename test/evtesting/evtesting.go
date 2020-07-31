package evtesting

import (
	"fmt"
	"runtime"
	"runtime/debug"
	"sort"
	"strings"
	"testing"

	log "github.com/sirupsen/logrus"
)

// sort types
const (
	NoSort          = 0
	SortKeyAlphaBet = 1
	SortCustomKey   = 2 // sort by passed custom keys and rest are done by length of value
	SortValueLength = 3 // sort by length of value
)

// T is a modified testing.T
type T struct {
	origin     *testing.T
	useLogPkg  bool
	fields     log.Fields
	logLevel   log.Level
	sortType   int
	sortFields []string
}

// Fields is a type to manage json based output
type Fields log.Fields

var listeners = make(map[string]func())

// NewT is function returns modified T from original testing.T
func NewT(origin *testing.T) T {
	newT := T{
		origin:     origin,
		useLogPkg:  false,
		fields:     log.Fields{},
		logLevel:   log.DebugLevel,
		sortType:   SortValueLength,
		sortFields: []string{},
	}
	if origin == nil {
		orgT := testing.T{}
		newT.origin = &orgT
		newT.useLogPkg = true
		newT.logLevel = log.TraceLevel
		newT.sortType = SortValueLength
		newT.sortFields = []string{}
	}
	return newT
}

// NewLogLevelT is a NewT variant that has custom logLevel
func NewLogLevelT(origin *testing.T, logLevel log.Level) T {
	newT := NewT(origin)
	newT.logLevel = logLevel
	return newT
}

// WithFields is to manage data in json format
func (t *T) WithFields(fields Fields) *T {
	return &T{
		fields:     log.Fields(fields),
		origin:     t.origin,
		useLogPkg:  t.useLogPkg,
		logLevel:   t.logLevel,
		sortType:   t.sortType,
		sortFields: t.sortFields,
	}
}

// Run is modified Run
func (t *T) Run(name string, f func(t *T)) bool {
	return t.origin.Run(name, func(subt *testing.T) {
		newT := T{
			origin:     subt,
			fields:     t.fields,
			useLogPkg:  t.useLogPkg,
			logLevel:   t.logLevel,
			sortType:   t.sortType,
			sortFields: t.sortFields,
		}
		f(&newT)
	})
}

// AddFields is to add additional data to existing fields
func (t *T) AddFields(fields log.Fields) *T {
	for k, v := range fields {
		t.fields[k] = v
	}
	return t
}

// SetFieldsOrder is to set fields order for better debugging
func (t *T) SetFieldsOrder(sortType int, sortFields []string) *T {
	t.sortType = sortType
	t.sortFields = sortFields
	return t
}

// DispatchEvent process events that are related to the event e.g. failure in one test case make others to fail without continuing
func (t *T) DispatchEvent(event string) {
	if listener, ok := listeners[event]; ok {
		listener()
	}
}

func getFrame(skipFrames int) runtime.Frame {
	// We need the frame at index skipFrames+2, since we never want runtime.Callers and getFrame
	targetFrameIndex := skipFrames + 2

	// Set size to targetFrameIndex+2 to ensure we have room for one more caller than we need
	programCounters := make([]uintptr, targetFrameIndex+2)
	n := runtime.Callers(0, programCounters)

	frame := runtime.Frame{Function: "unknown"}
	if n > 0 {
		frames := runtime.CallersFrames(programCounters[:n])
		for more, frameIndex := true, 0; more && frameIndex <= targetFrameIndex; frameIndex++ {
			var frameCandidate runtime.Frame
			frameCandidate, more = frames.Next()
			if frameIndex == targetFrameIndex {
				frame = frameCandidate
			}
		}
	}

	return frame
}

func (t *T) printCallerLine() {
	requiredLevel := log.DebugLevel
	frame := getFrame(2)
	if t.useLogPkg {
		text := fmt.Sprintf("%s:%d %s", frame.File, frame.Line, frame.Function)
		log.WithFields(log.Fields{
			"file_line": fmt.Sprintf("%s:%d", frame.File, frame.Line),
			"func":      frame.Function,
		}).Trace(text)
	} else {
		nT := t.WithFields(Fields{
			"file_line": fmt.Sprintf("%s:%d", frame.File, frame.Line),
			"func":      frame.Function,
		})
		logOutput := fmt.Sprintf("\x1b[%dm%s\x1b[0m ", FieldColorByLogLevel(requiredLevel), nT.FormatFields(requiredLevel))
		t.origin.Log(logOutput)
	}
}

func (t *T) printEntireStack() {
	traceTextBytes := debug.Stack()
	traceText := string(traceTextBytes)
	if t.useLogPkg {
		log.Trace(traceText)
	} else {
		t.origin.Log(traceText)
	}
}

// FieldColorByLogLevel returns color
func FieldColorByLogLevel(logLevel log.Level) int {
	// https://misc.flogisoft.com/bash/tip_colors_and_formatting
	const (
		red    = 31
		orange = 202
		yellow = 33
		blue   = 36
		gray   = 37
	)
	var levelColor int
	switch logLevel {
	case log.DebugLevel, log.TraceLevel:
		levelColor = gray
	case log.WarnLevel, log.ErrorLevel:
		levelColor = yellow
	case log.FatalLevel, log.PanicLevel:
		levelColor = red
	default:
		levelColor = blue
	}
	return levelColor
}

// FormatFields renders a single log entry
func (t *T) FormatFields(logLevel log.Level) string {
	formated := fmt.Sprintf("level=%+v", logLevel)
	data := make(Fields)
	for k, v := range t.fields {
		data[k] = v
	}

	keys := make([]string, 0, len(data))
	for k := range data {
		keys = append(keys, k)
	}

	fixedKeys := []string{}
	fixedKeys = append(fixedKeys, keys...)
	switch t.sortType {
	case NoSort:
	case SortKeyAlphaBet:
		sort.Strings(fixedKeys)
	case SortCustomKey:
		customIndexMap := map[string]int{}
		for i, k := range t.sortFields {
			customIndexMap[k] = len(t.sortFields) - i + 1
		}
		sort.Slice(fixedKeys, func(i, j int) bool {
			cik := customIndexMap[fixedKeys[i]]
			cjk := customIndexMap[fixedKeys[j]]
			if cik != cjk {
				return cik > cjk
			}
			sik := fmt.Sprintf("%+v", data[fixedKeys[i]])
			sjk := fmt.Sprintf("%+v", data[fixedKeys[j]])
			return len(sik) < len(sjk)
		})
	case SortValueLength:
		sort.Slice(fixedKeys, func(i, j int) bool {
			sik := fmt.Sprintf("%+v", data[fixedKeys[i]])
			sjk := fmt.Sprintf("%+v", data[fixedKeys[j]])
			return len(sik) < len(sjk)
		})
	}

	for _, key := range fixedKeys {
		formated += fmt.Sprintf(" %s=%+v", key, data[key])
	}

	return formated
}

// Error is a modified Error
func (t *T) Error(args ...interface{}) {
	requiredLevel := log.ErrorLevel
	t.printCallerLine()
	if t.useLogPkg {
		log.WithFields(t.fields).Error(args...)
	} else {
		text := fmt.Sprintf("%s msg=%s", t.FormatFields(requiredLevel), fmt.Sprintln(args...))
		logOutput := fmt.Sprintf("\x1b[%dm%s\x1b[0m ", FieldColorByLogLevel(requiredLevel), text)
		t.origin.Log(logOutput)
	}
}

// Panic is a modified Panic
func (t *T) Panic(args ...interface{}) {
	requiredLevel := log.PanicLevel
	t.DispatchEvent("FAIL")
	t.printCallerLine()
	if t.useLogPkg {
		log.WithFields(t.fields).Panic(args...)
	} else {
		text := fmt.Sprintf("%s msg=%s", t.FormatFields(requiredLevel), fmt.Sprintln(args...))
		logOutput := fmt.Sprintf("\x1b[%dm%s\x1b[0m ", FieldColorByLogLevel(requiredLevel), text)
		t.origin.Fatal(logOutput)
	}
}

// Fatal is a modified Fatal
func (t *T) Fatal(args ...interface{}) {
	requiredLevel := log.FatalLevel
	t.DispatchEvent("FAIL")
	t.printCallerLine()
	if t.useLogPkg {
		log.WithFields(t.fields).Fatal(args...)
	} else {
		text := fmt.Sprintf("%s msg=%s", t.FormatFields(requiredLevel), fmt.Sprintln(args...))
		logOutput := fmt.Sprintf("\x1b[%dm%s\x1b[0m ", FieldColorByLogLevel(requiredLevel), text)
		t.origin.Fatal(logOutput)
	}
}

// Fatalf is a modified Fatalf
func (t *T) Fatalf(format string, args ...interface{}) {
	requiredLevel := log.FatalLevel
	t.DispatchEvent("FAIL")
	t.printCallerLine()
	if t.useLogPkg {
		log.WithFields(t.fields).Fatalf(format, args...)
	} else {
		text := fmt.Sprintf("%s msg=%s", t.FormatFields(requiredLevel), fmt.Sprintf(format, args...))
		logOutput := fmt.Sprintf("\x1b[%dm%s\x1b[0m ", FieldColorByLogLevel(requiredLevel), text)
		t.origin.Fatal(logOutput)
	}
}

// MustTrue validate if value is true
func (t *T) MustTrue(value bool, args ...interface{}) {
	if !value {
		t.DispatchEvent("FAIL")
		t.printEntireStack()
		t.WithFields(Fields(t.fields)).
			AddFields(log.Fields{
				"error_from": "MustTrue validation failure",
			}).Fatal(args...)
	}
}

// MustNil validate if error is nil
func (t *T) MustNil(err error, args ...interface{}) {
	if err != nil {
		t.DispatchEvent("FAIL")
		t.printEntireStack()
		t.WithFields(Fields(t.fields)).
			AddFields(log.Fields{
				"error":      err,
				"error_from": "MustNil validation failure",
			}).Fatal(args...)
	}
}

// MustContain check srcstring contains substring
func (t *T) MustContain(srcstring, substring string, args ...interface{}) {
	value := strings.Contains(srcstring, substring)
	if !value {
		t.DispatchEvent("FAIL")
		t.printEntireStack()
		t.WithFields(Fields(t.fields)).
			AddFields(log.Fields{
				"src_string": srcstring,
				"sub_string": substring,
				"error_from": "MustContain validation failure",
			}).Fatal(args...)
	}
}

// Parallel is modified Parallel
func (t *T) Parallel() {
	t.origin.Parallel()
}

// Log is modified Log
func (t *T) Log(args ...interface{}) {
	requiredLevel := log.InfoLevel
	if t.useLogPkg {
		log.WithFields(t.fields).Infoln(args...)
	} else {
		text := fmt.Sprintf("%s msg=%s", t.FormatFields(requiredLevel), fmt.Sprintln(args...))
		logOutput := fmt.Sprintf("\x1b[%dm%s\x1b[0m ", FieldColorByLogLevel(requiredLevel), text)
		t.origin.Log(logOutput)
	}
}

// Info is modified Info
func (t *T) Info(args ...interface{}) {
	requiredLevel := log.InfoLevel
	if t.logLevel < log.InfoLevel {
		return
	}
	if t.useLogPkg {
		log.WithFields(t.fields).Infoln(args...)
	} else {
		text := fmt.Sprintf("%s msg=%s", t.FormatFields(requiredLevel), fmt.Sprintln(args...))
		logOutput := fmt.Sprintf("\x1b[%dm%s\x1b[0m ", FieldColorByLogLevel(requiredLevel), text)
		t.origin.Log(logOutput)
	}
}

// Warn is modified Info
func (t *T) Warn(args ...interface{}) {
	requiredLevel := log.WarnLevel
	if t.logLevel < log.WarnLevel {
		return
	}
	t.printCallerLine()
	if t.useLogPkg {
		log.WithFields(t.fields).Warnln(args...)
	} else {
		text := fmt.Sprintf("%s msg=%s", t.FormatFields(requiredLevel), fmt.Sprintln(args...))
		logOutput := fmt.Sprintf("\x1b[%dm%s\x1b[0m ", FieldColorByLogLevel(requiredLevel), text)
		t.origin.Log(logOutput)
	}
}

// Trace is modified Trace
func (t *T) Trace(args ...interface{}) {
	requiredLevel := log.TraceLevel
	if t.logLevel < requiredLevel {
		return
	}
	t.printCallerLine()
	if t.useLogPkg {
		log.WithFields(t.fields).Traceln(args...)
	} else {
		text := fmt.Sprintf("%s msg=%s", t.FormatFields(requiredLevel), fmt.Sprintln(args...))
		logOutput := fmt.Sprintf("\x1b[%dm%s\x1b[0m ", FieldColorByLogLevel(requiredLevel), text)
		t.origin.Log(logOutput)
	}
}

// Debug is modified Debug
func (t *T) Debug(args ...interface{}) {
	requiredLevel := log.DebugLevel
	if t.logLevel < requiredLevel {
		return
	}
	t.printCallerLine()
	if t.useLogPkg {
		log.WithFields(t.fields).Debugln(args...)
	} else {
		text := fmt.Sprintf("%s msg=%s", t.FormatFields(requiredLevel), fmt.Sprintln(args...))
		logOutput := fmt.Sprintf("\x1b[%dm%s\x1b[0m ", FieldColorByLogLevel(requiredLevel), text)
		t.origin.Log(logOutput)
	}
}
