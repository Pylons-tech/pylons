import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

/// Contains the data returned when performing a chain query.
class RequestResult<T> extends Equatable {
  final T? value;
  final String? error;

  bool get isSuccessful => error == null;

  const RequestResult({
    this.value,
    this.error,
  });

  @override
  List<Object?> get props => [value, error];
}

/// Allows to easily query the current chain state.
abstract class QueryHelper {
  /// GET Queries the chain at the given [url].
  /// params [url]
  /// return [RequestResult<Map<String, dynamic>>]
  Future<RequestResult<Map<String, dynamic>>> queryGet(String url);

  /// POST Queries the chain at the given [url].
  /// params [url, json]
  /// return [RequestResult<Map<String, dynamic>>]
  Future<RequestResult<Map<String, dynamic>>> queryPost(String url, Map json);
}

class QueryHelperImp implements QueryHelper {
  final http.Client httpClient;

  QueryHelperImp({required this.httpClient});

  @override
  Future<RequestResult<Map<String, dynamic>>> queryGet(
    String url,
  ) async {
    final data = await httpClient.get(Uri.parse(url));

    if (data.statusCode != HttpStatus.ok) {
      return RequestResult(
        error: 'Call to $url returned status code: ${data.statusCode} msg: ${data.body}',
      );
    }

    return RequestResult(
      value: json.decode(utf8.decode(data.bodyBytes)) as Map<String, dynamic>,
    );
  }

  @override
  Future<RequestResult<Map<String, dynamic>>> queryPost(String url, Map json) async {
    final data = await httpClient.post(Uri.parse(url), headers: {"Content-type": "application/json"}, body: jsonEncode(json));
    if (data.statusCode != HttpStatus.ok) {
      return RequestResult(
        error: 'Call to $url returned status code: ${data.statusCode} msg:${data.body}',
      );
    }

    return RequestResult(
      value: jsonDecode(utf8.decode(data.bodyBytes)) as Map<String, dynamic>,
    );
  }
}
