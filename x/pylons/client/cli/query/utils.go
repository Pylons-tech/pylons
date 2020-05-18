package query

const (
	// BroadcastBlock defines a tx broadcasting mode where the client waits for
	// the tx to be committed in a block.
	BroadcastBlock = "block"
	// BroadcastSync defines a tx broadcasting mode where the client waits for
	// a CheckTx execution response only.
	BroadcastSync = "sync"
	// BroadcastAsync defines a tx broadcasting mode where the client returns
	// immediately.
	BroadcastAsync = "async"
	FlagNode               = "node"
	FlagFrom               = "from"
	FlagBroadcastMode      = "broadcast-mode"
	FlagKeyringBackend     = "keyring-backend"
)