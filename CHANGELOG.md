# Changelog

## Unreleased

### Features:
- [#430](https://github.com/Pylons-tech/pylons/pull/430) Add `x/evidence` and `x/slashing` modules for IBC functionality.
- [#423](https://github.com/Pylons-tech/pylons/pull/423) Create custom testing setup for LOUD tests.  This update adds extendability for future tests.
- [#421](https://github.com/Pylons-tech/pylons/pull/421) Add game simulation testing to cli test suite.  Tests cover CEL environment execution, item modification and cookbook coin generation. 

### Fixes:
- [#434](https://github.com/Pylons-tech/pylons/pull/434) Add missing `RegisterStoreDecoder()` functionality in `x/pylons/module.go` to enable module simulation tests.
- [#429](https://github.com/Pylons-tech/pylons/pull/429) Dependabot security upgrade
- [#421](https://github.com/Pylons-tech/pylons/pull/421) Recipe execution validation and item matching logic fixed.

### Changes:
- [#434](https://github.com/Pylons-tech/pylons/pull/434) Bump SDK version to v0.44.1.
- [#428](https://github.com/Pylons-tech/pylons/pull/428) Follow migration [guide](https://github.com/tendermint/starport/blob/v0.18.0/docs/migration/index.md) for updating a starport-scaffolded chain to starport v0.18 compliance 
- [#425](https://github.com/Pylons-tech/pylons/pull/425) Upgrade Tendermint Core to v0.34.13 (was v0.34.12) and IBC-go to v1.2.0 (was v1.1.0).
