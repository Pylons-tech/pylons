import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pylons_wallet/utils/query_helper.dart';

class MockQueryHelper extends QueryHelper {
  final http.Client httpClient;

  MockQueryHelper({required this.httpClient});

  @override
  Future<RequestResult<Map<String, dynamic>>> queryGet(String url) async {
    final response = await httpClient.get(Uri.parse(url), headers: {"Content-type": "application/json"});
    return RequestResult(
      value: json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
    );
  }

  @override
  Future<RequestResult<Map<String, dynamic>>> queryPost(String url, Map data) async {
    final response = await httpClient.post(Uri.parse(url), headers: {"Content-type": "application/json"}, body: jsonEncode(data));
    return RequestResult(
      value: json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
    );
  }
}
