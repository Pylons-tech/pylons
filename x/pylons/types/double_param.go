package types

import (
	"fmt"
	"strconv"
)

// DoubleParam describes the bounds on an item input/output parameter of type float64
type DoubleParam struct {
	// The minimum legal value of this parameter.
	MinValue     float64
	// The maximum legal value of this parameter.
	MaxValue     float64
	// The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive).
	Rate         float64
}

// DoubleParamList is a list of DoubleParams
type DoubleParamList []DoubleParam

func (dp DoubleParam) String() string {
	return fmt.Sprintf(`
	DoubleParam{ 
		MinValue: %s,
		MaxValue: %s,
		Rate: %+v,
	}`, strconv.FormatFloat(dp.MinValue, 'f', -1, 64), strconv.FormatFloat(dp.MaxValue, 'f', -1, 64), strconv.FormatFloat(dp.Rate, 'f', -1, 64))
}

func (dpl DoubleParamList) String() string {
	dp := "DoubleParamList{"

	for _, output := range dpl {
		dp += output.String() + ",\n"
	}

	dp += "}"
	return dp
}
