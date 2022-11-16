# transaction_signing_gateway

The transaction signing gateway library encapsulates the logic for securely storing wallet credentials and allows for specifying a sandbox environment for transaction signing. This library was created with extendability in mind. If you want to support your own proprietary chain implementations, you can pass in your own implementation of signing transactions as well as serializing and deserializing wallet credentials.

## Getting Started

An access point is the `TransactionSigningGateway` class that you must first initialize with the implementations of various dependent classes. For example:
```dart
final signingGateway = TransactionSigningGateway(
      transactionSummaryUI: MobileTransactionSummaryUI(),
      infoStorage: MobileKeyInfoStorage(serializers: [
          SaccoCredentialsSerializer(),
      ]),
      signers: [
        SaccoTransactionSigner(),
      ],
    );
```