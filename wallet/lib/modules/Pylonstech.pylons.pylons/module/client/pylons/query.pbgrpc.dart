///
//  Generated code. Do not modify.
//  source: pylons/pylons/query.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'query.pb.dart' as $0;
export 'query.pb.dart';

class QueryClient extends $grpc.Client {
  static final _$listTradesByCreator = $grpc.ClientMethod<
          $0.QueryListTradesByCreatorRequest,
          $0.QueryListTradesByCreatorResponse>(
      '/pylons.pylons.Query/ListTradesByCreator',
      ($0.QueryListTradesByCreatorRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryListTradesByCreatorResponse.fromBuffer(value));
  static final _$listSignUpByReferee = $grpc.ClientMethod<
          $0.QueryListSignUpByReferee, $0.QueryListSignUpByRefereeResponse>(
      '/pylons.pylons.Query/ListSignUpByReferee',
      ($0.QueryListSignUpByReferee value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryListSignUpByRefereeResponse.fromBuffer(value));
  static final _$getRecipeHistory = $grpc.ClientMethod<
          $0.QueryGetRecipeHistoryRequest, $0.QueryGetRecipeHistoryResponse>(
      '/pylons.pylons.Query/GetRecipeHistory',
      ($0.QueryGetRecipeHistoryRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryGetRecipeHistoryResponse.fromBuffer(value));
  static final _$getStripeRefund = $grpc.ClientMethod<
          $0.QueryGetStripeRefundRequest, $0.QueryGetStripeRefundResponse>(
      '/pylons.pylons.Query/GetStripeRefund',
      ($0.QueryGetStripeRefundRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryGetStripeRefundResponse.fromBuffer(value));
  static final _$getItemOwnershipHistory = $grpc.ClientMethod<
          $0.QueryGetItemHistoryRequest, $0.QueryGetItemHistoryResponse>(
      '/pylons.pylons.Query/GetItemOwnershipHistory',
      ($0.QueryGetItemHistoryRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryGetItemHistoryResponse.fromBuffer(value));
  static final _$redeemInfo = $grpc.ClientMethod<$0.QueryGetRedeemInfoRequest,
          $0.QueryGetRedeemInfoResponse>(
      '/pylons.pylons.Query/RedeemInfo',
      ($0.QueryGetRedeemInfoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryGetRedeemInfoResponse.fromBuffer(value));
  static final _$redeemInfoAll = $grpc.ClientMethod<
          $0.QueryAllRedeemInfoRequest, $0.QueryAllRedeemInfoResponse>(
      '/pylons.pylons.Query/RedeemInfoAll',
      ($0.QueryAllRedeemInfoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryAllRedeemInfoResponse.fromBuffer(value));
  static final _$paymentInfo = $grpc.ClientMethod<$0.QueryGetPaymentInfoRequest,
          $0.QueryGetPaymentInfoResponse>(
      '/pylons.pylons.Query/PaymentInfo',
      ($0.QueryGetPaymentInfoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryGetPaymentInfoResponse.fromBuffer(value));
  static final _$paymentInfoAll = $grpc.ClientMethod<
          $0.QueryAllPaymentInfoRequest, $0.QueryAllPaymentInfoResponse>(
      '/pylons.pylons.Query/PaymentInfoAll',
      ($0.QueryAllPaymentInfoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryAllPaymentInfoResponse.fromBuffer(value));
  static final _$usernameByAddress = $grpc.ClientMethod<
          $0.QueryGetUsernameByAddressRequest,
          $0.QueryGetUsernameByAddressResponse>(
      '/pylons.pylons.Query/UsernameByAddress',
      ($0.QueryGetUsernameByAddressRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryGetUsernameByAddressResponse.fromBuffer(value));
  static final _$addressByUsername = $grpc.ClientMethod<
          $0.QueryGetAddressByUsernameRequest,
          $0.QueryGetAddressByUsernameResponse>(
      '/pylons.pylons.Query/AddressByUsername',
      ($0.QueryGetAddressByUsernameRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryGetAddressByUsernameResponse.fromBuffer(value));
  static final _$trade =
      $grpc.ClientMethod<$0.QueryGetTradeRequest, $0.QueryGetTradeResponse>(
          '/pylons.pylons.Query/Trade',
          ($0.QueryGetTradeRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.QueryGetTradeResponse.fromBuffer(value));
  static final _$listItemByOwner = $grpc.ClientMethod<
          $0.QueryListItemByOwnerRequest, $0.QueryListItemByOwnerResponse>(
      '/pylons.pylons.Query/ListItemByOwner',
      ($0.QueryListItemByOwnerRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryListItemByOwnerResponse.fromBuffer(value));
  static final _$googleInAppPurchaseOrder = $grpc.ClientMethod<
          $0.QueryGetGoogleInAppPurchaseOrderRequest,
          $0.QueryGetGoogleInAppPurchaseOrderResponse>(
      '/pylons.pylons.Query/GoogleInAppPurchaseOrder',
      ($0.QueryGetGoogleInAppPurchaseOrderRequest value) =>
          value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryGetGoogleInAppPurchaseOrderResponse.fromBuffer(value));
  static final _$listExecutionsByItem = $grpc.ClientMethod<
          $0.QueryListExecutionsByItemRequest,
          $0.QueryListExecutionsByItemResponse>(
      '/pylons.pylons.Query/ListExecutionsByItem',
      ($0.QueryListExecutionsByItemRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryListExecutionsByItemResponse.fromBuffer(value));
  static final _$listExecutionsByRecipe = $grpc.ClientMethod<
          $0.QueryListExecutionsByRecipeRequest,
          $0.QueryListExecutionsByRecipeResponse>(
      '/pylons.pylons.Query/ListExecutionsByRecipe',
      ($0.QueryListExecutionsByRecipeRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryListExecutionsByRecipeResponse.fromBuffer(value));
  static final _$execution = $grpc.ClientMethod<$0.QueryGetExecutionRequest,
          $0.QueryGetExecutionResponse>(
      '/pylons.pylons.Query/Execution',
      ($0.QueryGetExecutionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryGetExecutionResponse.fromBuffer(value));
  static final _$listRecipesByCookbook = $grpc.ClientMethod<
          $0.QueryListRecipesByCookbookRequest,
          $0.QueryListRecipesByCookbookResponse>(
      '/pylons.pylons.Query/ListRecipesByCookbook',
      ($0.QueryListRecipesByCookbookRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryListRecipesByCookbookResponse.fromBuffer(value));
  static final _$item =
      $grpc.ClientMethod<$0.QueryGetItemRequest, $0.QueryGetItemResponse>(
          '/pylons.pylons.Query/Item',
          ($0.QueryGetItemRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.QueryGetItemResponse.fromBuffer(value));
  static final _$recipe =
      $grpc.ClientMethod<$0.QueryGetRecipeRequest, $0.QueryGetRecipeResponse>(
          '/pylons.pylons.Query/Recipe',
          ($0.QueryGetRecipeRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.QueryGetRecipeResponse.fromBuffer(value));
  static final _$listCookbooksByCreator = $grpc.ClientMethod<
          $0.QueryListCookbooksByCreatorRequest,
          $0.QueryListCookbooksByCreatorResponse>(
      '/pylons.pylons.Query/ListCookbooksByCreator',
      ($0.QueryListCookbooksByCreatorRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryListCookbooksByCreatorResponse.fromBuffer(value));
  static final _$cookbook = $grpc.ClientMethod<$0.QueryGetCookbookRequest,
          $0.QueryGetCookbookResponse>(
      '/pylons.pylons.Query/Cookbook',
      ($0.QueryGetCookbookRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryGetCookbookResponse.fromBuffer(value));

  QueryClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.QueryListTradesByCreatorResponse> listTradesByCreator(
      $0.QueryListTradesByCreatorRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listTradesByCreator, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryListSignUpByRefereeResponse> listSignUpByReferee(
      $0.QueryListSignUpByReferee request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listSignUpByReferee, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetRecipeHistoryResponse> getRecipeHistory(
      $0.QueryGetRecipeHistoryRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getRecipeHistory, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetStripeRefundResponse> getStripeRefund(
      $0.QueryGetStripeRefundRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getStripeRefund, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetItemHistoryResponse> getItemOwnershipHistory(
      $0.QueryGetItemHistoryRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getItemOwnershipHistory, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetRedeemInfoResponse> redeemInfo(
      $0.QueryGetRedeemInfoRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$redeemInfo, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryAllRedeemInfoResponse> redeemInfoAll(
      $0.QueryAllRedeemInfoRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$redeemInfoAll, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetPaymentInfoResponse> paymentInfo(
      $0.QueryGetPaymentInfoRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$paymentInfo, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryAllPaymentInfoResponse> paymentInfoAll(
      $0.QueryAllPaymentInfoRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$paymentInfoAll, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetUsernameByAddressResponse> usernameByAddress(
      $0.QueryGetUsernameByAddressRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$usernameByAddress, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetAddressByUsernameResponse> addressByUsername(
      $0.QueryGetAddressByUsernameRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$addressByUsername, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetTradeResponse> trade(
      $0.QueryGetTradeRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$trade, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryListItemByOwnerResponse> listItemByOwner(
      $0.QueryListItemByOwnerRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listItemByOwner, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetGoogleInAppPurchaseOrderResponse>
      googleInAppPurchaseOrder(
          $0.QueryGetGoogleInAppPurchaseOrderRequest request,
          {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$googleInAppPurchaseOrder, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.QueryListExecutionsByItemResponse>
      listExecutionsByItem($0.QueryListExecutionsByItemRequest request,
          {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listExecutionsByItem, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryListExecutionsByRecipeResponse>
      listExecutionsByRecipe($0.QueryListExecutionsByRecipeRequest request,
          {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listExecutionsByRecipe, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetExecutionResponse> execution(
      $0.QueryGetExecutionRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$execution, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryListRecipesByCookbookResponse>
      listRecipesByCookbook($0.QueryListRecipesByCookbookRequest request,
          {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listRecipesByCookbook, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetItemResponse> item(
      $0.QueryGetItemRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$item, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetRecipeResponse> recipe(
      $0.QueryGetRecipeRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$recipe, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryListCookbooksByCreatorResponse>
      listCookbooksByCreator($0.QueryListCookbooksByCreatorRequest request,
          {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listCookbooksByCreator, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetCookbookResponse> cookbook(
      $0.QueryGetCookbookRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$cookbook, request, options: options);
  }
}

abstract class QueryServiceBase extends $grpc.Service {
  $core.String get $name => 'pylons.pylons.Query';

  QueryServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.QueryListTradesByCreatorRequest,
            $0.QueryListTradesByCreatorResponse>(
        'ListTradesByCreator',
        listTradesByCreator_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryListTradesByCreatorRequest.fromBuffer(value),
        ($0.QueryListTradesByCreatorResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryListSignUpByReferee,
            $0.QueryListSignUpByRefereeResponse>(
        'ListSignUpByReferee',
        listSignUpByReferee_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryListSignUpByReferee.fromBuffer(value),
        ($0.QueryListSignUpByRefereeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryGetRecipeHistoryRequest,
            $0.QueryGetRecipeHistoryResponse>(
        'GetRecipeHistory',
        getRecipeHistory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryGetRecipeHistoryRequest.fromBuffer(value),
        ($0.QueryGetRecipeHistoryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryGetStripeRefundRequest,
            $0.QueryGetStripeRefundResponse>(
        'GetStripeRefund',
        getStripeRefund_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryGetStripeRefundRequest.fromBuffer(value),
        ($0.QueryGetStripeRefundResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryGetItemHistoryRequest,
            $0.QueryGetItemHistoryResponse>(
        'GetItemOwnershipHistory',
        getItemOwnershipHistory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryGetItemHistoryRequest.fromBuffer(value),
        ($0.QueryGetItemHistoryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryGetRedeemInfoRequest,
            $0.QueryGetRedeemInfoResponse>(
        'RedeemInfo',
        redeemInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryGetRedeemInfoRequest.fromBuffer(value),
        ($0.QueryGetRedeemInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryAllRedeemInfoRequest,
            $0.QueryAllRedeemInfoResponse>(
        'RedeemInfoAll',
        redeemInfoAll_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryAllRedeemInfoRequest.fromBuffer(value),
        ($0.QueryAllRedeemInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryGetPaymentInfoRequest,
            $0.QueryGetPaymentInfoResponse>(
        'PaymentInfo',
        paymentInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryGetPaymentInfoRequest.fromBuffer(value),
        ($0.QueryGetPaymentInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryAllPaymentInfoRequest,
            $0.QueryAllPaymentInfoResponse>(
        'PaymentInfoAll',
        paymentInfoAll_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryAllPaymentInfoRequest.fromBuffer(value),
        ($0.QueryAllPaymentInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryGetUsernameByAddressRequest,
            $0.QueryGetUsernameByAddressResponse>(
        'UsernameByAddress',
        usernameByAddress_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryGetUsernameByAddressRequest.fromBuffer(value),
        ($0.QueryGetUsernameByAddressResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryGetAddressByUsernameRequest,
            $0.QueryGetAddressByUsernameResponse>(
        'AddressByUsername',
        addressByUsername_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryGetAddressByUsernameRequest.fromBuffer(value),
        ($0.QueryGetAddressByUsernameResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.QueryGetTradeRequest, $0.QueryGetTradeResponse>(
            'Trade',
            trade_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.QueryGetTradeRequest.fromBuffer(value),
            ($0.QueryGetTradeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryListItemByOwnerRequest,
            $0.QueryListItemByOwnerResponse>(
        'ListItemByOwner',
        listItemByOwner_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryListItemByOwnerRequest.fromBuffer(value),
        ($0.QueryListItemByOwnerResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryGetGoogleInAppPurchaseOrderRequest,
            $0.QueryGetGoogleInAppPurchaseOrderResponse>(
        'GoogleInAppPurchaseOrder',
        googleInAppPurchaseOrder_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryGetGoogleInAppPurchaseOrderRequest.fromBuffer(value),
        ($0.QueryGetGoogleInAppPurchaseOrderResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryListExecutionsByItemRequest,
            $0.QueryListExecutionsByItemResponse>(
        'ListExecutionsByItem',
        listExecutionsByItem_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryListExecutionsByItemRequest.fromBuffer(value),
        ($0.QueryListExecutionsByItemResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryListExecutionsByRecipeRequest,
            $0.QueryListExecutionsByRecipeResponse>(
        'ListExecutionsByRecipe',
        listExecutionsByRecipe_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryListExecutionsByRecipeRequest.fromBuffer(value),
        ($0.QueryListExecutionsByRecipeResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryGetExecutionRequest,
            $0.QueryGetExecutionResponse>(
        'Execution',
        execution_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryGetExecutionRequest.fromBuffer(value),
        ($0.QueryGetExecutionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryListRecipesByCookbookRequest,
            $0.QueryListRecipesByCookbookResponse>(
        'ListRecipesByCookbook',
        listRecipesByCookbook_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryListRecipesByCookbookRequest.fromBuffer(value),
        ($0.QueryListRecipesByCookbookResponse value) =>
            value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.QueryGetItemRequest, $0.QueryGetItemResponse>(
            'Item',
            item_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.QueryGetItemRequest.fromBuffer(value),
            ($0.QueryGetItemResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryGetRecipeRequest,
            $0.QueryGetRecipeResponse>(
        'Recipe',
        recipe_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryGetRecipeRequest.fromBuffer(value),
        ($0.QueryGetRecipeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryListCookbooksByCreatorRequest,
            $0.QueryListCookbooksByCreatorResponse>(
        'ListCookbooksByCreator',
        listCookbooksByCreator_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryListCookbooksByCreatorRequest.fromBuffer(value),
        ($0.QueryListCookbooksByCreatorResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryGetCookbookRequest,
            $0.QueryGetCookbookResponse>(
        'Cookbook',
        cookbook_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryGetCookbookRequest.fromBuffer(value),
        ($0.QueryGetCookbookResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.QueryListTradesByCreatorResponse> listTradesByCreator_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryListTradesByCreatorRequest> request) async {
    return listTradesByCreator(call, await request);
  }

  $async.Future<$0.QueryListSignUpByRefereeResponse> listSignUpByReferee_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryListSignUpByReferee> request) async {
    return listSignUpByReferee(call, await request);
  }

  $async.Future<$0.QueryGetRecipeHistoryResponse> getRecipeHistory_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryGetRecipeHistoryRequest> request) async {
    return getRecipeHistory(call, await request);
  }

  $async.Future<$0.QueryGetStripeRefundResponse> getStripeRefund_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryGetStripeRefundRequest> request) async {
    return getStripeRefund(call, await request);
  }

  $async.Future<$0.QueryGetItemHistoryResponse> getItemOwnershipHistory_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryGetItemHistoryRequest> request) async {
    return getItemOwnershipHistory(call, await request);
  }

  $async.Future<$0.QueryGetRedeemInfoResponse> redeemInfo_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryGetRedeemInfoRequest> request) async {
    return redeemInfo(call, await request);
  }

  $async.Future<$0.QueryAllRedeemInfoResponse> redeemInfoAll_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryAllRedeemInfoRequest> request) async {
    return redeemInfoAll(call, await request);
  }

  $async.Future<$0.QueryGetPaymentInfoResponse> paymentInfo_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryGetPaymentInfoRequest> request) async {
    return paymentInfo(call, await request);
  }

  $async.Future<$0.QueryAllPaymentInfoResponse> paymentInfoAll_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryAllPaymentInfoRequest> request) async {
    return paymentInfoAll(call, await request);
  }

  $async.Future<$0.QueryGetUsernameByAddressResponse> usernameByAddress_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryGetUsernameByAddressRequest> request) async {
    return usernameByAddress(call, await request);
  }

  $async.Future<$0.QueryGetAddressByUsernameResponse> addressByUsername_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryGetAddressByUsernameRequest> request) async {
    return addressByUsername(call, await request);
  }

  $async.Future<$0.QueryGetTradeResponse> trade_Pre($grpc.ServiceCall call,
      $async.Future<$0.QueryGetTradeRequest> request) async {
    return trade(call, await request);
  }

  $async.Future<$0.QueryListItemByOwnerResponse> listItemByOwner_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryListItemByOwnerRequest> request) async {
    return listItemByOwner(call, await request);
  }

  $async.Future<$0.QueryGetGoogleInAppPurchaseOrderResponse>
      googleInAppPurchaseOrder_Pre(
          $grpc.ServiceCall call,
          $async.Future<$0.QueryGetGoogleInAppPurchaseOrderRequest>
              request) async {
    return googleInAppPurchaseOrder(call, await request);
  }

  $async.Future<$0.QueryListExecutionsByItemResponse> listExecutionsByItem_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryListExecutionsByItemRequest> request) async {
    return listExecutionsByItem(call, await request);
  }

  $async.Future<$0.QueryListExecutionsByRecipeResponse>
      listExecutionsByRecipe_Pre($grpc.ServiceCall call,
          $async.Future<$0.QueryListExecutionsByRecipeRequest> request) async {
    return listExecutionsByRecipe(call, await request);
  }

  $async.Future<$0.QueryGetExecutionResponse> execution_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryGetExecutionRequest> request) async {
    return execution(call, await request);
  }

  $async.Future<$0.QueryListRecipesByCookbookResponse>
      listRecipesByCookbook_Pre($grpc.ServiceCall call,
          $async.Future<$0.QueryListRecipesByCookbookRequest> request) async {
    return listRecipesByCookbook(call, await request);
  }

  $async.Future<$0.QueryGetItemResponse> item_Pre($grpc.ServiceCall call,
      $async.Future<$0.QueryGetItemRequest> request) async {
    return item(call, await request);
  }

  $async.Future<$0.QueryGetRecipeResponse> recipe_Pre($grpc.ServiceCall call,
      $async.Future<$0.QueryGetRecipeRequest> request) async {
    return recipe(call, await request);
  }

  $async.Future<$0.QueryListCookbooksByCreatorResponse>
      listCookbooksByCreator_Pre($grpc.ServiceCall call,
          $async.Future<$0.QueryListCookbooksByCreatorRequest> request) async {
    return listCookbooksByCreator(call, await request);
  }

  $async.Future<$0.QueryGetCookbookResponse> cookbook_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryGetCookbookRequest> request) async {
    return cookbook(call, await request);
  }

  $async.Future<$0.QueryListTradesByCreatorResponse> listTradesByCreator(
      $grpc.ServiceCall call, $0.QueryListTradesByCreatorRequest request);
  $async.Future<$0.QueryListSignUpByRefereeResponse> listSignUpByReferee(
      $grpc.ServiceCall call, $0.QueryListSignUpByReferee request);
  $async.Future<$0.QueryGetRecipeHistoryResponse> getRecipeHistory(
      $grpc.ServiceCall call, $0.QueryGetRecipeHistoryRequest request);
  $async.Future<$0.QueryGetStripeRefundResponse> getStripeRefund(
      $grpc.ServiceCall call, $0.QueryGetStripeRefundRequest request);
  $async.Future<$0.QueryGetItemHistoryResponse> getItemOwnershipHistory(
      $grpc.ServiceCall call, $0.QueryGetItemHistoryRequest request);
  $async.Future<$0.QueryGetRedeemInfoResponse> redeemInfo(
      $grpc.ServiceCall call, $0.QueryGetRedeemInfoRequest request);
  $async.Future<$0.QueryAllRedeemInfoResponse> redeemInfoAll(
      $grpc.ServiceCall call, $0.QueryAllRedeemInfoRequest request);
  $async.Future<$0.QueryGetPaymentInfoResponse> paymentInfo(
      $grpc.ServiceCall call, $0.QueryGetPaymentInfoRequest request);
  $async.Future<$0.QueryAllPaymentInfoResponse> paymentInfoAll(
      $grpc.ServiceCall call, $0.QueryAllPaymentInfoRequest request);
  $async.Future<$0.QueryGetUsernameByAddressResponse> usernameByAddress(
      $grpc.ServiceCall call, $0.QueryGetUsernameByAddressRequest request);
  $async.Future<$0.QueryGetAddressByUsernameResponse> addressByUsername(
      $grpc.ServiceCall call, $0.QueryGetAddressByUsernameRequest request);
  $async.Future<$0.QueryGetTradeResponse> trade(
      $grpc.ServiceCall call, $0.QueryGetTradeRequest request);
  $async.Future<$0.QueryListItemByOwnerResponse> listItemByOwner(
      $grpc.ServiceCall call, $0.QueryListItemByOwnerRequest request);
  $async.Future<$0.QueryGetGoogleInAppPurchaseOrderResponse>
      googleInAppPurchaseOrder($grpc.ServiceCall call,
          $0.QueryGetGoogleInAppPurchaseOrderRequest request);
  $async.Future<$0.QueryListExecutionsByItemResponse> listExecutionsByItem(
      $grpc.ServiceCall call, $0.QueryListExecutionsByItemRequest request);
  $async.Future<$0.QueryListExecutionsByRecipeResponse> listExecutionsByRecipe(
      $grpc.ServiceCall call, $0.QueryListExecutionsByRecipeRequest request);
  $async.Future<$0.QueryGetExecutionResponse> execution(
      $grpc.ServiceCall call, $0.QueryGetExecutionRequest request);
  $async.Future<$0.QueryListRecipesByCookbookResponse> listRecipesByCookbook(
      $grpc.ServiceCall call, $0.QueryListRecipesByCookbookRequest request);
  $async.Future<$0.QueryGetItemResponse> item(
      $grpc.ServiceCall call, $0.QueryGetItemRequest request);
  $async.Future<$0.QueryGetRecipeResponse> recipe(
      $grpc.ServiceCall call, $0.QueryGetRecipeRequest request);
  $async.Future<$0.QueryListCookbooksByCreatorResponse> listCookbooksByCreator(
      $grpc.ServiceCall call, $0.QueryListCookbooksByCreatorRequest request);
  $async.Future<$0.QueryGetCookbookResponse> cookbook(
      $grpc.ServiceCall call, $0.QueryGetCookbookRequest request);
}
