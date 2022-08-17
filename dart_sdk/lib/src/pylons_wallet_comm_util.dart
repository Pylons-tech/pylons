import 'dart:convert';

import 'package:dartz/dartz.dart';

import 'package:pylons_sdk/pylons_sdk.dart';

import 'core/constants/strings.dart';

/// Utilities for building/checking messages for the current message protocol.
/// (Since this protocol is ad-hoc, specific, and strictly temporary, these may
/// be weird or fiddly or otherwise awkward to work with.)
class PylonsWalletCommUtil {
  static bool responseIsError(String v, String key) {
    return v == 'err_$key';
  }

  /// Checks whether or not [response] contains a value for the provided key [key].
  ///
  /// Throws a [ResponseException] if the response does not contain a value associated
  /// with the key, or the value associated with the key is an error.
  static void validateResponseMatchesKey(
      String key, Tuple2<String, List<String>> response) {
    if ((response.value1 != 'response_$key' && response.value1 != 'err_$key')) {
      throw ResponseException(
          const JsonEncoder().convert(response), 'Bad response: $response');
    }
  }

  /// Handles all errors in [response] that are in the provided list [errors].
  ///
  /// If no errors in the list are present in the response, throws an
  /// [UnhandledErrorException].
  ///
  /// This function assumes that the provided response is an error, so call it
  /// only after verifying that.
  static void handleErrors(
      Tuple2<String, List<String>> response, List<String> errors) {
    if (errors.contains(response.value2[0])) {
      switch (response.value1) {
        case Strings.ERR_NODE:
          {
            checkError(
                Strings.ERR_NODE,
                response,
                NodeInternalErrorException(
                    int.parse(response.value2[1]),
                    response.value2[2],
                    'Node threw an unexpected error! Debug this!'));
            break;
          }
        case Strings.ERR_PROFILE_DOES_NOT_EXIST:
          {
            checkError(Strings.ERR_PROFILE_DOES_NOT_EXIST, response,
                ProfileDoesNotExistException(response.value2[1]));
            break;
          }
        case Strings.ERR_PAYMENT_NOT_VALID:
          {
            checkError(Strings.ERR_PAYMENT_NOT_VALID, response,
                PaymentNotValidException(response.value2[1], 'Bad payment'));
            break;
          }
        case Strings.ERR_INSUFFICIENT_FUNDS:
          {
            checkError(Strings.ERR_INSUFFICIENT_FUNDS, response,
                ProfileStateException('Insufficient funds'));
            break;
          }
        case Strings.ERR_COOKBOOK_ALREADY_EXISTS:
          {
            checkError(
                Strings.ERR_COOKBOOK_ALREADY_EXISTS,
                response,
                CookbookAlreadyExistsException(response.value2[1],
                    response.value2[2], 'Cookbook already exists'));
            break;
          }
        case Strings.ERR_COOKBOOK_DOES_NOT_EXIST:
          {
            checkError(
              Strings.ERR_COOKBOOK_DOES_NOT_EXIST,
              response,
              CookbookDoesNotExistException(
                  response.value2[1], 'Cookbook does not exist'),
            );
            break;
          }
        case Strings.ERR_COOKBOOK_NOT_OWNED:
          {
            checkError(
              Strings.ERR_COOKBOOK_NOT_OWNED,
              response,
              CookbookNotOwnedException(
                  response.value2[1], response.value2[2], 'Cookbook not owned'),
            );
            break;
          }
        case Strings.ERR_RECIPE_ALREADY_EXISTS:
          {
            checkError(
              Strings.ERR_RECIPE_ALREADY_EXISTS,
              response,
              RecipeAlreadyExistsException(response.value2[1],
                  response.value2[2], 'Recipe already exists'),
            );
            break;
          }
        case Strings.ERR_RECIPE_ALREADY_DISABLED:
          {
            checkError(
              Strings.ERR_RECIPE_ALREADY_DISABLED,
              response,
              RecipeStateException(response.value2[1], response.value2[2],
                  response.value2[3], 'Recipe already disabled'),
            );
            break;
          }
        case Strings.ERR_RECIPE_ALREADY_ENABLED:
          {
            checkError(
              Strings.ERR_RECIPE_ALREADY_ENABLED,
              response,
              RecipeStateException(response.value2[1], response.value2[2],
                  response.value2[3], 'Recipe already enabled'),
            );
            break;
          }
      }
    } else {
      throw UnhandledErrorException(
          response.value1, 'Unknown error passed: ${response.value2}');
    }
  }

  /// Checks whether [response] contains the provided error [err].
  /// If found, throws [exception].
  ///
  /// Alternatively, throws an [UnhandledErrorException] if an error other than
  /// that expected is found.
  static void checkError(
      String err, Tuple2<String, List<String>> response, Exception exception) {
    if (response.value2[0] == err) {
      throw exception;
    } else {
      throw UnhandledErrorException(
          err, 'Bad error passed: ${response.value2}');
    }
  }

  /// Parses the base64-encoded UTF8 string [response] and outputs a [Tuple2<String, List<String>>].
  /// The first element of the tuple is the response's key; the second element is a list containing
  /// the response data.
  static Tuple2<String, List<String>> procResponse(String response) {
    var decoder = const Utf8Decoder();
    var splut = response.split(',');
    var key = decoder.convert(base64Decode(splut.first));
    var elems = splut.sublist(1, splut.length);
    for (var i = 0; i < elems.length; i++) {
      elems[i] = decoder.convert(base64Decode(elems[i]));
    }
    return Tuple2<String, List<String>>(key, elems);
  }
}
