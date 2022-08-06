import 'dart:typed_data';

import 'package:alan/alan.dart';
import 'package:alan/proto/cosmos/crypto/secp256k1/export.dart' as secp256;
import 'package:protobuf/protobuf.dart';

/// Allows to create and sign a [Tx] object so that it can later
/// be sent to the chain.
class CustomTxSigner {
  String _chainId;
  CustomTxSigner(this._chainId);

  /// Builds a new [TxSigner] from a given gRPC client channel and HTTP client.
  factory CustomTxSigner.build(String _chainId) {
    return CustomTxSigner(_chainId);
  }

  /// Builds a new [TxSigner] from the given [NetworkInfo].
  factory CustomTxSigner.fromNetworkInfo(String _chainId) {
    return CustomTxSigner.build(_chainId);
  }

  /// Creates a new [Tx] object containing the given [msgs] and signs it using
  /// the provided [wallet].
  /// Optional [TxConfig], memo, gas and fees can be supplied as well.
  Future<Tx> createAndSign(
    Wallet wallet,
    List<GeneratedMessage> msgs, {
    TxConfig? config,
    String? memo,
    Fee? fee,
  }) async {
    // Set the config to the default value if not given
    config ??= DefaultTxConfig.create();
    final signMode = config.defaultSignMode();

    // Set the default fees
    fee ??= Fee()..gasLimit = 200000.toInt64();
    if (!fee.hasGasLimit()) {
      throw Exception('Invalid fees: invalid gas amount specified');
    }

    // Get the account data and node info from the network
    // final account = await _authQuerier.getAccountData(wallet.bech32Address);

    // const account = null;
    // if (account == null) {
    //   throw Exception(
    //     'Account ${wallet.bech32Address} does not exist on chain',
    //   );
    // }


    // Get the public key from the account, or generate it if the
    // chain does not have it yet

    final secp256Key = secp256.PubKey.create()..key = wallet.publicKey;
    final pubKey = Codec.serialize(secp256Key);

    // For SIGN_MODE_DIRECT, calling SetSignatures calls setSignerInfos on
    // TxBuilder under the hood, and SignerInfos is needed to generated the
    // sign bytes. This is the reason for setting SetSignatures here, with a
    // nil signature.
    //
    // Note: this line is not needed for SIGN_MODE_LEGACY_AMINO, but putting it
    // also doesn't affect its generated sign bytes, so for code's simplicity
    // sake, we put it here.
    var sigData = SingleSignatureData(signMode: signMode);

    // Set SignatureV2 with empty signatures, to set correct signer infos.
    var sig = SignatureV2(
      pubKey: pubKey,
      data: sigData,
      sequence: 0.toInt64(),
    );

    // Create the transaction builder
    final tx = config.newTxBuilder()
      ..setMsgs(msgs)
      ..setSignatures([sig])
      ..setMemo(memo)
      ..setFeeAmount(fee.amount)
      ..setGasLimit(fee.gasLimit);
    //
    // Generate the bytes to be signed.
    final handler = config.signModeHandler();
    final signerData = SignerData(
      chainId: _chainId,
      accountNumber: 0.toInt64(),
      sequence: 0.toInt64(),
    );
    final bytesToSign = handler.getSignBytes(signMode, signerData, tx.getTx());
    //
    // Sign those bytes
    final sigBytes = wallet.sign(Uint8List.fromList(bytesToSign));

    // Construct the SignatureV2 struct
    sigData = SingleSignatureData(signMode: signMode, signature: sigBytes);
    sig = SignatureV2(
      pubKey: pubKey,
      data: sigData,
      sequence: 0.toInt64(),
    );
    tx.setSignatures([sig]);

    // Return the signed transaction
    return tx.getTx();
  }
}
