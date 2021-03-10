package types

import "encoding/json"

// Actualize actualize string param using cel program
func (spm StringParamList) Actualize(ec CelEnvCollection) (StringKeyValueList, error) {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	var m []StringKeyValue
	for _, param := range spm.List {
		var val string
		var err error

		if len(param.Program) > 0 {
			val, err = ec.EvalString(param.Program)
		} else {
			val = param.Value
		}
		if err != nil {
			return StringKeyValueList{m}, err
		}
		m = append(m, StringKeyValue{
			Key:   param.Key,
			Value: val,
		})
	}
	return StringKeyValueList{m}, nil
}

type serializeStringKeyValueList struct {
	List []StringKeyValue
}

func (str StringKeyValueList) MarshalJSON() ([]byte, error) {
	var res serializeStringKeyValueList
	for _, val := range str.List {
		res.List = append(res.List, val)
	}
	return json.Marshal(res)
}

func (str *StringKeyValueList) UnmarshalJSON(data []byte) error {
	var res serializeStringKeyValueList
	err := json.Unmarshal(data, &res)
	if err != nil {
		return err
	}

	for _, val := range res.List {
		str.List = append(str.List, val)
	}
	return nil
}
