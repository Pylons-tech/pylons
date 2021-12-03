# Changelog

## Unreleased 
 
### State Machine Breaking Changes:

- [#517](https://github.com/Pylons-tech/pylons/pull/517) Move the `CostPerBlock` field from Cookbook messages to Recipe messages.
- [#508](https://github.com/Pylons-tech/pylons/pull/508) Remove the `MinNameFieldLength` and `MinDescriptionFieldLength` params from the chain.

### Fixes:

- [#519](https://github.com/Pylons-tech/pylons/pull/519) Remove potentially panic-ing array access in `x/pylons/keeper/complete_pending_execution.go`.
- [#509](https://github.com/Pylons-tech/pylons/pull/509) Bump `github.com/opencontainers/image-spec` to v1.0.2 to avoid security issue.

### Changes:

- [#520](https://github.com/Pylons-tech/pylons/pull/520) Bump Cosmos SDK and IBC-Go to v0.44.4 and v2.0.0, respectively.
- [#515](https://github.com/Pylons-tech/pylons/pull/515) Remove the `ConditionList` proto message.
- [#494](https://github.com/Pylons-tech/pylons/pull/494) Replace usages of deprecated `EmitEvent()` with `EmitTypedEvent()`.

### Features:
- [#523](https://github.com/Pylons-tech/pylons/pull/523) Change the coin-inputs and cost per block arg format to support "1000000token" like coin inputs.  
- [#521](https://github.com/Pylons-tech/pylons/pull/521) Added bash completion support

## [v0.3.1](https://github.com/Pylons-tech/pylons/releases/tag/v0.3.1) - 2021-10-01

### Features:

- [#487](https://github.com/Pylons-tech/pylons/pull/487) Add `x/epochs` module and custom fee distribution logic.
- [#478](https://github.com/Pylons-tech/pylons/pull/478) Enhance validation checks for Recipe weights

### Fixes:

- [#492](https://github.com/Pylons-tech/pylons/pull/492) Update SDK version to v0.44.3 to fix security issues.
- [#490](https://github.com/Pylons-tech/pylons/pull/490) Invert default parameters for paymentProcessor percentage.
- [#482](https://github.com/Pylons-tech/pylons/pull/482) Prevent bug where nil pointers could cause panics in Recipe EntriesList fields.
- [#479](https://github.com/Pylons-tech/pylons/pull/479) Fixes an issue in the `ValidateBasic()` function for `MsgFulfillTrade` where itemIDs were being validated incorrectly.

## [v0.2.0](https://github.com/Pylons-tech/pylons/releases/tag/v0.2.0) - 2021-10-28

### Features:

- [#478](https://github.com/Pylons-tech/pylons/pull/478) Expand validation checks for CreateRecipe and UpdateRecipe messages.
- [#473](https://github.com/Pylons-tech/pylons/pull/473) Add `paymentProcessors` support for `Trade`s and `Recipe`s.
- [#448](https://github.com/Pylons-tech/pylons/pull/448) Add query `list-trades` for listing `Trade`s by creator address.
- [#430](https://github.com/Pylons-tech/pylons/pull/430) Add `x/evidence` and `x/slashing` modules for IBC functionality.
- [#423](https://github.com/Pylons-tech/pylons/pull/423) Create custom testing setup for LOUD tests. This update adds extendability for future tests.
- [#421](https://github.com/Pylons-tech/pylons/pull/421) Add game simulation testing to cli test suite. Tests cover CEL environment execution, item modification and cookbook coin generation.

### Fixes:

- [#489](https://github.com/Pylons-tech/pylons/pull/489) Fix potential consensus failure due to nodeVersion being pulled from binary
- [#467](https://github.com/Pylons-tech/pylons/pull/467) Fix a bug where Item IDs were being validated incorrectly in `ValidateBasic()` calls.
- [#346](https://github.com/Pylons-tech/pylons/pull/436) Fix a bug in `x/pylons/keeper/msg_server_fulfill_trade.go` where a transfer fees were being matched from itemInputs where they should have been from itemOutputs.
- [#346](https://github.com/Pylons-tech/pylons/pull/436) Fix a bug in `x/pylons/keeper/msg_server_fulfill_trade.go` where a `MatchItemInputsForTrade()` would return an error incorrectly.
- [#434](https://github.com/Pylons-tech/pylons/pull/434) Add missing `RegisterStoreDecoder()` functionality in `x/pylons/module.go` to enable module simulation tests.
- [#429](https://github.com/Pylons-tech/pylons/pull/429) Dependabot security upgrade
- [#421](https://github.com/Pylons-tech/pylons/pull/421) Recipe execution validation and item matching logic fixed.

### Client Breaking Changes

- [#485](https://github.com/Pylons-tech/pylons/pull/485) Add fee distribution and the `x/epochs` module.
- [#476](https://github.com/Pylons-tech/pylons/pull/476) Remove `rate` field from `*Param` proto messages.
- [#473](https://github.com/Pylons-tech/pylons/pull/473) Update proto definition of `MsgExecuteRecipe` and `MsgFulfillTrade` to add the `PaymentInfos` field.

### State Machine Breaking Changes

- [#489](https://github.com/Pylons-tech/pylons/pull/489) Changed `nodeVersion` field in `Recipe`, `Cookbook`, `Item`, `Execution`, to be a `uint64` on-chain param instead of being pulled from the binary

### Changes:

- [#467](https://github.com/Pylons-tech/pylons/pull/467) Remove the `/flutter/` directory. Code has been [moved](https://github.com/Pylons-tech/flutter_wallet).
- [#465](https://github.com/Pylons-tech/pylons/pull/465) Remove the `/vue/` directory. Code has been [moved](https://github.com/Pylons-tech/pylons-web).
- [#463](https://github.com/Pylons-tech/pylons/pull/463) Bump SDK version to v0.44.2 and IBC-Go to v1.2.2.
- [#447](https://github.com/Pylons-tech/pylons/pull/447) Move automated coin denom registration to `app/app.go`.
- [#428](https://github.com/Pylons-tech/pylons/pull/428) Follow migration [guide](https://github.com/tendermint/starport/blob/v0.18.0/docs/migration/index.md) for updating a starport-scaffolded chain to starport v0.18 compliance
- [#425](https://github.com/Pylons-tech/pylons/pull/425) Upgrade Tendermint Core to v0.34.13 (was v0.34.12).

## 2021-11-23

### Docs

- [#516](https://github.com/Pylons-tech/pylons/pull/516) Add Recipe Walkthrough intial documentation.
