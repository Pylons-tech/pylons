package types

import "fmt"

// Output is the game elements that are needs as output to a recipe
type Output struct {
	Item  string
	Count int64
}

func (op Output) String() string {
	return fmt.Sprintf(`Output{
		Item: %s,
		Count: %d,
		}`, op.Item, op.Count)
}

// OutputList is the list of outputs
type OutputList []Output

func (opl OutputList) String() string {
	opt := "OutputList{"

	for _, output := range opl {
		opt += output.String() + ",\n"
	}

	opt += "}"
	return opt

}
