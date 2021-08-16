package types

var (
	nodeVersionString = "dev"
)

func SetNodeVersionString(s string) {
	nodeVersionString = s
}

func GetNodeVersionString() string {
	return nodeVersionString
}
