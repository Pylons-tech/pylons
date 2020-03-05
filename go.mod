module github.com/Pylons-tech/pylons

require (
	github.com/Workiva/go-datastructures v1.0.50
	github.com/cosmos/cosmos-sdk v0.35.0
	github.com/ethereum/go-ethereum v1.8.23 // indirect
	github.com/google/cel-go v0.3.2
	github.com/google/gofuzz v1.0.0 // indirect
	github.com/google/uuid v1.1.1
	github.com/gorilla/mux v1.7.0
	github.com/mattn/go-isatty v0.0.7 // indirect
	github.com/prometheus/procfs v0.0.0-20190328153300-af7bedc223fb // indirect
	github.com/spf13/afero v1.2.2 // indirect
	github.com/spf13/cobra v0.0.3
	github.com/spf13/viper v1.0.3
	github.com/stretchr/testify v1.3.0
	github.com/syndtr/goleveldb v1.0.0 // indirect
	github.com/tendermint/go-amino v0.14.1
	github.com/tendermint/tendermint v0.31.5
	github.com/zondax/ledger-go v0.8.0 // indirect
	golang.org/x/sync v0.0.0-20190227155943-e225da77a7e6 // indirect
	golang.org/x/sys v0.0.0-20190329044733-9eb1bfa1ce65 // indirect
	google.golang.org/genproto v0.0.0-20190819201941-24fa4b261c55
	google.golang.org/grpc v1.19.1 // indirect
)

replace golang.org/x/crypto => github.com/tendermint/crypto v0.0.0-20180820045704-3764759f34a5

go 1.13
