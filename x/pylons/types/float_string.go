package types

import (
	"strconv"
)

// FloatString is a wrapper to resolve the amino issues
type FloatString string

func (fs FloatString) Float() float64 {
	v, err := strconv.ParseFloat(string(fs), 64)
	if err != nil {
		panic("couldn't parse floatstring, this should be handled less clumsily in future")
	}
	return v
}

func ToFloatString(f float64) FloatString {
	return FloatString(strconv.FormatFloat(f, 'f', -1, 64))
}
