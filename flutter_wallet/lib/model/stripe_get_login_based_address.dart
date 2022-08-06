class StripeGetLoginBasedOnAddressRequest {
  String address;
  StripeGetLoginBasedOnAddressRequest(this.address);


  Map<String, dynamic> toJson() => {
    "address" : address
  };


}



class StripeGetLoginBasedOnAddressResponse {
  final String accountlink;
  final String account;
  final bool success;

  StripeGetLoginBasedOnAddressResponse(
      {this.accountlink = '', this.account = '', this.success = false});

  factory StripeGetLoginBasedOnAddressResponse.from(
      Map<String, dynamic> ret) {

      return StripeGetLoginBasedOnAddressResponse(
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
