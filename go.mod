module github.com/Pylons-tech/pylons

go 1.13

require (
	github.com/Pylons-tech/pylons_sdk v0.0.0-20201211010647-2faf3ce715c8
	github.com/cosmos/cosmos-sdk v0.41.0
	github.com/cosmos/go-bip39 v1.0.0
	github.com/google/cel-go v0.5.1
	github.com/google/uuid v1.1.2
	github.com/gorilla/mux v1.8.0
	github.com/sirupsen/logrus v1.6.0
	github.com/spf13/cobra v1.1.1
	github.com/spf13/viper v1.7.1
	github.com/stretchr/testify v1.7.0
	github.com/tendermint/go-amino v0.16.0
	github.com/tendermint/tendermint v0.34.3
	github.com/tendermint/tm-db v0.6.3
	github.com/tyler-smith/go-bip39 v1.0.2
	google.golang.org/genproto v0.0.0-20210114201628-6edceaf6022f
	gopkg.in/yaml.v2 v2.4.0
)

replace github.com/gogo/protobuf => github.com/regen-network/protobuf v1.3.3-alpha.regen.1
