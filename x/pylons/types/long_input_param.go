package types

// Has validate if input is between min max range
func (lp LongInputParam) Has(input int) bool {
	return int64(input) >= lp.MinValue && int64(input) <= lp.MaxValue
}

// Actualize generate a value from range
func (lpm LongInputParamList) Actualize() []*LongKeyValue {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	var m []*LongKeyValue
	for _, param := range lpm.List {
		m = append(m, &LongKeyValue{
			Key:   param.Key,
			Value: (param.MinValue + param.MaxValue) / 2,
		})
	}
	return m
}
