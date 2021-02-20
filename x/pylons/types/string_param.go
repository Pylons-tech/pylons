package types

// Actualize actualize string param using cel program
func (spm StringParamList) Actualize(ec CelEnvCollection) ([]*StringKeyValue, error) {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	var m []*StringKeyValue
	for _, param := range spm.List {
		var val string
		var err error

		if len(param.Program) > 0 {
			val, err = ec.EvalString(param.Program)
		} else {
			val = param.Value
		}
		if err != nil {
			return m, err
		}
		m = append(m, &StringKeyValue{
			Key:   param.Key,
			Value: val,
		})
	}
	return m, nil
}
