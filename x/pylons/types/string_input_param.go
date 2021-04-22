package types

type StringInputParamList []StringInputParam

// Actualize actualize string from StringInputParamList
func (lpm StringInputParamList) Actualize() []StringKeyValue {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	var m []StringKeyValue
	for _, param := range lpm {
		m = append(m, StringKeyValue{
			Key:   param.Key,
			Value: param.Value,
		})
	}
	return m
}
