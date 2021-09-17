///
//  Generated code. Do not modify.
//  source: pylons/query.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:pylons_wallet/modules/pylons/module/client/pylons/query.pb.dart' as $0;
export 'query.pb.dart';

class QueryClient extends $grpc.Client {
  static final _$addrFromPubKey =
      $grpc.ClientMethod<$0.AddrFromPubKeyRequest, $0.AddrFromPubKeyResponse>(
          '/pylons.Query/AddrFromPubKey',
          ($0.AddrFromPubKeyRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.AddrFromPubKeyResponse.fromBuffer(value));
  static final _$checkGoogleIAPOrder = $grpc.ClientMethod<
          $0.CheckGoogleIAPOrderRequest, $0.CheckGoogleIAPOrderResponse>(
      '/pylons.Query/CheckGoogleIAPOrder',
      ($0.CheckGoogleIAPOrderRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.CheckGoogleIAPOrderResponse.fromBuffer(value));
  static final _$getCookbook =
      $grpc.ClientMethod<$0.GetCookbookRequest, $0.GetCookbookResponse>(
          '/pylons.Query/GetCookbook',
          ($0.GetCookbookRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GetCookbookResponse.fromBuffer(value));
  static final _$getExecution =
      $grpc.ClientMethod<$0.GetExecutionRequest, $0.GetExecutionResponse>(
          '/pylons.Query/GetExecution',
          ($0.GetExecutionRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GetExecutionResponse.fromBuffer(value));
  static final _$getItem =
      $grpc.ClientMethod<$0.GetItemRequest, $0.GetItemResponse>(
          '/pylons.Query/GetItem',
          ($0.GetItemRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GetItemResponse.fromBuffer(value));
  static final _$getRecipe =
      $grpc.ClientMethod<$0.GetRecipeRequest, $0.GetRecipeResponse>(
          '/pylons.Query/GetRecipe',
          ($0.GetRecipeRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GetRecipeResponse.fromBuffer(value));
  static final _$getTrade =
      $grpc.ClientMethod<$0.GetTradeRequest, $0.GetTradeResponse>(
          '/pylons.Query/GetTrade',
          ($0.GetTradeRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GetTradeResponse.fromBuffer(value));
  static final _$itemsByCookbook =
      $grpc.ClientMethod<$0.ItemsByCookbookRequest, $0.ItemsByCookbookResponse>(
          '/pylons.Query/ItemsByCookbook',
          ($0.ItemsByCookbookRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ItemsByCookbookResponse.fromBuffer(value));
  static final _$itemsBySender =
      $grpc.ClientMethod<$0.ItemsBySenderRequest, $0.ItemsBySenderResponse>(
          '/pylons.Query/ItemsBySender',
          ($0.ItemsBySenderRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ItemsBySenderResponse.fromBuffer(value));
  static final _$listCookbook =
      $grpc.ClientMethod<$0.ListCookbookRequest, $0.ListCookbookResponse>(
          '/pylons.Query/ListCookbook',
          ($0.ListCookbookRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ListCookbookResponse.fromBuffer(value));
  static final _$listExecutions =
      $grpc.ClientMethod<$0.ListExecutionsRequest, $0.ListExecutionsResponse>(
          '/pylons.Query/ListExecutions',
          ($0.ListExecutionsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ListExecutionsResponse.fromBuffer(value));
  static final _$getLockedCoins =
      $grpc.ClientMethod<$0.GetLockedCoinsRequest, $0.GetLockedCoinsResponse>(
          '/pylons.Query/GetLockedCoins',
          ($0.GetLockedCoinsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GetLockedCoinsResponse.fromBuffer(value));
  static final _$getLockedCoinDetails = $grpc.ClientMethod<
          $0.GetLockedCoinDetailsRequest, $0.GetLockedCoinDetailsResponse>(
      '/pylons.Query/GetLockedCoinDetails',
      ($0.GetLockedCoinDetailsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.GetLockedCoinDetailsResponse.fromBuffer(value));
  static final _$listRecipe =
      $grpc.ClientMethod<$0.ListRecipeRequest, $0.ListRecipeResponse>(
          '/pylons.Query/ListRecipe',
          ($0.ListRecipeRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ListRecipeResponse.fromBuffer(value));
  static final _$listRecipeByCookbook = $grpc.ClientMethod<
          $0.ListRecipeByCookbookRequest, $0.ListRecipeByCookbookResponse>(
      '/pylons.Query/ListRecipeByCookbook',
      ($0.ListRecipeByCookbookRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.ListRecipeByCookbookResponse.fromBuffer(value));
  static final _$listShortenRecipe = $grpc.ClientMethod<
          $0.ListShortenRecipeRequest, $0.ListShortenRecipeResponse>(
      '/pylons.Query/ListShortenRecipe',
      ($0.ListShortenRecipeRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.ListShortenRecipeResponse.fromBuffer(value));
  static final _$listShortenRecipeByCookbook = $grpc.ClientMethod<
          $0.ListShortenRecipeByCookbookRequest,
          $0.ListShortenRecipeByCookbookResponse>(
      '/pylons.Query/ListShortenRecipeByCookbook',
      ($0.ListShortenRecipeByCookbookRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.ListShortenRecipeByCookbookResponse.fromBuffer(value));
  static final _$listTrade =
      $grpc.ClientMethod<$0.ListTradeRequest, $0.ListTradeResponse>(
          '/pylons.Query/ListTrade',
          ($0.ListTradeRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ListTradeResponse.fromBuffer(value));
  static final _$pylonsBalance =
      $grpc.ClientMethod<$0.PylonsBalanceRequest, $0.PylonsBalanceResponse>(
          '/pylons.Query/PylonsBalance',
          ($0.PylonsBalanceRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.PylonsBalanceResponse.fromBuffer(value));

  QueryClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options,
      $core.Iterable<$grpc.ClientInterceptor> interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.AddrFromPubKeyResponse> addrFromPubKey(
      $0.AddrFromPubKeyRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$addrFromPubKey, request, options: options);
  }

  $grpc.ResponseFuture<$0.CheckGoogleIAPOrderResponse> checkGoogleIAPOrder(
      $0.CheckGoogleIAPOrderRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$checkGoogleIAPOrder, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetCookbookResponse> getCookbook(
      $0.GetCookbookRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$getCookbook, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetExecutionResponse> getExecution(
      $0.GetExecutionRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$getExecution, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetItemResponse> getItem($0.GetItemRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$getItem, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetRecipeResponse> getRecipe(
      $0.GetRecipeRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$getRecipe, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetTradeResponse> getTrade($0.GetTradeRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$getTrade, request, options: options);
  }

  $grpc.ResponseFuture<$0.ItemsByCookbookResponse> itemsByCookbook(
      $0.ItemsByCookbookRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$itemsByCookbook, request, options: options);
  }

  $grpc.ResponseFuture<$0.ItemsBySenderResponse> itemsBySender(
      $0.ItemsBySenderRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$itemsBySender, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListCookbookResponse> listCookbook(
      $0.ListCookbookRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$listCookbook, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListExecutionsResponse> listExecutions(
      $0.ListExecutionsRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$listExecutions, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetLockedCoinsResponse> getLockedCoins(
      $0.GetLockedCoinsRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$getLockedCoins, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetLockedCoinDetailsResponse> getLockedCoinDetails(
      $0.GetLockedCoinDetailsRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$getLockedCoinDetails, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListRecipeResponse> listRecipe(
      $0.ListRecipeRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$listRecipe, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListRecipeByCookbookResponse> listRecipeByCookbook(
      $0.ListRecipeByCookbookRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$listRecipeByCookbook, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListShortenRecipeResponse> listShortenRecipe(
      $0.ListShortenRecipeRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$listShortenRecipe, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListShortenRecipeByCookbookResponse>
      listShortenRecipeByCookbook($0.ListShortenRecipeByCookbookRequest request,
          {$grpc.CallOptions options}) {
    return $createUnaryCall(_$listShortenRecipeByCookbook, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.ListTradeResponse> listTrade(
      $0.ListTradeRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$listTrade, request, options: options);
  }

  $grpc.ResponseFuture<$0.PylonsBalanceResponse> pylonsBalance(
      $0.PylonsBalanceRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$pylonsBalance, request, options: options);
  }
}

abstract class QueryServiceBase extends $grpc.Service {
  $core.String get $name => 'pylons.Query';

  QueryServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.AddrFromPubKeyRequest,
            $0.AddrFromPubKeyResponse>(
        'AddrFromPubKey',
        addrFromPubKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AddrFromPubKeyRequest.fromBuffer(value),
        ($0.AddrFromPubKeyResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CheckGoogleIAPOrderRequest,
            $0.CheckGoogleIAPOrderResponse>(
        'CheckGoogleIAPOrder',
        checkGoogleIAPOrder_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CheckGoogleIAPOrderRequest.fromBuffer(value),
        ($0.CheckGoogleIAPOrderResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetCookbookRequest, $0.GetCookbookResponse>(
            'GetCookbook',
            getCookbook_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetCookbookRequest.fromBuffer(value),
            ($0.GetCookbookResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetExecutionRequest, $0.GetExecutionResponse>(
            'GetExecution',
            getExecution_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetExecutionRequest.fromBuffer(value),
            ($0.GetExecutionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetItemRequest, $0.GetItemResponse>(
        'GetItem',
        getItem_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetItemRequest.fromBuffer(value),
        ($0.GetItemResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetRecipeRequest, $0.GetRecipeResponse>(
        'GetRecipe',
        getRecipe_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetRecipeRequest.fromBuffer(value),
        ($0.GetRecipeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetTradeRequest, $0.GetTradeResponse>(
        'GetTrade',
        getTrade_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetTradeRequest.fromBuffer(value),
        ($0.GetTradeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ItemsByCookbookRequest,
            $0.ItemsByCookbookResponse>(
        'ItemsByCookbook',
        itemsByCookbook_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ItemsByCookbookRequest.fromBuffer(value),
        ($0.ItemsByCookbookResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ItemsBySenderRequest, $0.ItemsBySenderResponse>(
            'ItemsBySender',
            itemsBySender_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ItemsBySenderRequest.fromBuffer(value),
            ($0.ItemsBySenderResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListCookbookRequest, $0.ListCookbookResponse>(
            'ListCookbook',
            listCookbook_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListCookbookRequest.fromBuffer(value),
            ($0.ListCookbookResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListExecutionsRequest,
            $0.ListExecutionsResponse>(
        'ListExecutions',
        listExecutions_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListExecutionsRequest.fromBuffer(value),
        ($0.ListExecutionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetLockedCoinsRequest,
            $0.GetLockedCoinsResponse>(
        'GetLockedCoins',
        getLockedCoins_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetLockedCoinsRequest.fromBuffer(value),
        ($0.GetLockedCoinsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetLockedCoinDetailsRequest,
            $0.GetLockedCoinDetailsResponse>(
        'GetLockedCoinDetails',
        getLockedCoinDetails_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetLockedCoinDetailsRequest.fromBuffer(value),
        ($0.GetLockedCoinDetailsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListRecipeRequest, $0.ListRecipeResponse>(
        'ListRecipe',
        listRecipe_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListRecipeRequest.fromBuffer(value),
        ($0.ListRecipeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListRecipeByCookbookRequest,
            $0.ListRecipeByCookbookResponse>(
        'ListRecipeByCookbook',
        listRecipeByCookbook_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListRecipeByCookbookRequest.fromBuffer(value),
        ($0.ListRecipeByCookbookResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListShortenRecipeRequest,
            $0.ListShortenRecipeResponse>(
        'ListShortenRecipe',
        listShortenRecipe_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListShortenRecipeRequest.fromBuffer(value),
        ($0.ListShortenRecipeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListShortenRecipeByCookbookRequest,
            $0.ListShortenRecipeByCookbookResponse>(
        'ListShortenRecipeByCookbook',
        listShortenRecipeByCookbook_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListShortenRecipeByCookbookRequest.fromBuffer(value),
        ($0.ListShortenRecipeByCookbookResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListTradeRequest, $0.ListTradeResponse>(
        'ListTrade',
        listTrade_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListTradeRequest.fromBuffer(value),
        ($0.ListTradeResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.PylonsBalanceRequest, $0.PylonsBalanceResponse>(
            'PylonsBalance',
            pylonsBalance_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.PylonsBalanceRequest.fromBuffer(value),
            ($0.PylonsBalanceResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.AddrFromPubKeyResponse> addrFromPubKey_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.AddrFromPubKeyRequest> request) async {
    return addrFromPubKey(call, await request);
  }

  $async.Future<$0.CheckGoogleIAPOrderResponse> checkGoogleIAPOrder_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.CheckGoogleIAPOrderRequest> request) async {
    return checkGoogleIAPOrder(call, await request);
  }

  $async.Future<$0.GetCookbookResponse> getCookbook_Pre($grpc.ServiceCall call,
      $async.Future<$0.GetCookbookRequest> request) async {
    return getCookbook(call, await request);
  }

  $async.Future<$0.GetExecutionResponse> getExecution_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.GetExecutionRequest> request) async {
    return getExecution(call, await request);
  }

  $async.Future<$0.GetItemResponse> getItem_Pre(
      $grpc.ServiceCall call, $async.Future<$0.GetItemRequest> request) async {
    return getItem(call, await request);
  }

  $async.Future<$0.GetRecipeResponse> getRecipe_Pre($grpc.ServiceCall call,
      $async.Future<$0.GetRecipeRequest> request) async {
    return getRecipe(call, await request);
  }

  $async.Future<$0.GetTradeResponse> getTrade_Pre(
      $grpc.ServiceCall call, $async.Future<$0.GetTradeRequest> request) async {
    return getTrade(call, await request);
  }

  $async.Future<$0.ItemsByCookbookResponse> itemsByCookbook_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.ItemsByCookbookRequest> request) async {
    return itemsByCookbook(call, await request);
  }

  $async.Future<$0.ItemsBySenderResponse> itemsBySender_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.ItemsBySenderRequest> request) async {
    return itemsBySender(call, await request);
  }

  $async.Future<$0.ListCookbookResponse> listCookbook_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.ListCookbookRequest> request) async {
    return listCookbook(call, await request);
  }

  $async.Future<$0.ListExecutionsResponse> listExecutions_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.ListExecutionsRequest> request) async {
    return listExecutions(call, await request);
  }

  $async.Future<$0.GetLockedCoinsResponse> getLockedCoins_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.GetLockedCoinsRequest> request) async {
    return getLockedCoins(call, await request);
  }

  $async.Future<$0.GetLockedCoinDetailsResponse> getLockedCoinDetails_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.GetLockedCoinDetailsRequest> request) async {
    return getLockedCoinDetails(call, await request);
  }

  $async.Future<$0.ListRecipeResponse> listRecipe_Pre($grpc.ServiceCall call,
      $async.Future<$0.ListRecipeRequest> request) async {
    return listRecipe(call, await request);
  }

  $async.Future<$0.ListRecipeByCookbookResponse> listRecipeByCookbook_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.ListRecipeByCookbookRequest> request) async {
    return listRecipeByCookbook(call, await request);
  }

  $async.Future<$0.ListShortenRecipeResponse> listShortenRecipe_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.ListShortenRecipeRequest> request) async {
    return listShortenRecipe(call, await request);
  }

  $async.Future<$0.ListShortenRecipeByCookbookResponse>
      listShortenRecipeByCookbook_Pre($grpc.ServiceCall call,
          $async.Future<$0.ListShortenRecipeByCookbookRequest> request) async {
    return listShortenRecipeByCookbook(call, await request);
  }

  $async.Future<$0.ListTradeResponse> listTrade_Pre($grpc.ServiceCall call,
      $async.Future<$0.ListTradeRequest> request) async {
    return listTrade(call, await request);
  }

  $async.Future<$0.PylonsBalanceResponse> pylonsBalance_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.PylonsBalanceRequest> request) async {
    return pylonsBalance(call, await request);
  }

  $async.Future<$0.AddrFromPubKeyResponse> addrFromPubKey(
      $grpc.ServiceCall call, $0.AddrFromPubKeyRequest request);
  $async.Future<$0.CheckGoogleIAPOrderResponse> checkGoogleIAPOrder(
      $grpc.ServiceCall call, $0.CheckGoogleIAPOrderRequest request);
  $async.Future<$0.GetCookbookResponse> getCookbook(
      $grpc.ServiceCall call, $0.GetCookbookRequest request);
  $async.Future<$0.GetExecutionResponse> getExecution(
      $grpc.ServiceCall call, $0.GetExecutionRequest request);
  $async.Future<$0.GetItemResponse> getItem(
      $grpc.ServiceCall call, $0.GetItemRequest request);
  $async.Future<$0.GetRecipeResponse> getRecipe(
      $grpc.ServiceCall call, $0.GetRecipeRequest request);
  $async.Future<$0.GetTradeResponse> getTrade(
      $grpc.ServiceCall call, $0.GetTradeRequest request);
  $async.Future<$0.ItemsByCookbookResponse> itemsByCookbook(
      $grpc.ServiceCall call, $0.ItemsByCookbookRequest request);
  $async.Future<$0.ItemsBySenderResponse> itemsBySender(
      $grpc.ServiceCall call, $0.ItemsBySenderRequest request);
  $async.Future<$0.ListCookbookResponse> listCookbook(
      $grpc.ServiceCall call, $0.ListCookbookRequest request);
  $async.Future<$0.ListExecutionsResponse> listExecutions(
      $grpc.ServiceCall call, $0.ListExecutionsRequest request);
  $async.Future<$0.GetLockedCoinsResponse> getLockedCoins(
      $grpc.ServiceCall call, $0.GetLockedCoinsRequest request);
  $async.Future<$0.GetLockedCoinDetailsResponse> getLockedCoinDetails(
      $grpc.ServiceCall call, $0.GetLockedCoinDetailsRequest request);
  $async.Future<$0.ListRecipeResponse> listRecipe(
      $grpc.ServiceCall call, $0.ListRecipeRequest request);
  $async.Future<$0.ListRecipeByCookbookResponse> listRecipeByCookbook(
      $grpc.ServiceCall call, $0.ListRecipeByCookbookRequest request);
  $async.Future<$0.ListShortenRecipeResponse> listShortenRecipe(
      $grpc.ServiceCall call, $0.ListShortenRecipeRequest request);
  $async.Future<$0.ListShortenRecipeByCookbookResponse>
      listShortenRecipeByCookbook($grpc.ServiceCall call,
          $0.ListShortenRecipeByCookbookRequest request);
  $async.Future<$0.ListTradeResponse> listTrade(
      $grpc.ServiceCall call, $0.ListTradeRequest request);
  $async.Future<$0.PylonsBalanceResponse> pylonsBalance(
      $grpc.ServiceCall call, $0.PylonsBalanceRequest request);
}
