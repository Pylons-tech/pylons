package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// Has check if an input is between double input param range
func (dp DoubleInputParam) Has(input sdk.Dec) bool {
	return input.GTE(dp.MinValue) && input.LTE(dp.MaxValue)
}

type DoubleInputParamList []DoubleInputParam

// Actualize creates a (key, value) list from ParamList
func (dpm DoubleInputParamList) Actualize() []DoubleKeyValue {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	var m []DoubleKeyValue
	for _, param := range dpm {
		m = append(m, DoubleKeyValue{
			Key:   param.Key,
			Value: param.MinValue.Add(param.MaxValue).QuoInt64(2),
		})
	}
	return m
}
