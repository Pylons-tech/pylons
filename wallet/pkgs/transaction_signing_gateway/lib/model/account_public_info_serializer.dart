import 'package:transaction_signing_gateway/model/account_public_info.dart';

//ignore: avoid_classes_with_only_static_members
class AccountPublicInfoSerializer {
  static const _nameKey = 'name';
  static const _chainIdKey = 'chain_id';
  static const _publicAddressKey = 'public_address';
  static const _accountIdKey = 'account_Id';
  static const _additionalDataKey = 'additional_data';
  static const _walletIdKey = 'wallet_Id';

  static AccountPublicInfo fromMap(Map<String, dynamic> map) {
    return AccountPublicInfo(
      name: map[_nameKey] as String? ?? '',
      publicAddress: map[_publicAddressKey] as String? ?? '',
      accountId: map[_accountIdKey] as String? ?? map[_walletIdKey] as String? ?? '',
      chainId: map[_chainIdKey] as String? ?? '',
      additionalData: map[_additionalDataKey] as String?,
    );
  }

  static Map<String, dynamic> toMap(AccountPublicInfo info) {
    return {
      _nameKey: info.name,
      _publicAddressKey: info.publicAddress,
      _accountIdKey: info.accountId,
      _chainIdKey: info.chainId,
      _additionalDataKey: info.additionalData,
    };
  }
}
