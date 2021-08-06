package types

import (
	"errors"
	"fmt"
	"math/rand"
	"reflect"
	"regexp"

	"github.com/google/uuid"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/config"
)

type StringKeyValueList []StringKeyValue
type DoubleKeyValueList []DoubleKeyValue
type LongKeyValueList []LongKeyValue

type LongParamList []LongParam
type DoubleParamList []DoubleParam
type StringParamList []StringParam

type DoubleInputParamList []DoubleInputParam
type LongInputParamList []LongInputParam
type StringInputParamList []StringInputParam
type WeightedOutputsList []WeightedOutputs

type CoinInputList []CoinInput
type ItemList []Item
type ItemInputList []ItemInput
type TradeItemInputList []TradeItemInput

type DoubleWeightTable []DoubleWeightRange
type IntWeightTable []IntWeightRange

// Tier defines the kind of cookbook this is
type Tier struct {
	Level int64
	Fee   sdk.Coins
}

// ItemHistory is a struct to store Item use history
type ItemHistory struct {
	ID       string
	Owner    sdk.AccAddress
	ItemID   string
	RecipeID string
	TradeID  string
}

// ExecuteRecipeScheduleOutput is a struct that shows how execute recipe schedule output works
type ExecuteRecipeScheduleOutput struct {
	ExecID string
}

type StripeCheckoutScheduleOutput struct {
	SessionID string
}

type StripeCreateProductScheduleOutput struct {
	ProductID string
}

type StripeCreatePriceScheduleOutput struct {
	PriceID string
}

type StripeCreateSkuScheduleOutput struct {
	SKUID string
}

// ExecuteRecipeSerialize is a struct for execute recipe result serialization
type ExecuteRecipeSerialize struct {
	Type   string `json:"type"`   // COIN or ITEM
	Coin   string `json:"coin"`   // used when type is ITEM
	Amount int64  `json:"amount"` // used when type is COIN
	ItemID string `json:"itemID"` // used when type is ITEM
}

// Reader struct is for entropy set on uuid
type Reader struct{}

// Tier defines the kind of cookbook this is
const (
	// Basic is the free int64 which does allow developers to use pylons ( paid currency ) in their
	// games
	Basic int64 = iota
	Premium
)

const (
	Pylon = "pylon"

	TypeCookbook    = "cookbook"
	TypeRecipe      = "recipe"
	TypeTrade       = "trade"
	TypeItem        = "item"
	TypeItemHistory = "item_history"
	TypeExecution   = "execution"
)

// tier fee types
var (
	BasicFee   = NewPylon(10000) // fee charged to create a basic cookbook
	PremiumFee = NewPylon(50000) // fee charged to create a premium cookbook
)

// BasicTier is the cookbook tier which doesn't allow paid recipes which means
// the developers cannot have recipes where they can actually carge a fee in pylons
var BasicTier = Tier{
	Level: Basic,
	Fee:   BasicFee,
}

// PremiumTier the cookbook tier which does allow paid recipes
var PremiumTier = Tier{
	Level: Premium,
	Fee:   PremiumFee,
}

// NewPylon Returns pylon currency
func NewPylon(amount int64) sdk.Coins {
	return sdk.Coins{sdk.NewInt64Coin(Pylon, amount)}
}

// NewCookbook return a new Cookbook
func NewCookbook(sEmail string, sender sdk.AccAddress, version, name, description, developer string, cpb int64) Cookbook {
	cb := Cookbook{
		NodeVersion:  "0.0.1",
		Name:         name,
		Description:  description,
		Version:      version,
		Developer:    developer,
		SupportEmail: sEmail,
		Sender:       sender.String(),
		CostPerBlock: cpb,
	}

	cb.ID = KeyGen(sender)
	return cb
}

// NewRecipe creates a new recipe
func NewRecipe(recipeName, cookbookID, description string,
	coinInputs CoinInputList, // coins to put on the recipe
	itemInputs ItemInputList, // items to put on the recipe
	entries EntriesList, // items that can be created from recipe
	outputs WeightedOutputsList, // item outputs listing by weight value
	blockInterval int64, // The amount of time to wait to finish running the recipe
	sender sdk.AccAddress,
	extraInfo string) Recipe {
	rcp := Recipe{
		NodeVersion:   "0.0.1",
		Name:          recipeName,
		CookbookID:    cookbookID,
		CoinInputs:    coinInputs,
		ItemInputs:    itemInputs,
		Entries:       entries,
		Outputs:       outputs,
		BlockInterval: blockInterval,
		Description:   description,
		Sender:        sender.String(),
		ExtraInfo:     extraInfo,
	}

	rcp.ID = KeyGen(sender)
	return rcp
}

// NewItem create a new item with an auto generated ID
func NewItem(cookbookID string, doubles DoubleKeyValueList, longs LongKeyValueList, strings StringKeyValueList, sender sdk.AccAddress, blockHeight int64, transferFee int64) Item {
	item := Item{
		NodeVersion: "0.0.1",
		CookbookID:  cookbookID,
		Doubles:     doubles,
		Longs:       longs,
		Strings:     strings,
		Sender:      sender.String(),
		// By default all items are tradable
		Tradable:    true,
		LastUpdate:  blockHeight,
		TransferFee: transferFee,
	}
	item.ID = KeyGen(sender)

	return item
}

// Equals compares two items
func (it Item) Equals(other Item) bool {
	return it.ID == other.ID &&
		reflect.DeepEqual(it.Doubles, other.Doubles) &&
		reflect.DeepEqual(it.Strings, other.Strings) &&
		reflect.DeepEqual(it.Longs, other.Longs) &&
		reflect.DeepEqual(it.CookbookID, other.CookbookID)
}

// MatchItemInput checks if the ItemInput matches the item
func (it Item) MatchItemInput(other ItemInput) bool {
	return reflect.DeepEqual(it.Doubles, other.Doubles) &&
		reflect.DeepEqual(it.Strings, other.Strings) &&
		reflect.DeepEqual(it.Longs, other.Longs)
}

// NewTradeError check if an item can be sent to someone else
func (it Item) NewTradeError() error {
	if !it.Tradable {
		return errors.New("Item Tradable flag is not set")
	}
	if it.OwnerRecipeID != "" {
		return errors.New("Item is owned by a recipe")
	}
	if it.OwnerTradeID != "" {
		return errors.New("Item is owned by a trade")
	}
	return nil
}

// FulfillTradeError check if an item can be sent to someone else
func (it Item) FulfillTradeError(tradeID string) error {
	if !it.Tradable {
		return errors.New("Item Tradable flag is not set")
	}
	if it.OwnerRecipeID != "" {
		return errors.New("Item is owned by a recipe")
	}
	if it.OwnerTradeID != tradeID {
		return errors.New("Item is not owned by the trade")
	}
	return nil
}

// NewExecution return a new Execution
func NewExecution(recipeID string, cookbookID string, ci sdk.Coins,
	itemInputs []Item,
	blockHeight int64, sender sdk.AccAddress,
	completed bool) Execution {

	exec := Execution{
		NodeVersion: "0.0.1",
		RecipeID:    recipeID,
		CookbookID:  cookbookID,
		CoinInputs:  ci,
		ItemInputs:  itemInputs,
		BlockHeight: blockHeight,
		Sender:      sender.String(),
		Completed:   completed,
	}

	exec.ID = KeyGen(sender)
	return exec
}

// NewRecipeExecutionError is a utility that shows if Recipe is compatible with recipe execution
func (it Item) NewRecipeExecutionError() error {
	if it.OwnerRecipeID != "" {
		return errors.New("Item is owned by a recipe")
	}
	if it.OwnerTradeID != "" {
		return errors.New("Item is owned by a trade")
	}
	return nil
}

// SetTransferFee set item's TransferFee
func (it *Item) SetTransferFee(transferFee int64) {
	it.TransferFee = transferFee
}

// GetTransferFee set item's TransferFee
func (it Item) CalculateTransferFee() int64 {
	minItemTransferFee := config.Config.Fee.MinItemTransferFee
	maxItemTransferFee := config.Config.Fee.MaxItemTransferFee
	return Min(Max(it.TransferFee, minItemTransferFee), maxItemTransferFee)
}

// FindDouble is a function to get a double attribute from an item
func (it Item) FindDouble(key string) (sdk.Dec, bool) {
	for _, v := range it.Doubles {
		if v.Key == key {
			return v.Value, true
		}
	}
	return sdk.NewDec(0), false
}

// FindDoubleKey is a function get double key index
func (it Item) FindDoubleKey(key string) (int, bool) {
	for i, v := range it.Doubles {
		if v.Key == key {
			return i, true
		}
	}
	return 0, false
}

// FindLong is a function to get a long attribute from an item
func (it Item) FindLong(key string) (int, bool) {
	for _, v := range it.Longs {
		if v.Key == key {
			return int(v.Value), true
		}
	}
	return 0, false
}

// FindLongKey is a function to get long key index
func (it Item) FindLongKey(key string) (int, bool) {
	for i, v := range it.Longs {
		if v.Key == key {
			return i, true
		}
	}
	return 0, false
}

// FindString is a function to get a string attribute from an item
func (it Item) FindString(key string) (string, bool) {
	for _, v := range it.Strings {
		if v.Key == key {
			return v.Value, true
		}
	}
	return "", false
}

// FindStringKey is a function to get string key index
func (it Item) FindStringKey(key string) (int, bool) {
	for i, v := range it.Strings {
		if v.Key == key {
			return i, true
		}
	}
	return 0, false
}

// SetString set item's string attribute
func (it Item) SetString(key string, value string) bool {
	for i, v := range it.Strings {
		if v.Key == key {
			it.Strings[i].Value = value
			return true
		}
	}
	return false
}

// MatchError checks if all the constraint match the given item
func (ii ItemInput) MatchError(item Item, ec CelEnvCollection) error {

	if ii.Doubles != nil {
		for _, param := range ii.Doubles {
			double, ok := item.FindDouble(param.Key)
			if !ok {
				return fmt.Errorf("%s key is not available on the item: item_id=%s", param.Key, item.ID)
			}

			if !param.Has(double) {
				return fmt.Errorf("%s key range does not match: item_id=%s", param.Key, item.ID)
			}
		}
	}

	if ii.Longs != nil {
		for _, param := range ii.Longs {
			long, ok := item.FindLong(param.Key)
			if !ok {
				return fmt.Errorf("%s key is not available on the item: item_id=%s", param.Key, item.ID)
			}

			if !param.Has(long) {
				return fmt.Errorf("%s key range does not match: item_id=%s", param.Key, item.ID)
			}
		}
	}

	if ii.Strings != nil {
		for _, param := range ii.Strings {
			str, ok := item.FindString(param.Key)
			if !ok {
				return fmt.Errorf("%s key is not available on the item: item_id=%s", param.Key, item.ID)
			}
			if str != param.Value {
				return fmt.Errorf("%s key value does not match: item_id=%s", param.Key, item.ID)
			}
		}
	}

	if !ii.TransferFee.Has(item.TransferFee) {
		return fmt.Errorf("item transfer fee does not match: fee=%d range=%s", item.TransferFee, ii.TransferFee.String())
	}

	for _, param := range ii.Conditions.Doubles {
		double, err := ec.EvalFloat64(param.Key)
		if err != nil {
			return fmt.Errorf("%s expression is invalid: item_id=%s, %+v", param.Key, item.ID, err)
		}

		dec, err := sdk.NewDecFromStr(fmt.Sprintf("%v", double))
		if err != nil {
			return err
		}

		if !param.Has(dec) {
			return fmt.Errorf("%s expression range does not match: item_id=%s", param.Key, item.ID)
		}
	}

	for _, param := range ii.Conditions.Longs {
		long, err := ec.EvalInt64(param.Key)
		if err != nil {
			return fmt.Errorf("%s expression is invalid: item_id=%s, %+v", param.Key, item.ID, err)
		}

		if !param.Has(int(long)) {
			return fmt.Errorf("%s expression range does not match: item_id=%s", param.Key, item.ID)
		}
	}

	for _, param := range ii.Conditions.Strings {
		str, err := ec.EvalString(param.Key)
		if err != nil {
			return fmt.Errorf("%s expression is invalid: item_id=%s, %+v", param.Key, item.ID, err)
		}
		if str != param.Value {
			return fmt.Errorf("%s expression value does not match: item_id=%s", param.Key, item.ID)
		}
	}
	return nil
}

// IDValidationError check if ID can be used as a variable name if available
func (ii ItemInput) IDValidationError() error {
	if len(ii.ID) == 0 {
		return nil
	}

	regex := regexp.MustCompile(`^[a-zA-Z_][a-zA-Z_0-9]*$`)
	if regex.MatchString(ii.ID) {
		return nil
	}

	return fmt.Errorf("ID is not empty nor fit the regular expression ^[a-zA-Z_][a-zA-Z_0-9]*$: id=%s", ii.ID)
}

// NewItemModifyOutput returns ItemOutput that is modified from item input
func NewItemModifyOutput(ID string, ItemInputRef string, ModifyParams ItemModifyParams) ItemModifyOutput {
	return ItemModifyOutput{
		ID:           ID,
		ItemInputRef: ItemInputRef,
		Doubles:      ModifyParams.Doubles,
		Longs:        ModifyParams.Longs,
		Strings:      ModifyParams.Strings,
		TransferFee:  ModifyParams.TransferFee,
	}
}

// SetTransferFee set generate item's transfer fee
func (mit *ItemModifyOutput) SetTransferFee(transferFee int64) {
	mit.TransferFee = transferFee
}

// NewItemOutput returns new ItemOutput generated from recipe
func NewItemOutput(ID string, Doubles DoubleParamList, Longs LongParamList, Strings StringParamList, TransferFee int64) ItemOutput {
	return ItemOutput{
		ID:          ID,
		Doubles:     Doubles,
		Longs:       Longs,
		Strings:     Strings,
		TransferFee: TransferFee,
	}
}

func NewStripePrice(amount int64, currency string, description string, images []string, name string, quantity int64) StripePrice {
	return StripePrice{
		Amount:      amount,
		Currency:    currency,
		Description: description,
		Images:      images,
		Name:        name,
		Quantity:    quantity,
	}
}

// SetTransferFee set generate item's transfer fee
func (io *ItemOutput) SetTransferFee(transferFee int64) {
	io.TransferFee = transferFee
}

// Item function acualize an item from item output data
func (io ItemOutput) Item(cookbook string, sender sdk.AccAddress, ec CelEnvCollection) (Item, error) {
	// This function is used on ExecuteRecipe's AddExecutedResult, and it's
	// not acceptable to provide predefined GUID
	dblActualize, err := DoubleParamList(io.Doubles).Actualize(ec)
	if err != nil {
		return Item{}, err
	}
	longActualize, err := LongParamList(io.Longs).Actualize(ec)
	if err != nil {
		return Item{}, err
	}
	stringActualize, err := StringParamList(io.Strings).Actualize(ec)
	if err != nil {
		return Item{}, err
	}

	transferFee := io.TransferFee

	lastBlockHeight := ec.variables["lastBlockHeight"].(int64)

	return NewItem(cookbook, dblActualize, longActualize, stringActualize, sender, lastBlockHeight, transferFee), nil
}

// NewTrade creates a new trade
func NewTrade(extraInfo string,
	coinInputs CoinInputList, // coinOutputs CoinOutputList,
	itemInputs TradeItemInputList, // itemOutputs ItemOutputList,
	coinOutputs sdk.Coins, // newly created param instead of coinOutputs and itemOutputs
	itemOutputs ItemList,
	sender sdk.AccAddress) Trade {
	trd := Trade{
		NodeVersion: "0.0.1",
		CoinInputs:  coinInputs,
		ItemInputs:  itemInputs,
		CoinOutputs: coinOutputs,
		ItemOutputs: itemOutputs,
		ExtraInfo:   extraInfo,
		Sender:      sender.String(),
	}

	trd.ID = KeyGen(sender)
	return trd
}

// GetItemInputRefIndex get item input index from ref string
func (rcp Recipe) GetItemInputRefIndex(inputRef string) int {
	for idx, input := range rcp.ItemInputs {
		if input.ID == inputRef {
			return idx
		}
	}
	return -1
}

// ToCoins converts to coins
func (cil CoinInputList) ToCoins() sdk.Coins {
	var coins sdk.Coins
	for _, ci := range cil {
		coins = append(coins, sdk.NewInt64Coin(ci.Coin, ci.Count))
	}
	coins = coins.Sort()
	return coins
}

// Equal compares two inputlists
func (cil CoinInputList) Equal(other CoinInputList) bool {
	for _, inp := range cil {
		found := false
		for _, oinp := range other {
			if oinp.Coin == inp.Coin && oinp.Count == inp.Count {
				found = true
				break
			}
		}
		if !found {
			return false
		}
	}

	return true
}

// Validate is a function to check ItemInputList is valid
func (iil ItemInputList) Validate() error {
	return nil
}

// MatchError checks if all the constraint match the given item
func (tii TradeItemInput) MatchError(item Item, ec CelEnvCollection) error {
	if item.CookbookID != tii.CookbookID {
		return fmt.Errorf("cookbook id does not match")
	}
	return tii.ItemInput.MatchError(item, ec)
}

// Validate is a function to check ItemInputList is valid
func (tiil TradeItemInputList) Validate() error {
	for _, ii := range tiil {
		if ii.CookbookID == "" {
			return errors.New("There should be no empty cookbook ID inputs for trades")
		}
	}
	return nil
}

// NewEntropyReader create an entropy reader
func NewEntropyReader() *Reader {
	return &Reader{}
}

func (r Reader) Read(b []byte) (n int, err error) {
	entropy := []byte{}
	for i := 0; i < len(b); i++ {
		entropy = append(entropy, byte(rand.Intn(256)))
	}

	n = copy(b, entropy)
	return n, nil
}

// ValidateLevel validates the level
func ValidateLevel(level int64) error {
	if level == Basic || level == Premium {
		return nil
	}

	return errors.New("Invalid cookbook plan")
}

// KeyGen generates key for the store
func KeyGen(sender sdk.AccAddress) string {
	id := uuid.New()
	return sender.String() + id.String()
}

// ValidateEmail validates the email string provided
func ValidateEmail(email string) error {
	exp := regexp.MustCompile(`^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z0-9]{2,})$`)
	if exp.MatchString(email) {
		return nil
	}

	return errors.New("invalid email address")
}

// ValidateVersion validates the SemVer
func ValidateVersion(s string) error {
	regex := regexp.MustCompile(`^([0-9]+)\.([0-9]+)\.([0-9]+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+[0-9A-Za-z-]+)?$`)
	if regex.MatchString(s) {
		return nil
	}

	return errors.New("invalid semVer")
}

// Reference: BlockHeader struct is available at github.com/tendermint/tendermint@v0.33.4/types/proto3/block.pb.go:
// type Header struct {
// 		AppHash            []byte `protobuf:"bytes,11,opt,name=app_hash,json=appHash,proto3" json:"app_hash,omitempty"`
//   	...
// }

// RandomSeed calculate random seed from context and entity count
func RandomSeed(ctx sdk.Context, entityCount int) int64 {
	header := ctx.BlockHeader()
	appHash := header.AppHash
	seedValue := 0
	for i, bytv := range appHash { // len(appHash) = 11
		intv := int(bytv)
		seedValue += (i*i + 1) * intv
	}
	fmt.Println("RandomSeed entityCount:", entityCount, "BlockHeight:", header.Height)
	return int64(seedValue + entityCount)
}

// Max returns the larger of x or y.
func Max(x, y int64) int64 {
	if x < y {
		return y
	}
	return x
}

// Min returns the larger of x or y.
func Min(x, y int64) int64 {
	if x > y {
		return y
	}
	return x
}
