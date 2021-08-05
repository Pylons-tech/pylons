package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// Has check if an input is between double input param range
func (dp DoubleInputParam) Has(input sdk.Dec) bool {
	return input.GTE(dp.MinValue) && input.LTE(dp.MaxValue)
}

// Actualize creates a (key, value) list from ParamList
func (dpm DoubleInputParamList) Actualize() []DoubleKeyValue {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	m := make([]DoubleKeyValue, len(dpm))
	for i, param := range dpm {
		m[i] = DoubleKeyValue{
			Key:   param.Key,
			Value: param.MinValue.Add(param.MaxValue).QuoInt64(2),
		}
	}
	return m
}

// TODO check if needed
// Has validates if input is between min max range
// func (lp FeeInputParam) Has(input int64) bool {
//	// it means fee restriction is not set
//	if lp.MinValue == 0 && lp.MaxValue == 0 {
//		return true
//	}
//	return input >= lp.MinValue && input <= lp.MaxValue
//}

// Has validate if input is between min max range
func (lp LongInputParam) Has(input int) bool {
	return int64(input) >= lp.MinValue && int64(input) <= lp.MaxValue
}

// Actualize generate a value from range
func (lpm LongInputParamList) Actualize() []LongKeyValue {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	m := make([]LongKeyValue, len(lpm))
	for i, param := range lpm {
		m[i] = LongKeyValue{
			Key:   param.Key,
			Value: (param.MinValue + param.MaxValue) / 2,
		}
	}
	return m
}

// Actualize actualize string from StringInputParamList
func (lpm StringInputParamList) Actualize() []StringKeyValue {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	m := make([]StringKeyValue, len(lpm))
	for i, param := range lpm {
		m[i] = StringKeyValue(param)
	}
	return m
}
