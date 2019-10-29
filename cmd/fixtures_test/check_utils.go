package fixtures

type ItemCheck struct {
	Name  string `json:"name"`
	Count string `json:"count"`
}
type CoinCheck struct {
	Name   string `json:"name"`
	Amount string `json:"amount"`
}
type TxResultCheck struct {
	Status  string `json:"status"`
	Message string `json:"message"`
}
type UserPropertyCheck struct {
	Cookbooks []string    `json:"cookbooks"`
	Recipes   []string    `json:"recipes"`
	Items     []ItemCheck `json:"items"`
	Coins     []CoinCheck `json:"coins"`
}
type OutputCheck struct {
	TxResult TxResultCheck     `json:"txResult"`
	Property UserPropertyCheck `json:"property"`
}
type FixtureStep struct {
	Action               string      `json:"action"`
	ParamsRef            string      `json:"paramsRef"`
	ParamsRefDescription string      `json:"paramsRefDescription"`
	Output               OutputCheck `json:"output"`
}
