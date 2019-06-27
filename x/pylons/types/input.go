package types

import (
	"fmt"
)

// Input is the game elements that are needs as inputs to a recipe
type Input struct {
	Item  string
	Count int64
}

func (ip Input) String() string {
	return fmt.Sprintf(`Input{
		Item: %s,
		Count: %d,
		}`, ip.Item, ip.Count)
}

type InputList []Input

func (ipl InputList) String() string {
	output := "InputList{"

	for _, input := range ipl {
		output += input.String() + ",\n"
	}

	output += "}"
	return output

}
