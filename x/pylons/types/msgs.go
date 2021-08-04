package types

import (
	"crypto"
	"crypto/rsa"
	"crypto/sha1"
	"crypto/x509"
	"encoding/base64"
	"encoding/json"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/config"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// NewMsgCreateAccount is a function to get MsgCreateAccount msg from required params
func NewMsgCreateAccount(requester string) MsgCreateAccount {
	return MsgCreateAccount{
		Requester: requester,
	}
}

// Route should return the name of the module
func (msg MsgCreateAccount) Route() string { return RouterKey }

// Type should return the action
func (msg MsgCreateAccount) Type() string { return "create_account" }

// ValidateBasic is a function to validate MsgCreateAccount msg
func (msg MsgCreateAccount) ValidateBasic() error {

	if msg.Requester == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Requester)
	}
	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgCreateAccount) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners encodes the message for signing
func (msg MsgCreateAccount) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Requester)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

// DefaultCostPerBlock the amount of pylons to be charged by default
const DefaultCostPerBlock int64 = 50 // Pylons

// NewMsgCreateCookbook a constructor for CreateCookbook msg
func NewMsgCreateCookbook(name, cookbookID, desc, developer string, version string, sEmail string, level int64, cpb int64, sender string) MsgCreateCookbook {
	return MsgCreateCookbook{
		CookbookID:   cookbookID,
		Name:         name,
		Description:  desc,
		Developer:    developer,
		Version:      version,
		SupportEmail: sEmail,
		Level:        level,
		Sender:       sender,
		CostPerBlock: cpb,
	}
}

// Route should return the name of the module
func (msg MsgCreateCookbook) Route() string { return RouterKey }

// Type should return the action
func (msg MsgCreateCookbook) Type() string { return "create_cookbook" }

// ValidateBasic validates the Msg
func (msg MsgCreateCookbook) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	if len(msg.Name) < 8 {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the name of the cookbook should have more than 8 characters")
	}

	if len(msg.Description) < 20 {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the description should have more than 20 characters")
	}

	if err := ValidateEmail(msg.SupportEmail); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err := ValidateLevel(msg.Level); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err := ValidateVersion(msg.Version); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgCreateCookbook) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgCreateCookbook) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

// NewMsgUpdateCookbook a constructor for UpdateCookbook msg
func NewMsgUpdateCookbook(ID, desc, developer, version, sEmail, sender string) MsgUpdateCookbook {
	return MsgUpdateCookbook{
		ID:           ID,
		Description:  desc,
		Developer:    developer,
		Version:      version,
		SupportEmail: sEmail,
		Sender:       sender,
	}
}

// Route should return the name of the module
func (msg MsgUpdateCookbook) Route() string { return RouterKey }

// Type should return the action
func (msg MsgUpdateCookbook) Type() string { return "update_cookbook" }

// ValidateBasic validates the Msg
func (msg MsgUpdateCookbook) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	if msg.ID == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the id of the cookbook should not be blank")
	}

	if len(msg.Description) < 20 {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the description should have more than 20 characters")
	}

	if err := ValidateEmail(msg.SupportEmail); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err := ValidateVersion(msg.Version); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgUpdateCookbook) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgUpdateCookbook) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

// NewMsgCreateRecipe a constructor for CreateRecipe msg
func NewMsgCreateRecipe(recipeName, cookbookID, recipeID, description string,
	coinInputs CoinInputList,
	itemInputs ItemInputList,
	entries EntriesList,
	outputs WeightedOutputsList,
	blockInterval int64,
	sender string,
	ExtraInfo string) MsgCreateRecipe {
	return MsgCreateRecipe{
		RecipeID:      recipeID,
		Name:          recipeName,
		CookbookID:    cookbookID,
		CoinInputs:    coinInputs,
		ItemInputs:    itemInputs,
		Outputs:       outputs,
		BlockInterval: blockInterval,
		Sender:        sender,
		Description:   description,
		Entries:       entries,
		ExtraInfo:     ExtraInfo,
	}
}

// Route should return the name of the module
func (msg MsgCreateRecipe) Route() string { return RouterKey }

// Type should return the action
func (msg MsgCreateRecipe) Type() string { return "create_recipe" }

// ValidateBasic validates the Msg
func (msg MsgCreateRecipe) ValidateBasic() error {

	itemInputRefsMap := map[string]bool{}
	entryIDsMap := map[string]bool{}
	for _, ii := range msg.ItemInputs {
		if ii.ID == "" {
			continue
		}
		if err := ii.IDValidationError(); err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "Entry ID Invalid")
		}
		if itemInputRefsMap[ii.ID] {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("item input with same ID available: ID=%s", ii.ID))
		}
		itemInputRefsMap[ii.ID] = true
	}

	// validation for the invalid item input reference on a coins outputs
	for _, entry := range msg.Entries.CoinOutputs {
		if err := EntryIDValidationError(entry.GetID()); err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "Entry ID Invalid")
		}
		if entryIDsMap[entry.GetID()] {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("entry with same ID available: ID=%s", entry.GetID()))
		}
		entryIDsMap[entry.GetID()] = true
		coinOutput := entry
		if err := ProgramValidateBasic(coinOutput.Count); err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "CoinOuput: "+err.Error())
		}
		if coinOutput.Coin == Pylon {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "There should not be a recipe which generate pylon denom as an output")
		}
		if err := sdk.ValidateDenom(coinOutput.Coin); err != nil {
			return err
		}
	}

	// validation for the invalid item input reference on a items with modified outputs
	for _, entry := range msg.Entries.ItemModifyOutputs {
		if err := EntryIDValidationError(entry.GetID()); err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "Entry ID Invalid")
		}
		if entryIDsMap[entry.GetID()] {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("entry with same ID available: ID=%s", entry.GetID()))
		}
		entryIDsMap[entry.GetID()] = true
		if !itemInputRefsMap[entry.ItemInputRef] {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "Invalid item input ref found that does not exist in item inputs")
		}
	}
	// do nothing for now for items outputs

	for _, output := range msg.Outputs {
		// validation for same ItemInputRef on output
		usedItemInputRefs := make(map[string]bool)
		usedEntries := make(map[string]bool)
		for _, entryID := range output.EntryIDs {
			entry, err := msg.Entries.FindByID(entryID)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			if usedEntries[entryID] {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "double use of entries within single output result")
			}
			usedEntries[entryID] = true
			switch entry := entry.(type) {
			case *ItemModifyOutput:
				if usedItemInputRefs[entry.ItemInputRef] {
					return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "double use of item input within single output result")
				}
				usedItemInputRefs[entry.ItemInputRef] = true
			}
		}
		// validation for weight program
		if err := ProgramValidateBasic(output.Weight); err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "Output Weight: "+err.Error())
		}
	}

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	if len(msg.Description) < 20 {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the description should have more than 20 characters")
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgCreateRecipe) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgCreateRecipe) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

// NewMsgUpdateRecipe a constructor for UpdateRecipe msg
func NewMsgUpdateRecipe(id, recipeName, cookbookID, description string,
	coinInputs CoinInputList,
	itemInputs ItemInputList,
	entries EntriesList,
	outputs WeightedOutputsList,
	blockInterval int64,
	sender string) MsgUpdateRecipe {
	return MsgUpdateRecipe{
		ID:            id,
		Name:          recipeName,
		CookbookID:    cookbookID,
		Description:   description,
		CoinInputs:    coinInputs,
		ItemInputs:    itemInputs,
		Entries:       entries,
		Outputs:       outputs,
		BlockInterval: blockInterval,
		Sender:        sender,
	}
}

// Route should return the name of the module
func (msg MsgUpdateRecipe) Route() string { return RouterKey }

// Type should return the action
func (msg MsgUpdateRecipe) Type() string { return "update_recipe" }

// ValidateBasic validates the Msg
func (msg MsgUpdateRecipe) ValidateBasic() error {
	if len(msg.ID) == 0 {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "recipe id is required for this message type")
	}

	msgCreateRecipe := NewMsgCreateRecipe(
		msg.Name,
		msg.CookbookID,
		msg.ID,
		msg.Description,
		msg.CoinInputs,
		msg.ItemInputs,
		msg.Entries,
		msg.Outputs,
		msg.BlockInterval,
		msg.Sender,
		msg.ExtraInfo,
	)

	return msgCreateRecipe.ValidateBasic()
}

// GetSignBytes encodes the message for signing
func (msg MsgUpdateRecipe) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgUpdateRecipe) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

// NewMsgExecuteRecipe a constructor for ExecuteCookbook msg
func NewMsgExecuteRecipe(recipeID string, sender string, paymentId string, payMethod string, itemIDs []string) MsgExecuteRecipe {
	msg := MsgExecuteRecipe{
		RecipeID:      recipeID,
		Sender:        sender,
		PaymentId:     paymentId,
		PaymentMethod: payMethod,
		ItemIDs:       itemIDs,
	}
	return msg
}

func NewMsgStripeCheckout(stripeKey string, paymentMethod string, price *StripePrice, sender string) MsgStripeCheckout {
	msg := MsgStripeCheckout{
		StripeKey:     stripeKey,
		PaymentMethod: paymentMethod,
		Price:         price,
		Sender:        sender,
	}
	return msg
}

func NewMsgStripeCreateProduct(StripeKey string, Name string, Description string, Images []string, StatementDescriptor string, UnitLabel string, Sender string) MsgStripeCreateProduct {
	msg := MsgStripeCreateProduct{
		StripeKey:           StripeKey,
		Name:                Name,
		Description:         Description,
		Images:              Images,
		StatementDescriptor: StatementDescriptor,
		UnitLabel:           UnitLabel,
		Sender:              Sender,
	}
	return msg
}

func NewMsgStripeCreatePaymentIntent(StripeKey string, Amount int64, Currency string, SKUID string, Sender string, CustomerId string) MsgStripeCreatePaymentIntent {
	msg := MsgStripeCreatePaymentIntent{
		StripeKey:  StripeKey,
		Amount:     Amount,
		Currency:   Currency,
		SKUID:      SKUID,
		Sender:     Sender,
		CustomerId: CustomerId,
	}
	return msg
}

func NewMsgStripePaymentHistoryLIst(StripeKey string, CustomerId string, Sender string) MsgStripePaymentHistoryLIst {
	msg := MsgStripePaymentHistoryLIst{
		StripeKey:  StripeKey,
		CustomerId: CustomerId,
		Sender:     Sender,
	}
	return msg
}

func NewMsgStripeCheckPayment(StripeKey string, PaymentID string, Sender string) MsgStripeCheckPayment {
	msg := MsgStripeCheckPayment{
		StripeKey: StripeKey,
		PaymentID: PaymentID,
		Sender:    Sender,
	}
	return msg
}

func NewMsgStripeCreateCustomerId(StripeKey string, Sender string) MsgStripeCreateCustomerId {
	msg := MsgStripeCreateCustomerId{
		StripeKey: StripeKey,
		Sender:    Sender,
	}
	return msg
}

func NewMsgStripeCreateAccount(StripeKey string, Country string, Email string, Types string, Sender string) MsgStripeCreateAccount {
	msg := MsgStripeCreateAccount{
		StripeKey: StripeKey,
		Country:   Country,
		Email:     Email,
		Types:     Types,
		Sender:    Sender,
	}
	return msg
}

func NewMsgStripeOauthToken(GrantType string, Code string, Sender string) MsgStripeOauthToken {
	msg := MsgStripeOauthToken{
		GrantType: GrantType,
		Code:      Code,
		Sender:    Sender,
	}
	return msg
}

func NewMsgStripeCreatePrice(StripeKey string, Product string, Amount string, Currency string, Description string, Sender string) MsgStripeCreatePrice {
	msg := MsgStripeCreatePrice{
		StripeKey:   StripeKey,
		Product:     Product,
		Amount:      Amount,
		Currency:    Currency,
		Description: Description,
		Sender:      Sender,
	}
	return msg
}

func NewMsgStripeCreateSku(StripeKey string, Product string, Attributes StringKeyValueList, Price int64, Currency string, Inventory *StripeInventory, Sender string) MsgStripeCreateSku {
	msg := MsgStripeCreateSku{
		StripeKey:  StripeKey,
		Product:    Product,
		Attributes: Attributes,
		Price:      Price,
		Currency:   Currency,
		Inventory:  Inventory,
		Sender:     Sender,
	}
	return msg
}

func NewMsgStripeCreateProductSku(StripeKey string, Name string, Description string, Images []string,
	Attributes StringKeyValueList, Price int64, Currency string,
	Inventory *StripeInventory, ClientId string, Sender string) MsgStripeCreateProductSku {
	msg := MsgStripeCreateProductSku{
		StripeKey:   StripeKey,
		Name:        Name,
		Description: Description,
		Images:      Images,
		Attributes:  Attributes,
		Price:       Price,
		Currency:    Currency,
		Inventory:   Inventory,
		ClientId:    ClientId,
		Sender:      Sender,
	}
	return msg
}

// Route should return the name of the module
func (msg MsgExecuteRecipe) Route() string { return RouterKey }

// Type should return the action
func (msg MsgExecuteRecipe) Type() string { return "execute_recipe" }

// ValidateBasic validates the Msg
func (msg MsgExecuteRecipe) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgExecuteRecipe) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

func (msg MsgStripeCreateProduct) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

func (msg MsgStripeCreateProduct) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

func (msg MsgStripeCreateProduct) Route() string { return RouterKey }

func (msg MsgStripeCreateProduct) Type() string { return "stripe_create_product" }

func (msg MsgStripeCreateProduct) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	return nil
}

func (msg MsgStripeCreateProductSku) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

func (msg MsgStripeCreateProductSku) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

func (msg MsgStripeCreateProductSku) Route() string { return RouterKey }

func (msg MsgStripeCreateProductSku) Type() string { return "stripe_create_product_sku" }

func (msg MsgStripeCreateProductSku) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	return nil
}

func (msg MsgStripeInfo) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

func (msg MsgStripeCreatePrice) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

func (msg MsgStripeCreatePrice) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

func (msg MsgStripeCreatePrice) Route() string { return RouterKey }

func (msg MsgStripeCreatePrice) Type() string { return "stripe_create_price" }

func (msg MsgStripeCreatePrice) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	return nil
}

func (msg MsgStripeCreateAccount) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

func (msg MsgStripeCreateAccount) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

func (msg MsgStripeCreateAccount) Route() string { return RouterKey }

func (msg MsgStripeCreateAccount) Type() string { return "stripe_create_account" }

func (msg MsgStripeCreateAccount) ValidateBasic() error {

	// if msg.Sender == "" {
	// 	return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	// }

	return nil
}

func (msg MsgStripeOauthToken) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

func (msg MsgStripeOauthToken) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

func (msg MsgStripeOauthToken) Route() string { return RouterKey }

func (msg MsgStripeOauthToken) Type() string { return "stripe_create_account" }

func (msg MsgStripeOauthToken) ValidateBasic() error {

	// if msg.Sender == "" {
	// 	return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	// }

	return nil
}

func (msg MsgStripeInfo) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

func (msg MsgStripeInfo) Route() string { return RouterKey }

func (msg MsgStripeInfo) Type() string { return "stripe_info" }

func (msg MsgStripeInfo) ValidateBasic() error {

	// if msg.Sender == "" {
	// 	return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	// }

	return nil
}

func (msg MsgStripePaymentHistoryLIst) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

func (msg MsgStripePaymentHistoryLIst) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

func (msg MsgStripePaymentHistoryLIst) Route() string { return RouterKey }

func (msg MsgStripePaymentHistoryLIst) Type() string { return "stripe_payment_history_list" }

func (msg MsgStripePaymentHistoryLIst) ValidateBasic() error {

	// if msg.Sender == "" {
	// 	return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	// }

	return nil
}

func (msg MsgStripeCheckPayment) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

func (msg MsgStripeCheckPayment) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

func (msg MsgStripeCheckPayment) Route() string { return RouterKey }

func (msg MsgStripeCheckPayment) Type() string { return "stripe_check_payment" }

func (msg MsgStripeCheckPayment) ValidateBasic() error {

	// if msg.Sender == "" {
	// 	return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	// }

	return nil
}

func (msg MsgStripeCreateCustomerId) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

func (msg MsgStripeCreateCustomerId) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

func (msg MsgStripeCreateCustomerId) Route() string { return RouterKey }

func (msg MsgStripeCreateCustomerId) Type() string { return "stripe_create_customer_id" }

func (msg MsgStripeCreateCustomerId) ValidateBasic() error {

	// if msg.Sender == "" {
	// 	return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	// }

	return nil
}

func (msg MsgStripeCreatePaymentIntent) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

func (msg MsgStripeCreatePaymentIntent) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

func (msg MsgStripeCreatePaymentIntent) Route() string { return RouterKey }

func (msg MsgStripeCreatePaymentIntent) Type() string { return "stripe_create_payment_intent" }

func (msg MsgStripeCreatePaymentIntent) ValidateBasic() error {

	// if msg.Sender == "" {
	// 	return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	// }

	return nil
}

func (msg MsgStripeCreateSku) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

func (msg MsgStripeCreateSku) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

func (msg MsgStripeCreateSku) Route() string { return RouterKey }

func (msg MsgStripeCreateSku) Type() string { return "stripe_create_sku" }

func (msg MsgStripeCreateSku) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	return nil
}

func (msg MsgStripeCheckout) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

func (msg MsgStripeCheckout) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

func (msg MsgStripeCheckout) Route() string { return RouterKey }

func (msg MsgStripeCheckout) Type() string { return "stripe_checkout" }

func (msg MsgStripeCheckout) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	return nil
}

// GetSigners gets the signer who should have signed the message
func (msg MsgExecuteRecipe) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

// NewMsgCheckExecution a constructor for CheckExecution msg
func NewMsgCheckExecution(execID string, ptc bool, sender string) MsgCheckExecution {
	return MsgCheckExecution{
		ExecID:        execID,
		Sender:        sender,
		PayToComplete: ptc,
	}
}

// Route should return the name of the module
func (msg MsgCheckExecution) Route() string { return RouterKey }

// Type should return the action
func (msg MsgCheckExecution) Type() string { return "check_execution" }

// ValidateBasic validates the Msg
func (msg MsgCheckExecution) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgCheckExecution) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgCheckExecution) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

// NewMsgDisableRecipe a constructor for DisableRecipe msg
func NewMsgDisableRecipe(recipeID string, sender string) MsgDisableRecipe {
	return MsgDisableRecipe{
		RecipeID: recipeID,
		Sender:   sender,
	}
}

// Route should return the name of the module
func (msg MsgDisableRecipe) Route() string { return RouterKey }

// Type should return the action
func (msg MsgDisableRecipe) Type() string { return "disable_recipe" }

// ValidateBasic validates the Msg
func (msg MsgDisableRecipe) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)

	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgDisableRecipe) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgDisableRecipe) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

// NewMsgEnableRecipe a constructor for EnableRecipe msg
func NewMsgEnableRecipe(recipeID string, sender string) MsgEnableRecipe {
	return MsgEnableRecipe{
		RecipeID: recipeID,
		Sender:   sender,
	}
}

// Route should return the name of the module
func (msg MsgEnableRecipe) Route() string { return RouterKey }

// Type should return the action
func (msg MsgEnableRecipe) Type() string { return "enable_recipe" }

// ValidateBasic validates the Msg
func (msg MsgEnableRecipe) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgEnableRecipe) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgEnableRecipe) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

// NewMsgGetPylons is a function to get MsgGetPylons msg from required params
func NewMsgGetPylons(amount sdk.Coins, requester string) MsgGetPylons {
	return MsgGetPylons{
		Amount:    amount,
		Requester: requester,
	}
}

// Route should return the name of the module
func (msg MsgGetPylons) Route() string { return RouterKey }

// Type should return the action
func (msg MsgGetPylons) Type() string { return "get_pylons" }

// ValidateBasic is a function to validate MsgGetPylons msg
func (msg MsgGetPylons) ValidateBasic() error {

	if msg.Requester == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Requester)
	}
	if !msg.Amount.IsAllPositive() {
		return sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "Amount cannot be less than 0/negative")
	}
	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgGetPylons) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners is a function to get signers from MsgGetPylons msg
func (msg MsgGetPylons) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Requester)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

// NewMsgGoogleIAPGetPylons is a function to get MsgGetPylons msg from required params
func NewMsgGoogleIAPGetPylons(ProductID, PurchaseToken, ReceiptDataBase64, Signature string, requester string) MsgGoogleIAPGetPylons {
	return MsgGoogleIAPGetPylons{
		ProductID:         ProductID,
		PurchaseToken:     PurchaseToken,
		ReceiptDataBase64: ReceiptDataBase64,
		Signature:         Signature,
		Requester:         requester,
	}
}

// Route should return the name of the module
func (msg MsgGoogleIAPGetPylons) Route() string { return RouterKey }

// Type should return the action
func (msg MsgGoogleIAPGetPylons) Type() string { return "google_iap_get_pylons" }

// ValidateGoogleIAPSignature is function for testing signature on local
func (msg MsgGoogleIAPGetPylons) ValidateGoogleIAPSignature() error {
	// References
	// offline verification JS module https://github.com/voltrue2/in-app-purchase/blob/e966ee1348bd4f67581779abeec59c4bbc2b2ebc/lib/google.js#L788
	// Cordova Plugin code that check offline https://github.com/j3k0/cordova-plugin-purchase/blob/8861bd2392a48d643ffc754b8f59afc1e6afab60/src/android/cc/fovea/Security.java#L94
	// https://stackoverflow.com/questions/31349710/google-play-billing-response-signature-verification

	// We should contact google team to check if this is correct use

	playStorePubKeyBytes, err := base64.StdEncoding.DecodeString(config.Config.GoogleIAPPubKey)
	if err != nil {
		return fmt.Errorf("play store base64 public key decoding failure: %s", err.Error())
	}
	re, err := x509.ParsePKIXPublicKey(playStorePubKeyBytes)
	if err != nil {
		return err
	}
	pub := re.(*rsa.PublicKey)
	receiptData, err := base64.StdEncoding.DecodeString(msg.ReceiptDataBase64)
	if err != nil {
		return err
	}

	h := sha1.New()
	_, err = h.Write(receiptData)
	if err != nil {
		return err
	}
	digest := h.Sum(nil)

	ds, err := base64.StdEncoding.DecodeString(msg.Signature)
	if err != nil {
		return fmt.Errorf("msg signature base64 decoding failure: %s", err.Error())
	}
	err = rsa.VerifyPKCS1v15(pub, crypto.SHA1, digest, ds)
	return err
}

// ValidateBasic is a function to validate MsgGoogleIAPGetPylons msg
func (msg MsgGoogleIAPGetPylons) ValidateBasic() error {

	if msg.Requester == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Requester)
	}

	var jsonData map[string]interface{}

	receiptData, err := base64.StdEncoding.DecodeString(msg.ReceiptDataBase64)
	if err != nil {
		return err
	}

	err = json.Unmarshal(receiptData, &jsonData)
	if err != nil {
		return err
	}
	if msg.PurchaseToken != jsonData["purchaseToken"] {
		return fmt.Errorf("purchaseToken does not match with receipt data")
	}
	if msg.ProductID != jsonData["productId"] {
		return fmt.Errorf("productId does not match with receipt data")
	}
	return msg.ValidateGoogleIAPSignature()
}

// GetSignBytes encodes the message for signing
func (msg MsgGoogleIAPGetPylons) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners encodes the message for signing
func (msg MsgGoogleIAPGetPylons) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Requester)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

// NewMsgFiatItem a constructor for MsgFiatItem msg
func NewMsgFiatItem(cookbookID string, doubles DoubleKeyValueList, longs LongKeyValueList, strings StringKeyValueList, sender string, transferFee int64) MsgFiatItem {
	return MsgFiatItem{
		CookbookID:  cookbookID,
		Doubles:     doubles,
		Longs:       longs,
		Strings:     strings,
		Sender:      sender,
		TransferFee: transferFee,
	}
}

// Route should return the name of the module
func (msg MsgFiatItem) Route() string { return RouterKey }

// Type should return the action
func (msg MsgFiatItem) Type() string { return "fiat_item" }

// ValidateBasic validates the Msg
func (msg MsgFiatItem) ValidateBasic() error {
	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgFiatItem) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgFiatItem) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

// NewMsgCreateTrade a constructor for CreateTrade msg
func NewMsgCreateTrade(
	coinInputs CoinInputList,
	tradeItemInputs TradeItemInputList,
	coinOutputs sdk.Coins,
	itemOutputs ItemList,
	extraInfo string,
	sender string) MsgCreateTrade {
	return MsgCreateTrade{
		CoinInputs:  coinInputs,
		ItemInputs:  tradeItemInputs,
		CoinOutputs: coinOutputs,
		ItemOutputs: itemOutputs,
		ExtraInfo:   extraInfo,
		Sender:      sender,
	}
}

// Route should return the name of the module
func (msg MsgCreateTrade) Route() string { return RouterKey }

// Type should return the action
func (msg MsgCreateTrade) Type() string { return "create_trade" }

// ValidateBasic validates the Msg
func (msg MsgCreateTrade) ValidateBasic() error {
	tradePylonAmount := int64(0)

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)

	}
	if msg.CoinOutputs == nil && msg.ItemOutputs == nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "sender not providing anything in exchange of the trade: empty outputs")
	}

	var isStripePayment = false
	for _, inp := range msg.CoinInputs {
		if inp.Coin == config.Config.StripeConfig.Currency {
			isStripePayment = true
		}
	}

	if isStripePayment == false {
		if msg.CoinOutputs != nil {
			for _, coinOutput := range msg.CoinOutputs {
				if !coinOutput.IsPositive() {
					return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "there should be no 0 amount denom on outputs")
				}
			}
			tradePylonAmount += msg.CoinOutputs.AmountOf(Pylon).Int64()
		}

		if msg.ItemInputs == nil && msg.CoinInputs == nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "sender not receiving anything for the trade: empty inputs")
		}

		if msg.CoinInputs != nil {
			for _, coinInput := range msg.CoinInputs {
				if coinInput.Count == 0 {
					return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "there should be no 0 amount denom on coin inputs")
				}
			}
			tradePylonAmount += CoinInputList(msg.CoinInputs).ToCoins().AmountOf(Pylon).Int64()
		}

		if tradePylonAmount < config.Config.Fee.MinTradePrice {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("there should be more than %d amount of pylon per trade", config.Config.Fee.MinTradePrice))
		}

		if msg.ItemInputs != nil {
			err := TradeItemInputList(msg.ItemInputs).Validate()
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
		}
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgCreateTrade) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgCreateTrade) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

// NewMsgFulfillTrade a constructor for FulfillTrade msg
func NewMsgFulfillTrade(TradeID string, sender string, itemIDs []string, paymentId string, paymentMethod string) MsgFulfillTrade {
	return MsgFulfillTrade{
		TradeID:       TradeID,
		Sender:        sender,
		ItemIDs:       itemIDs,
		PaymentId:     paymentId,
		PaymentMethod: paymentMethod,
	}
}

// Route should return the name of the module
func (msg MsgFulfillTrade) Route() string { return RouterKey }

// Type should return the action
func (msg MsgFulfillTrade) Type() string { return "fulfill_trade" }

// ValidateBasic validates the Msg
func (msg MsgFulfillTrade) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgFulfillTrade) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgFulfillTrade) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

// NewMsgDisableTrade a constructor for DisableTrade msg
func NewMsgDisableTrade(tradeID string, sender string) MsgDisableTrade {
	return MsgDisableTrade{
		TradeID: tradeID,
		Sender:  sender,
	}
}

// Route should return the name of the module
func (msg MsgDisableTrade) Route() string { return RouterKey }

// Type should return the action
func (msg MsgDisableTrade) Type() string { return "disable_trade" }

// ValidateBasic validates the Msg
func (msg MsgDisableTrade) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgDisableTrade) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgDisableTrade) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

// NewMsgEnableTrade a constructor for EnableTrade msg
func NewMsgEnableTrade(tradeID string, sender string) MsgEnableTrade {
	return MsgEnableTrade{
		TradeID: tradeID,
		Sender:  sender,
	}
}

// Route should return the name of the module
func (msg MsgEnableTrade) Route() string { return RouterKey }

// Type should return the action
func (msg MsgEnableTrade) Type() string { return "enable_trade" }

// ValidateBasic validates the Msg
func (msg MsgEnableTrade) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgEnableTrade) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgEnableTrade) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

// NewMsgSendCoins is a function to get MsgSendCoins msg from required params
func NewMsgSendCoins(amount sdk.Coins, sender, receiver string) MsgSendCoins {
	return MsgSendCoins{
		Amount:   amount,
		Sender:   sender,
		Receiver: receiver,
	}
}

// Route should return the name of the module
func (msg MsgSendCoins) Route() string { return RouterKey }

// Type should return the action
func (msg MsgSendCoins) Type() string { return "send_coins" }

// ValidateBasic is a function to validate MsgSendCoins msg
func (msg MsgSendCoins) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	if msg.Receiver == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Receiver)
	}

	if !msg.Amount.IsAllPositive() {
		return sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "Amount cannot be less than 0/negative")
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgSendCoins) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners is a function to get signers from MsgSendCoins msg
func (msg MsgSendCoins) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

// NewMsgSendItems is a function to get MsgSendItems msg from required params
func NewMsgSendItems(itemIDs []string, sender, receiver string) MsgSendItems {
	return MsgSendItems{
		ItemIDs:  itemIDs,
		Sender:   sender,
		Receiver: receiver,
	}
}

// Route should return the name of the module
func (msg MsgSendItems) Route() string { return RouterKey }

// Type should return the action
func (msg MsgSendItems) Type() string { return "send_items" }

// ValidateBasic is a function to validate MsgSendItems msg
func (msg MsgSendItems) ValidateBasic() error {
	checked := make(map[string]bool)

	for _, val := range msg.ItemIDs {
		if val == "" {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "ItemID is invalid")
		}

		if checked[val] {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "Duplicated items in items trasfer")
		}

		checked[val] = true
	}

	if msg.Sender == msg.Receiver {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "Sender and receiver should be different")
	}

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	if msg.Receiver == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Receiver)
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgSendItems) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners is a function to get signers from MsgSendItems msg
func (msg MsgSendItems) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

// NewMsgUpdateItemString is a function to get MsgUpdateItemString msg from required params
func NewMsgUpdateItemString(ItemID, Field, Value string, Sender string) MsgUpdateItemString {
	return MsgUpdateItemString{
		ItemID: ItemID,
		Field:  Field,
		Value:  Value,
		Sender: Sender,
	}
}

// Route should return the name of the module
func (msg MsgUpdateItemString) Route() string { return RouterKey }

// Type should return the action
func (msg MsgUpdateItemString) Type() string { return "update_item_string" }

// ValidateBasic is a function to validate MsgUpdateItemString msg
func (msg MsgUpdateItemString) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	if len(msg.ItemID) == 0 {
		return sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "item id length should be more than 0")
	}

	if len(msg.Field) == 0 {
		return sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "field length should be more than 0")
	}

	if len(msg.Value) == 0 {
		return sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "value length should be more than 0")
	}
	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgUpdateItemString) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners is a function to get signers from MsgUpdateItemString msg
func (msg MsgUpdateItemString) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}
