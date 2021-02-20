package types

// Has check if an input is between double input param range
func (dp DoubleInputParam) Has(input float64) bool {
	return input >= dp.MinValue.Float() && input <= dp.MaxValue.Float()
}

// Actualize creates a (key, value) list from ParamList
func (dpm DoubleInputParamList) Actualize() []DoubleKeyValue {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	var m []DoubleKeyValue
	for _, param := range dpm.Params {
		m = append(m, DoubleKeyValue{
			Key:   param.Key,
			Value: ToFloatString((param.MinValue.Float() + param.MaxValue.Float()) / 2),
		})
	}
	return m
}
