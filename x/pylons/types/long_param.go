package types

import (
	"fmt"
	"strconv"
)

// LongParam describes the bounds on an item input/output parameter of type int64
type LongParam struct {
	// The minimum legal value of this parameter.
	MinValue     int64
	// The maximum legal value of this parameter.
	MaxValue     int64
	// The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive).
	Rate         float64
}

// LongParamList is a list of LongParams
type LongParamList []LongParam

func (lp LongParam) String() string {
	return fmt.Sprintf(`
	LongParam{ 
		MinValue: %s,
		MaxValue: %s,
		Rate: %+v,
	}`, strconv.FormatInt(lp.MinValue, 10), strconv.FormatInt(lp.MaxValue, 10), strconv.FormatFloat(lp.Rate, 'f', -1, 64))
}

func (lpl LongParamList) String() string {
	lp := "LongParamList{"

	for _, output := range lpl {
		lp += output.String() + ",\n"
	}

	lp += "}"
	return lp
}
