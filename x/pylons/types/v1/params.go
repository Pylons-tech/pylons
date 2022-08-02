package v1

import (
	"gopkg.in/yaml.v2"
)

// String implements stringer interface
func (p Params) String() string {
	out, _ := yaml.Marshal(p)
	return string(out)
}
