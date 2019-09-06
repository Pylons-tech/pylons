package types

import (
	"fmt"
)

// DoubleParam describes the bounds on an item input/output parameter of type float64
type DoubleParam struct {
	// The minimum legal value of this parameter.
	MinValue     int64
	// The maximum legal value of this parameter.
	MaxValue     int64
	// The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive).
	Rate         float32
}

// DoubleParamList is a list of DoubleParams
type DoubleParamList []DoubleParam

func (dp DoubleParam) String() string {
	return fmt.Sprintf(`
	DoubleParam{ 
		MinValue: %s,
		MaxValue: %s,
		Rate: %+v,
	}`, dp.MinValue, dp.MaxValue, dp.Rate)
}

func (dpl DoubleParamList) String() string {
	dp := "DoubleParamList{"

	for _, output := range dpl {
		dp += output.String() + ",\n"
	}

	dp += "}"
	return dp
}
