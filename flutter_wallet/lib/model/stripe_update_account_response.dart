import 'package:pylons_wallet/utils/query_helper.dart';

class StripeUpdateAccountResponse {
  final String accountlink;
  final String account;
  final bool success;

  StripeUpdateAccountResponse(
      {this.accountlink = '', this.account = '', this.success = false});

  factory StripeUpdateAccountResponse.from(
      RequestResult<Map<String, dynamic>> ret) {
    if (ret.isSuccessful && ret.value != null) {
      return StripeUpdateAccountResponse(
          accountlink: ret.value?.entries
              .firstWhere((entry) => entry.key == 'accountlink',
                  orElse: () => const MapEntry('accountlink', ''))
              .value as String,
          account: ret.value?.entries
              .firstWhere((entry) => entry.key == 'account',
                  orElse: () => const MapEntry('account', ''))
              .value as String,
          success: true);
    }
    return StripeUpdateAccountResponse();
  }

  factory StripeUpdateAccountResponse.fromJson(Map<String, dynamic> ret) {
      return StripeUpdateAccountResponse(
          accountlink: ret.entries
              .firstWhere((entry) => entry.key == 'accountlink',
              orElse: () => const MapEntry('accountlink', ''))
              .value as String,
          account: ret.entries
              .firstWhere((entry) => entry.key == 'account',
              orElse: () => const MapEntry('account', ''))
              .value as String,
          success: true);

  }}
