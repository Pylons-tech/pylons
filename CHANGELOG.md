# Changelog

## Unreleased

### Features:
- [#473](https://github.com/Pylons-tech/pylons/pull/473) Add `paymentProcessors` support for `Trade`s and `Recipe`s.
- [#448](https://github.com/Pylons-tech/pylons/pull/448) Add query `list-trades` for listing `Trade`s by creator address.
- [#430](https://github.com/Pylons-tech/pylons/pull/430) Add `x/evidence` and `x/slashing` modules for IBC functionality.
- [#423](https://github.com/Pylons-tech/pylons/pull/423) Create custom testing setup for LOUD tests.  This update adds extendability for future tests.
- [#421](https://github.com/Pylons-tech/pylons/pull/421) Add game simulation testing to cli test suite.  Tests cover CEL environment execution, item modification and cookbook coin generation. 

### Client Breaking Changes:

### Fixes:
- [#467](https://github.com/Pylons-tech/pylons/pull/467) Fix a bug where Item IDs were being being validated incorrectly in `ValidateBasic()` calls.
- [#346](https://github.com/Pylons-tech/pylons/pull/436) Fix a bug in `x/pylons/keeper/msg_server_fulfill_trade.go` where a transfer fees were being matched from itemInputs where they should have been from itemOutputs.
- [#346](https://github.com/Pylons-tech/pylons/pull/436) Fix a bug in `x/pylons/keeper/msg_server_fulfill_trade.go` where a `MatchItemInputsForTrade()` would return an error incorrectly.
- [#434](https://github.com/Pylons-tech/pylons/pull/434) Add missing `RegisterStoreDecoder()` functionality in `x/pylons/module.go` to enable module simulation tests.
- [#429](https://github.com/Pylons-tech/pylons/pull/429) Dependabot security upgrade
- [#421](https://github.com/Pylons-tech/pylons/pull/421) Recipe execution validation and item matching logic fixed.

### Changes:
- [#467](https://github.com/Pylons-tech/pylons/pull/467) Remove the `/flutter/` directory.  Code has been [moved](https://github.com/Pylons-tech/flutter_wallet).
- [#465](https://github.com/Pylons-tech/pylons/pull/465) Remove the `/vue/` directory.  Code has been [moved](https://github.com/Pylons-tech/pylons-web).
- [#463](https://github.com/Pylons-tech/pylons/pull/463) Bump SDK version to v0.44.2 and IBC-Go to v1.2.2.
- [#447](https://github.com/Pylons-tech/pylons/pull/447) Move automated coin denom registration to `app/app.go`.
- [#428](https://github.com/Pylons-tech/pylons/pull/428) Follow migration [guide](https://github.com/tendermint/starport/blob/v0.18.0/docs/migration/index.md) for updating a starport-scaffolded chain to starport v0.18 compliance 
- [#425](https://github.com/Pylons-tech/pylons/pull/425) Upgrade Tendermint Core to v0.34.13 (was v0.34.12).
