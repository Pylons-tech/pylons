package fixturetest

import (
	"encoding/json"
	"flag"
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	fixturetestSDK "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test"
	"github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test/evtesting"
	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

var runSerialMode bool = false
var useRest bool = false
var useKnownCookbook = false
var scenarios = ""

func init() {
	flag.BoolVar(&runSerialMode, "runserial", false, "true/false value to check if test will be running in parallel")
	flag.BoolVar(&useRest, "userest", false, "use rest endpoint for Tx send")
	flag.BoolVar(&useKnownCookbook, "use-known-cookbook", false, "use existing cookbook or not")
	flag.StringVar(&scenarios, "scenarios", "", "custom scenario file names")
}

// UpdateReceiverKeyToAddress is a function to update receiver key to receiver's address
func UpdateReceiverKeyToAddress(bytes []byte, t *evtesting.T) []byte {
	raw := fixturetestSDK.UnmarshalIntoEmptyInterface(bytes, t)

	receiverName, ok := raw["Receiver"].(string)
	t.MustTrue(ok)
	raw["Receiver"] = inttestSDK.GetAccountAddr(receiverName, t)
	newBytes, err := json.Marshal(raw)
	t.MustNil(err)
	return newBytes
}

// SendItemsMsgFromRef is a function to collect SendItems from reference string
func SendItemsMsgFromRef(ref string, t *evtesting.T) msgs.MsgSendItems {
	byteValue := fixturetestSDK.ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := fixturetestSDK.UpdateSenderKeyToAddress(byteValue, t)
	newByteValue = UpdateReceiverKeyToAddress(newByteValue, t)

	ItemIDs := fixturetestSDK.GetItemIDsFromNames(newByteValue, false, t)

	var siType struct {
		Sender   sdk.AccAddress
		Receiver sdk.AccAddress
		ItemIDs  []string `json:"ItemIDs"`
	}

	err := inttestSDK.GetAminoCdc().UnmarshalJSON(newByteValue, &siType)
	if err != nil {
		t.WithFields(evtesting.Fields{
			"siType":    inttestSDK.AminoCodecFormatter(siType),
			"new_bytes": string(newByteValue),
			"error":     err,
		}).Fatal("error reading using GetAminoCdc")
	}
	t.MustNil(err)

	return msgs.NewMsgSendItems(ItemIDs, siType.Sender, siType.Receiver)
}

// RunSendItems is a function to send items to another user
func RunSendItems(step fixturetestSDK.FixtureStep, t *evtesting.T) {

	if step.ParamsRef != "" {
		siMsg := SendItemsMsgFromRef(step.ParamsRef, t)
		txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, siMsg, siMsg.Sender.String(), true)
		if err != nil {
			if step.Output.TxResult.BroadcastError != "" {
				t.MustTrue(strings.Contains(err.Error(), step.Output.TxResult.BroadcastError))
			} else {
				t.WithFields(evtesting.Fields{
					"error": err,
				}).Fatal("unexpected transaction broadcast error")
			}
			return
		}

		err = inttestSDK.WaitForNextBlock()
		if err != nil {
			t.WithFields(evtesting.Fields{
				"error": err,
			}).Fatal("error waiting for fulfilling trade")
		}

		if len(step.Output.TxResult.ErrorLog) > 0 {
		} else {
			txHandleResBytes, err := inttestSDK.WaitAndGetTxData(txhash, inttestSDK.GetMaxWaitBlock(), t)
			t.MustNil(err)
			fixturetestSDK.CheckErrorOnTxFromTxHash(txhash, t)
			resp := handlers.SendItemsResponse{}
			err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
			if err != nil {
				t.WithFields(evtesting.Fields{
					"txhash": txhash,
				}).Fatal("failed to parse transaction result")
			}
			t.MustTrue(resp.Status == step.Output.TxResult.Status)
			if len(step.Output.TxResult.Message) > 0 {
				t.MustTrue(resp.Message == step.Output.TxResult.Message)
			}
		}
	}
}

func TestFixturesViaCLI(t *testing.T) {
	flag.Parse()
	fixturetestSDK.FixtureTestOpts.IsParallel = !runSerialMode
	fixturetestSDK.FixtureTestOpts.CreateNewCookbook = !useKnownCookbook
	if useRest {
		inttestSDK.CLIOpts.RestEndpoint = "http://localhost:1317"
	}
	inttestSDK.CLIOpts.MaxBroadcast = 50
	fixturetestSDK.RegisterDefaultActionRunners()
	// Register custom action runners
	fixturetestSDK.RegisterActionRunner("send_items", RunSendItems)
	scenarioFileNames := []string{}
	if len(scenarios) > 0 {
		scenarioFileNames = strings.Split(scenarios, ",")
	}
	fixturetestSDK.RunTestScenarios("scenarios", scenarioFileNames, t)
}
