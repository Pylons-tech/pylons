package types

import (
	"encoding/json"
	"math/rand"
)

// WeightedParam is to make structs which is using weight to be based on
type WeightedParam interface {
	String() string
	GetWeight() int
}

// ItemOutputList is a list of Item outputs
type WeightedParamList []WeightedParam

type SerializeWeightedParamList struct {
	CoinOutputs []CoinOutput
	ItemOutputs []ItemOutput
}

func (wpl WeightedParamList) String() string {
	itm := "WeightedParamList{"

	for _, output := range wpl {
		itm += output.String() + ",\n"
	}

	itm += "}"
	return itm
}

func (wpl *WeightedParamList) Actualize() WeightedParam {
	lastWeight := 0
	var weights []int
	for _, wp := range *wpl {
		lastWeight += wp.GetWeight()
		weights = append(weights, lastWeight)
	}
	randWeight := rand.Intn(lastWeight)

	first := 0
	chosenIndex := -1
	for i, weight := range weights {
		if randWeight >= first && randWeight <= weight {
			chosenIndex = i
			break
		}
		first = weight
	}
	return (*wpl)[chosenIndex]
}

func (wpl WeightedParamList) MarshalJSON() ([]byte, error) {
	var swpl SerializeWeightedParamList
	for _, wp := range wpl {
		switch wp.(type) {
		case CoinOutput:
			if coinOutput, ok := wp.(CoinOutput); ok {
				swpl.CoinOutputs = append(swpl.CoinOutputs, coinOutput)
			}
		case ItemOutput:
			if itemOutput, ok := wp.(ItemOutput); ok {
				swpl.ItemOutputs = append(swpl.ItemOutputs, itemOutput)
			}
		default:
		}
	}
	return json.Marshal(swpl)
}

func (wpl *WeightedParamList) UnmarshalJSON(data []byte) error {
	var swpl SerializeWeightedParamList
	err := json.Unmarshal(data, &swpl)
	if err != nil {
		return err
	}

	for _, co := range swpl.CoinOutputs {
		*wpl = append(*wpl, co)
	}
	for _, io := range swpl.ItemOutputs {
		*wpl = append(*wpl, io)
	}
	return nil
}
