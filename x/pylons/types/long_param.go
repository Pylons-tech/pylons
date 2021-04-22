package types

type LongParamList []LongParam

// Actualize builds the params
func (lpm LongParamList) Actualize(ec CelEnvCollection) (LongKeyValueList, error) {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	var m []LongKeyValue
	for _, param := range lpm {
		var val int64
		var err error

		if len(param.Program) > 0 {
			val, err = ec.EvalInt64(param.Program)
		} else {
			val, err = param.WeightTable.Generate()
		}
		if err != nil {
			return m, err
		}
		m = append(m, LongKeyValue{
			Key:   param.Key,
			Value: val,
		})
	}
	return m, nil
}
