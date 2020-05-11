package types

import (
	"math/rand"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// basic block info
// Version Version   `protobuf:"bytes,1,opt,name=version,proto3" json:"version"`
// ChainID string    `protobuf:"bytes,2,opt,name=chain_id,json=chainId,proto3" json:"chain_id,omitempty"`
// Height  int64     `protobuf:"varint,3,opt,name=height,proto3" json:"height,omitempty"`
// Time    time.Time `protobuf:"bytes,4,opt,name=time,proto3,stdtime" json:"time"`

// prev block info
// LastBlockId BlockID `protobuf:"bytes,5,opt,name=last_block_id,json=lastBlockId,proto3" json:"last_block_id"`

// hashes of block data
// LastCommitHash []byte `protobuf:"bytes,6,opt,name=last_commit_hash,json=lastCommitHash,proto3" json:"last_commit_hash,omitempty"`
// DataHash       []byte `protobuf:"bytes,7,opt,name=data_hash,json=dataHash,proto3" json:"data_hash,omitempty"`
// hashes from the app output from the prev block
// ValidatorsHash     []byte `protobuf:"bytes,8,opt,name=validators_hash,json=validatorsHash,proto3" json:"validators_hash,omitempty"`
// NextValidatorsHash []byte `protobuf:"bytes,9,opt,name=next_validators_hash,json=nextValidatorsHash,proto3" json:"next_validators_hash,omitempty"`
// ConsensusHash      []byte `protobuf:"bytes,10,opt,name=consensus_hash,json=consensusHash,proto3" json:"consensus_hash,omitempty"`
// AppHash            []byte `protobuf:"bytes,11,opt,name=app_hash,json=appHash,proto3" json:"app_hash,omitempty"`
// LastResultsHash    []byte `protobuf:"bytes,12,opt,name=last_results_hash,json=lastResultsHash,proto3" json:"last_results_hash,omitempty"`

// consensus info
// EvidenceHash         []byte   `protobuf:"bytes,13,opt,name=evidence_hash,json=evidenceHash,proto3" json:"evidence_hash,omitempty"`
// ProposerAddress      []byte   `protobuf:"bytes,14,opt,name=proposer_address,json=proposerAddress,proto3" json:"proposer_address,omitempty"`
// XXX_NoUnkeyedLiteral struct{} `json:"-"`
// XXX_unrecognized     []byte   `json:"-"`
// XXX_sizecache        int32    `json:"-"`

func RandomSeed(ctx sdk.Context) int64 {
	header := ctx.BlockHeader()
	appHash := header.AppHash
	seedValue := 0
	for i, bytv := range appHash { // len(appHash) = 11
		intv := int(bytv)
		seedValue = (i*i + 1) * intv
	}
	return int64(seedValue)
}

type Reader struct {
}

func NewEntropyReader() *Reader {
	return &Reader{}
}

func (r Reader) Read(b []byte) (n int, err error) {
	entropy := []byte{}
	for i := 0; i < len(b); i ++ {
		entropy = append(entropy, byte(rand.Intn(256)))
	}

	n = copy(b, entropy)
	return n, nil
}