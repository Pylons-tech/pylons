package types

import "encoding/json"

// Actualize builds the params
func (lpm LongParamList) Actualize(ec CelEnvCollection) (LongKeyValueList, error) {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	var m []LongKeyValue
	for _, param := range lpm.Params {
		var val int64
		var err error

		if len(param.Program) > 0 {
			val, err = ec.EvalInt64(param.Program)
		} else {
			val, err = param.WeightTable.Generate()
		}
		if err != nil {
			return LongKeyValueList{m}, err
		}
		m = append(m, LongKeyValue{
			Key:   param.Key,
			Value: val,
		})
	}
	return LongKeyValueList{m}, nil
}

type serializeLongKeyValueList struct {
	List []LongKeyValue
}

func (l LongKeyValueList) MarshalJSON() ([]byte, error) {
	var res serializeLongKeyValueList
	for _, val := range l.List {
		res.List = append(res.List, val)
	}
	return json.Marshal(res)
}

func (l *LongKeyValueList) UnmarshalJSON(data []byte) error {
	var res serializeLongKeyValueList
	err := json.Unmarshal(data, &res)
	if err != nil {
		return err
	}

	for _, val := range res.List {
		l.List = append(l.List, val)
	}
	return nil
}
