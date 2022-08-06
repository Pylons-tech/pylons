
class StripeRegisterAccountResponse {
  final String accountlink;
  final String account;
  final bool success;

  StripeRegisterAccountResponse({
    this.accountlink = '',
    this.account = '',
    this.success = false,
  });

  factory StripeRegisterAccountResponse.from(
      Map<String, dynamic> ret) {

      return StripeRegisterAccountResponse(
          accountlink: ret.entries
              .firstWhere((entry) => entry.key == 'accountlink',
                  orElse: () => const MapEntry('accountlink', ''))
              .value as String,
          account: ret.entries
              .firstWhere((entry) => entry.key == 'account',
                  orElse: () => const MapEntry('account', ''))
              .value as String,
          success: true);

  }
}
