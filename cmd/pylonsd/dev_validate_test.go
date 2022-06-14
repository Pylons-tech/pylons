package main

import (
	"bytes"
	"fmt"
	"log"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestValidate(t *testing.T) {
	t.Run("Bad cookbook", func(t *testing.T) {
		var buf bytes.Buffer
		Out = &buf
		defer func() { Out = os.Stdout }()
		cmd := CmdDevValidate()
		cmd.SetArgs([]string{"testdata/dev/bad.plc"})
		cmd.Execute()
		log.SetOutput(os.Stderr)
		str := buf.String()
		assert.NotEqual(t, "testdata/dev/bad.plc is a valid cookbook\n", str)
		t.Log(str)
	})

	t.Run("Good cookbook", func(t *testing.T) {
		var buf bytes.Buffer
		Out = &buf

		defer func() { Out = os.Stdout }()
		fmt.Print()
		cmd := CmdDevValidate()
		cmd.SetArgs([]string{"testdata/dev/good.plc"})
		cmd.Execute()
		log.SetOutput(os.Stderr)
		str := buf.String()
		assert.Equal(t, "testdata/dev/good.plc is a valid cookbook\n", str)
		t.Log(str)
	})
}
