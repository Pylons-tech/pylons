import 'package:http/http.dart' as http;
import 'package:pylons_wallet/utils/query_helper.dart';

class MockQueryHelper extends QueryHelper {
  final http.Client httpClient;

  MockQueryHelper({required this.httpClient});

  @override
  Future<RequestResult<Map<String, dynamic>>> queryGet(String url) {
    return Future.value(const RequestResult(
      error: "",
      value: {},
    ));
  }

  @override
  Future<RequestResult<Map<String, dynamic>>> queryPost(String url, Map json) {
    return Future.value(const RequestResult(error: "", value: {}));
  }
}
