<!--
order: 5
-->

# Parameters

The pylons module contains the following parameters:

| Key                                   | Type          | Example                           |
| ------------------------------------- | ------------- | --------------------------------- |
| CoinIssuers                           | []CoinIssuer  |(see below)                        | 
| RecipeFeePercentage                   | math.Int       | 10.0                             |
| ItemTransferFeePercentage             | math.Int       | 20.0                             |
| UpdateItemStringFee                   | sdk.Coin      | {"denom": "upylon", "amount", 10} |
| UpdateUsernameFee                     | sdk.Coin      | {"denom": "upylon", "amount", 10} |
| MinTransferFee                        | math.Int       | 20                               |
| MaxTransferFee                        | math.Int       | 20                               |
| PaymentProcessors                     | []PaymentProcessor| (see below)                   |
| DistrEpochIdentifier                  | string         | "day"                            |
| EngineVersion                         | uint64         | 1                                |

## CoinIssuers

Structure to represent a trusted Entity with coin issuing credentials on the pylons chain.  For example,
Pylons Inc is a trusted coin issuer for issuing the "upylons" denom token.  The structure also contains
fields for `Packages` which represent the Issuer's Google IAP credentials for on-chain Google IAP functionality.

Example:

```go
	DefaultCoinIssuers = []CoinIssuer{
		{
			CoinDenom: "upylon",
			Packages: []GoogleInAppPurchasePackage{
				{PackageName: "com.pylons.loud", ProductID: "pylons_1000", Amount: sdk.NewInt(1000)},
				{PackageName: "com.pylons.loud", ProductID: "pylons_55000", Amount: sdk.NewInt(55000)},
			},
			GoogleInAppPurchasePubKey: "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwZsjhk6eN5Pve9pP3uqz2MwBFixvmCRtQJoDQLTEJo3zTd9VMZcXoerQX8cnDPclZWmMZWkO+BWcN1ikYdGHvU2gC7yBLi+TEkhsEkixMlbqOGRdmNptJJhqxuVmXK+drWTb6W0IgQ9g8CuCjZUiMTc0UjHb5mPOE/IhcuTZ0wCHdoqc5FS2spdQqrohvSEP7gR4ZgGzYNI1U+YZHskIEm2qC4ZtSaX9J/fDkAmmJFV2hzeDMcljCxY9+ZM1mdzIpZKwM7O6UdWRpwD1QJ7yXND8AQ9M46p16F0VQuZbbMKCs90NIcKkx6jDDGbVmJrFnUT1Oq1uYxNYtiZjTp+JowIDAQAB",
			EntityName:                "Pylons_Inc",
		},
		{
			CoinDenom:  "uatom",
			EntityName: "Cosmos_Hub",
		},
		{
			CoinDenom:  "ubedrock",
			EntityName: "Pylons_Chain",
		},
	}
```

## RecipeFeePercentage

Percentage of `Recipe` coinInputs that is taken as a fee for execution.  

```
CookbookOwnerAmount = (1 -  RecipeFeePercentage) * coinInputs
```

```
FeeAmount           =  RecipeFeePercentage * coinInputs
```

## ItemTransferFeePercentage

Percentage of coinInputs or transferFees for `Item` objects that is taken as a fee for trades or item-sending, respectively.

```
CookbookOwnerAmount = (1 -  ItemTransferFeePercentage) * coinInputs 
```

```
FeeAmount           =  ItemTransferFeePercentage * coinInputs
```

## UpdateItemStringFee

Fee for updating a string in the `MutableStrings` field of an `Item` using the `SetItemString` Tx.

## UpdateUsernameFee

Fee for updating the username of an account.

## MinTransferFee

Minimum transfer fee for sending `Item`s.

## MaxTransferFee

Minimum transfer fee for sending `Item`s.

## PaymentProcessors

Structure to represent a payment processor (such as Stripe) on-chain.  

Example:

```go
	DefaultProcessorPercentage  = sdk.ZeroDec()
    DefaultValidatorsPercentage = sdk.MustNewDecFromStr("0.003")
    DefaultPylonsIncPubKey      = "EVK1dqjD6K8hGylacMpWAa/ru/OnWUDtCZ+lPkv2TTA=" // this is a testing key, do not use in production!
    DefaultPaymentProcessors    = []PaymentProcessor{
        {
            CoinDenom:            StripeCoinDenom,
            PubKey:               DefaultPylonsIncPubKey,
            ProcessorPercentage:  DefaultProcessorPercentage,
            ValidatorsPercentage: DefaultValidatorsPercentage,
            Name:                 "Pylons_Inc",
        },
    }
    DefaultPaymentProcessorsTokensBankParams = []types.SendEnabled{
        {Denom: StripeCoinDenom, Enabled: false},
    }
```

## DistrEpochIdentifier

String identifier to choose an epoch length from the `x/epochs` module.

## EngineVersion

Application version.  Planned for use in the future to deprecate recipes.




