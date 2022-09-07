## Breaking changes after 2.0.3

### The following classes & properties have been refactored (`OldClassName` -> `NewClassName`)
#### `Alan` related classes
* `AlanWalletDerivationInfo` -> `AlanAccountDerivationInfo`
  * `walletAlias` property refactored to `accountAlias`
* `AlanWalletDerivator` -> `AlanAccountDerivator`
* `AlanPrivateWalletCredentials` -> `AlanPrivateAccountCredentials`

#### Models
* `WalletDerivationFailure` -> `AccountDerivationFailure`
* `WalletLookupKey` -> `AccountLookupKey`
  * `walletId` property refactored to `accountId`
* `WalletPublicInfo` -> `AccountPublicInfo`
  * `walletId` property refactored to `accountId`
* `WalletPublicInfoSerializer` -> `AccountPublicInfoSerializer`
  
#### Abstractions
* `WalletDerivator` -> `AccountDerivator`
* `WalletDerivationInfo` -> `AccountDerivationInfo`
* `PrivateWalletCredentials` -> `PrivateAccountCredentials`
* `PrivateWalletCredentialsSerializer` -> `PrivateAccountCredentialsSerializer`

## 2.0.3 - 2021-01-27

### Fixed
* Paste button not enabling the continue button on asset transfer page
* Fees token denom is always AKT
* Ruby setup for deployment scripts in Github Actions

## 2.0.2 - 2022-01-25

### Added
* Security screen to enable app lock and biometrics
### Fixed
* Bug fixes and minor improvements

## [2.0.1](https://github.com/tendermint/flutter/compare/v2.0.0...v2.0.1) - 2021-12-17

### Fixed
* Library references in Ignite template

## 2.0.0 - 2021-12-17

### Changed
* Major design revamp for Ignite template

## 1.0.2 - 2021-09-20

### Fixed
* Fix go proxy cache

## 1.0.1 - 2021-08-21

### Added
* Support for dark theme
### Changed
* Minimum Android SDK version to 18

### Fixed
* Minor bug fixes

## 1.0.0 - 2021-08-17

* Initial version of Ignite template

## 0.1.0 - 2021-08-03

* Export ignite template as a Go module
* TODO: Add more from the first release
