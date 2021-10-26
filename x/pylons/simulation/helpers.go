package simulation

import (
	"math/rand"

	regen "github.com/zach-klippenstein/goregen"
)

func generateRandomUsername(r *rand.Rand) (ret string) {
	if r.Int63n(100) > 9 {
		ret, _ = regen.Generate("^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$")
	} else {
		ret = invalidField
	}
	return
}

func generateRandomStringID(r *rand.Rand) (ret string) {
	if r.Int63n(100) > 9 {
		ret, _ = regen.Generate("^[a-zA-Z_][a-zA-Z_0-9]*$")
	} else {
		ret = invalidField
	}
	return
}

func generateRandomEmail(r *rand.Rand) (ret string) {
	if r.Int63n(100) > 9 {
		ret, _ = regen.Generate("^([a-zA-Z0-9_\\-.]+)@([a-zA-Z0-9_\\-.]+)\\.([a-zA-Z0-9]{2,})$")
	} else {
		ret = invalidField
	}
	return
}
