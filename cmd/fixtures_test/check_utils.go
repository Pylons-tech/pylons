package fixtureTest

import (
	"github.com/MikeSofaer/pylons/x/pylons/types"
)

type ItemCheck struct {
	StringKeys   []string                     `json:"stringKeys"`
	StringValues map[string]string            `json:"stringValues"`
	DblKeys      []string                     `json:"dblKeys"`
	DblValues    map[string]types.FloatString `json:"dblValues"`
	LongKeys     []string                     `json:"longKeys"`
	LongValues   map[string]int               `json:"longValues"`
}
type CoinCheck struct {
	Coin   string `json:"denom"`
	Amount int64  `json:"amount"`
}
type TxResultCheck struct {
	Status   string `json:"status"`
	Message  string `json:"message"`
	ErrorLog string `json:"errLog"`
}
type UserPropertyCheck struct {
	Owner     string      `json:"owner"`
	Cookbooks []string    `json:"cookbooks"`
	Recipes   []string    `json:"recipes"`
	Items     []ItemCheck `json:"items"`
	Coins     []CoinCheck `json:"coins"`
}
type OutputCheck struct {
	TxResult TxResultCheck     `json:"txResult"`
	Property UserPropertyCheck `json:"property"`
}

type RunAfterParams struct {
	PreCondition []string `json:"precondition"`
	BlockWait    int64    `json:"blockWait"`
}

type FixtureStep struct {
	ID            string         `json:"ID"`
	RunAfter      RunAfterParams `json:"runAfter"`
	Action        string         `json:"action"`
	BlockInterval int64          `json:"blockInterval"`
	ParamsRef     string         `json:"paramsRef"`
	Output        OutputCheck    `json:"output"`
}

func CheckItemWithStringKeys(item types.Item, stringKeys []string) bool {
	for _, sK := range stringKeys {
		keyExist := false
		for _, sKV := range item.Strings {
			if sK == sKV.Key {
				keyExist = true
			}
		}
		if !keyExist {
			return false
		}
	}
	return true
}

func CheckItemWithStringValues(item types.Item, stringValues map[string]string) bool {
	for sK, sV := range stringValues {
		keyExist := false
		for _, sKV := range item.Strings {
			if sK == sKV.Key && sV == sKV.Value {
				keyExist = true
			}
		}
		if !keyExist {
			return false
		}
	}
	return true
}

func CheckItemWithDblKeys(item types.Item, dblKeys []string) bool {
	for _, sK := range dblKeys {
		keyExist := false
		for _, sKV := range item.Doubles {
			if sK == sKV.Key {
				keyExist = true
			}
		}
		if !keyExist {
			return false
		}
	}
	return true
}

func CheckItemWithDblValues(item types.Item, dblValues map[string]types.FloatString) bool {
	for sK, sV := range dblValues {
		keyExist := false
		for _, sKV := range item.Doubles {
			if sK == sKV.Key && sV == sKV.Value {
				keyExist = true
			}
		}
		if !keyExist {
			return false
		}
	}
	return true
}

func CheckItemWithLongKeys(item types.Item, longKeys []string) bool {
	for _, sK := range longKeys {
		keyExist := false
		for _, sKV := range item.Longs {
			if sK == sKV.Key {
				keyExist = true
			}
		}
		if !keyExist {
			return false
		}
	}
	return true
}

func CheckItemWithLongValues(item types.Item, longValues map[string]int) bool {
	for sK, sV := range longValues {
		keyExist := false
		for _, sKV := range item.Longs {
			if sK == sKV.Key && sV == sKV.Value {
				keyExist = true
			}
		}
		if !keyExist {
			return false
		}
	}
	return true
}
