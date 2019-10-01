package types

import "math/rand"

// WeightedParam is to make structs which is using weight to be based on
type WeightedParam interface {
	String() string
	GetWeight() int
	MarshalJSON() ([]byte, error)
	UnmarshalJSON([]byte) error
}

// ItemOutputList is a list of Item outputs
type WeightedParamList []WeightedParam

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

func (wpl *WeightedParamList) MarshalJSON() ([]byte, error) {

}

func (wpl *WeightedParamList) UnmarshalJSON(data []byte) error {

}
