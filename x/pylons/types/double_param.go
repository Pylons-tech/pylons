package types

import (
	"fmt"
	"math"
	"reflect"
	"strconv"
)

var floatType = reflect.TypeOf(float64(0))
var stringType = reflect.TypeOf("")

func getFloat(unk interface{}) (float64, error) {
	switch i := unk.(type) {
	case float64:
		return i, nil
	case float32:
		return float64(i), nil
	case int64:
		return float64(i), nil
	case int32:
		return float64(i), nil
	case int:
		return float64(i), nil
	case uint64:
		return float64(i), nil
	case uint32:
		return float64(i), nil
	case uint:
		return float64(i), nil
	case string:
		return strconv.ParseFloat(i, 64)
	default:
		v := reflect.ValueOf(unk)
		v = reflect.Indirect(v)
		if v.Type().ConvertibleTo(floatType) {
			fv := v.Convert(floatType)
			return fv.Float(), nil
		} else if v.Type().ConvertibleTo(stringType) {
			sv := v.Convert(stringType)
			s := sv.String()
			return strconv.ParseFloat(s, 64)
		} else {
			return math.NaN(), fmt.Errorf("Can't convert %v to float64", v.Type())
		}
	}
}

// Actualize creates a (key, value) list from ParamList
func (dpm DoubleParamList) Actualize(ec CelEnvCollection) (DoubleKeyValueList, error) {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	var m []DoubleKeyValue
	for _, param := range dpm.List {
		var val float64
		var err error

		if len(param.Program) > 0 {
			val, err = ec.EvalFloat64(param.Program)
		} else {
			val, err = param.WeightTable.Generate()
		}
		if err != nil {
			return DoubleKeyValueList{m}, err
		}
		m = append(m, DoubleKeyValue{
			Key:   param.Key,
			Value: ToFloatString(val),
		})
	}
	return DoubleKeyValueList{m}, nil
}

//
//type serializeDoubleParamList struct {
//	List []DoubleKeyValue
//}
//
//func (d DoubleKeyValueList) MarshalJSON() ([]byte, error) {
//	var res serializeDoubleKeyValueList
//	for _, val := range d.List {
//		res.List = append(res.List, *val)
//	}
//	return json.Marshal(res)
//}
//
//func (d *DoubleKeyValueList) UnmarshalJSON(data []byte) error {
//	var res serializeDoubleKeyValueList
//	err := json.Unmarshal(data, &res)
//	if err != nil {
//		return err
//	}
//
//	for _, val := range res.List {
//		d.List = append(d.List, &val)
//	}
//	return nil
//}

//
//type serializeDoubleKeyValueList struct {
//	List []DoubleKeyValue
//}
//
//func (d DoubleKeyValueList) MarshalJSON() ([]byte, error) {
//	var res serializeDoubleKeyValueList
//	for _, val := range d.List {
//		res.List = append(res.List, *val)
//	}
//	return json.Marshal(res)
//}
//
//func (d *DoubleKeyValueList) UnmarshalJSON(data []byte) error {
//	var res serializeDoubleKeyValueList
//	err := json.Unmarshal(data, &res)
//	if err != nil {
//		return err
//	}
//
//	for _, val := range res.List {
//		d.List = append(d.List, &val)
//	}
//	return nil
//}
