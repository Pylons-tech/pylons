import 'package:pylons_wallet/utils/query_helper.dart';

class StripePayoutResponse {
  final String transfer_id;
  final bool success;

  StripePayoutResponse({this.transfer_id = '', this.success = false});

  factory StripePayoutResponse.from(RequestResult<Map<String, dynamic>> ret) {
    if (ret.isSuccessful && ret.value != null) {
      return StripePayoutResponse(
          transfer_id: ret.value?.entries
              .firstWhere((entry) => entry.key == 'transfer_id',
                  orElse: () => const MapEntry('transfer_id', ''))
              .value as String,
          success: true);
    }
    return StripePayoutResponse();
  }
}
