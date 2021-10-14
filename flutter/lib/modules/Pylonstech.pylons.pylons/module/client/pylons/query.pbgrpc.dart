///
//  Generated code. Do not modify.
//  source: pylons/query.proto
//

// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/query.pb.dart' as $0;
export 'query.pb.dart';

class QueryClient extends $grpc.Client {
  static final _$usernameByAddress = $grpc.ClientMethod<$0.QueryGetUsernameByAddressRequest, $0.QueryGetUsernameByAddressResponse>('/Pylonstech.pylons.pylons.Query/UsernameByAddress',
      ($0.QueryGetUsernameByAddressRequest value) => value.writeToBuffer(), ($core.List<$core.int> value) => $0.QueryGetUsernameByAddressResponse.fromBuffer(value));
  static final _$addressByUsername = $grpc.ClientMethod<$0.QueryGetAddressByUsernameRequest, $0.QueryGetAddressByUsernameResponse>('/Pylonstech.pylons.pylons.Query/AddressByUsername',
      ($0.QueryGetAddressByUsernameRequest value) => value.writeToBuffer(), ($core.List<$core.int> value) => $0.QueryGetAddressByUsernameResponse.fromBuffer(value));
  static final _$trade = $grpc.ClientMethod<$0.QueryGetTradeRequest, $0.QueryGetTradeResponse>(
      '/Pylonstech.pylons.pylons.Query/Trade', ($0.QueryGetTradeRequest value) => value.writeToBuffer(), ($core.List<$core.int> value) => $0.QueryGetTradeResponse.fromBuffer(value));
  static final _$listItemByOwner = $grpc.ClientMethod<$0.QueryListItemByOwnerRequest, $0.QueryListItemByOwnerResponse>('/Pylonstech.pylons.pylons.Query/ListItemByOwner',
      ($0.QueryListItemByOwnerRequest value) => value.writeToBuffer(), ($core.List<$core.int> value) => $0.QueryListItemByOwnerResponse.fromBuffer(value));
  static final _$googleInAppPurchaseOrder = $grpc.ClientMethod<$0.QueryGetGoogleInAppPurchaseOrderRequest, $0.QueryGetGoogleInAppPurchaseOrderResponse>(
      '/Pylonstech.pylons.pylons.Query/GoogleInAppPurchaseOrder',
      ($0.QueryGetGoogleInAppPurchaseOrderRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.QueryGetGoogleInAppPurchaseOrderResponse.fromBuffer(value));
  static final _$listExecutionsByItem = $grpc.ClientMethod<$0.QueryListExecutionsByItemRequest, $0.QueryListExecutionsByItemResponse>('/Pylonstech.pylons.pylons.Query/ListExecutionsByItem',
      ($0.QueryListExecutionsByItemRequest value) => value.writeToBuffer(), ($core.List<$core.int> value) => $0.QueryListExecutionsByItemResponse.fromBuffer(value));
  static final _$listExecutionsByRecipe = $grpc.ClientMethod<$0.QueryListExecutionsByRecipeRequest, $0.QueryListExecutionsByRecipeResponse>('/Pylonstech.pylons.pylons.Query/ListExecutionsByRecipe',
      ($0.QueryListExecutionsByRecipeRequest value) => value.writeToBuffer(), ($core.List<$core.int> value) => $0.QueryListExecutionsByRecipeResponse.fromBuffer(value));
  static final _$execution = $grpc.ClientMethod<$0.QueryGetExecutionRequest, $0.QueryGetExecutionResponse>(
      '/Pylonstech.pylons.pylons.Query/Execution', ($0.QueryGetExecutionRequest value) => value.writeToBuffer(), ($core.List<$core.int> value) => $0.QueryGetExecutionResponse.fromBuffer(value));
  static final _$listRecipesByCookbook = $grpc.ClientMethod<$0.QueryListRecipesByCookbookRequest, $0.QueryListRecipesByCookbookResponse>('/Pylonstech.pylons.pylons.Query/ListRecipesByCookbook',
      ($0.QueryListRecipesByCookbookRequest value) => value.writeToBuffer(), ($core.List<$core.int> value) => $0.QueryListRecipesByCookbookResponse.fromBuffer(value));
  static final _$item = $grpc.ClientMethod<$0.QueryGetItemRequest, $0.QueryGetItemResponse>(
      '/Pylonstech.pylons.pylons.Query/Item', ($0.QueryGetItemRequest value) => value.writeToBuffer(), ($core.List<$core.int> value) => $0.QueryGetItemResponse.fromBuffer(value));
  static final _$recipe = $grpc.ClientMethod<$0.QueryGetRecipeRequest, $0.QueryGetRecipeResponse>(
      '/Pylonstech.pylons.pylons.Query/Recipe', ($0.QueryGetRecipeRequest value) => value.writeToBuffer(), ($core.List<$core.int> value) => $0.QueryGetRecipeResponse.fromBuffer(value));
  static final _$listCookbooksByCreator = $grpc.ClientMethod<$0.QueryListCookbooksByCreatorRequest, $0.QueryListCookbooksByCreatorResponse>('/Pylonstech.pylons.pylons.Query/ListCookbooksByCreator',
      ($0.QueryListCookbooksByCreatorRequest value) => value.writeToBuffer(), ($core.List<$core.int> value) => $0.QueryListCookbooksByCreatorResponse.fromBuffer(value));
  static final _$cookbook = $grpc.ClientMethod<$0.QueryGetCookbookRequest, $0.QueryGetCookbookResponse>(
      '/Pylonstech.pylons.pylons.Query/Cookbook', ($0.QueryGetCookbookRequest value) => value.writeToBuffer(), ($core.List<$core.int> value) => $0.QueryGetCookbookResponse.fromBuffer(value));

  QueryClient($grpc.ClientChannel channel, {$grpc.CallOptions? options, $core.Iterable<$grpc.ClientInterceptor>? interceptors}) : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.QueryGetUsernameByAddressResponse> usernameByAddress($0.QueryGetUsernameByAddressRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$usernameByAddress, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetAddressByUsernameResponse> addressByUsername($0.QueryGetAddressByUsernameRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$addressByUsername, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetTradeResponse> trade($0.QueryGetTradeRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$trade, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryListItemByOwnerResponse> listItemByOwner($0.QueryListItemByOwnerRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listItemByOwner, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetGoogleInAppPurchaseOrderResponse> googleInAppPurchaseOrder($0.QueryGetGoogleInAppPurchaseOrderRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$googleInAppPurchaseOrder, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryListExecutionsByItemResponse> listExecutionsByItem($0.QueryListExecutionsByItemRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listExecutionsByItem, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryListExecutionsByRecipeResponse> listExecutionsByRecipe($0.QueryListExecutionsByRecipeRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listExecutionsByRecipe, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetExecutionResponse> execution($0.QueryGetExecutionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$execution, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryListRecipesByCookbookResponse> listRecipesByCookbook($0.QueryListRecipesByCookbookRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listRecipesByCookbook, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetItemResponse> item($0.QueryGetItemRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$item, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetRecipeResponse> recipe($0.QueryGetRecipeRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$recipe, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryListCookbooksByCreatorResponse> listCookbooksByCreator($0.QueryListCookbooksByCreatorRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listCookbooksByCreator, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryGetCookbookResponse> cookbook($0.QueryGetCookbookRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$cookbook, request, options: options);
  }
}

abstract class QueryServiceBase extends $grpc.Service {
  $core.String get $name => 'Pylonstech.pylons.pylons.Query';

  QueryServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.QueryGetUsernameByAddressRequest, $0.QueryGetUsernameByAddressResponse>('UsernameByAddress', usernameByAddress_Pre, false, false,
        ($core.List<$core.int> value) => $0.QueryGetUsernameByAddressRequest.fromBuffer(value), ($0.QueryGetUsernameByAddressResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryGetAddressByUsernameRequest, $0.QueryGetAddressByUsernameResponse>('AddressByUsername', addressByUsername_Pre, false, false,
        ($core.List<$core.int> value) => $0.QueryGetAddressByUsernameRequest.fromBuffer(value), ($0.QueryGetAddressByUsernameResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryGetTradeRequest, $0.QueryGetTradeResponse>(
        'Trade', trade_Pre, false, false, ($core.List<$core.int> value) => $0.QueryGetTradeRequest.fromBuffer(value), ($0.QueryGetTradeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryListItemByOwnerRequest, $0.QueryListItemByOwnerResponse>('ListItemByOwner', listItemByOwner_Pre, false, false,
        ($core.List<$core.int> value) => $0.QueryListItemByOwnerRequest.fromBuffer(value), ($0.QueryListItemByOwnerResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryGetGoogleInAppPurchaseOrderRequest, $0.QueryGetGoogleInAppPurchaseOrderResponse>('GoogleInAppPurchaseOrder', googleInAppPurchaseOrder_Pre, false, false,
        ($core.List<$core.int> value) => $0.QueryGetGoogleInAppPurchaseOrderRequest.fromBuffer(value), ($0.QueryGetGoogleInAppPurchaseOrderResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryListExecutionsByItemRequest, $0.QueryListExecutionsByItemResponse>('ListExecutionsByItem', listExecutionsByItem_Pre, false, false,
        ($core.List<$core.int> value) => $0.QueryListExecutionsByItemRequest.fromBuffer(value), ($0.QueryListExecutionsByItemResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryListExecutionsByRecipeRequest, $0.QueryListExecutionsByRecipeResponse>('ListExecutionsByRecipe', listExecutionsByRecipe_Pre, false, false,
        ($core.List<$core.int> value) => $0.QueryListExecutionsByRecipeRequest.fromBuffer(value), ($0.QueryListExecutionsByRecipeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryGetExecutionRequest, $0.QueryGetExecutionResponse>(
        'Execution', execution_Pre, false, false, ($core.List<$core.int> value) => $0.QueryGetExecutionRequest.fromBuffer(value), ($0.QueryGetExecutionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryListRecipesByCookbookRequest, $0.QueryListRecipesByCookbookResponse>('ListRecipesByCookbook', listRecipesByCookbook_Pre, false, false,
        ($core.List<$core.int> value) => $0.QueryListRecipesByCookbookRequest.fromBuffer(value), ($0.QueryListRecipesByCookbookResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryGetItemRequest, $0.QueryGetItemResponse>(
        'Item', item_Pre, false, false, ($core.List<$core.int> value) => $0.QueryGetItemRequest.fromBuffer(value), ($0.QueryGetItemResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryGetRecipeRequest, $0.QueryGetRecipeResponse>(
        'Recipe', recipe_Pre, false, false, ($core.List<$core.int> value) => $0.QueryGetRecipeRequest.fromBuffer(value), ($0.QueryGetRecipeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryListCookbooksByCreatorRequest, $0.QueryListCookbooksByCreatorResponse>('ListCookbooksByCreator', listCookbooksByCreator_Pre, false, false,
        ($core.List<$core.int> value) => $0.QueryListCookbooksByCreatorRequest.fromBuffer(value), ($0.QueryListCookbooksByCreatorResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryGetCookbookRequest, $0.QueryGetCookbookResponse>(
        'Cookbook', cookbook_Pre, false, false, ($core.List<$core.int> value) => $0.QueryGetCookbookRequest.fromBuffer(value), ($0.QueryGetCookbookResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.QueryGetUsernameByAddressResponse> usernameByAddress_Pre($grpc.ServiceCall call, $async.Future<$0.QueryGetUsernameByAddressRequest> request) async {
    return usernameByAddress(call, await request);
  }

  $async.Future<$0.QueryGetAddressByUsernameResponse> addressByUsername_Pre($grpc.ServiceCall call, $async.Future<$0.QueryGetAddressByUsernameRequest> request) async {
    return addressByUsername(call, await request);
  }

  $async.Future<$0.QueryGetTradeResponse> trade_Pre($grpc.ServiceCall call, $async.Future<$0.QueryGetTradeRequest> request) async {
    return trade(call, await request);
  }

  $async.Future<$0.QueryListItemByOwnerResponse> listItemByOwner_Pre($grpc.ServiceCall call, $async.Future<$0.QueryListItemByOwnerRequest> request) async {
    return listItemByOwner(call, await request);
  }

  $async.Future<$0.QueryGetGoogleInAppPurchaseOrderResponse> googleInAppPurchaseOrder_Pre($grpc.ServiceCall call, $async.Future<$0.QueryGetGoogleInAppPurchaseOrderRequest> request) async {
    return googleInAppPurchaseOrder(call, await request);
  }

  $async.Future<$0.QueryListExecutionsByItemResponse> listExecutionsByItem_Pre($grpc.ServiceCall call, $async.Future<$0.QueryListExecutionsByItemRequest> request) async {
    return listExecutionsByItem(call, await request);
  }

  $async.Future<$0.QueryListExecutionsByRecipeResponse> listExecutionsByRecipe_Pre($grpc.ServiceCall call, $async.Future<$0.QueryListExecutionsByRecipeRequest> request) async {
    return listExecutionsByRecipe(call, await request);
  }

  $async.Future<$0.QueryGetExecutionResponse> execution_Pre($grpc.ServiceCall call, $async.Future<$0.QueryGetExecutionRequest> request) async {
    return execution(call, await request);
  }

  $async.Future<$0.QueryListRecipesByCookbookResponse> listRecipesByCookbook_Pre($grpc.ServiceCall call, $async.Future<$0.QueryListRecipesByCookbookRequest> request) async {
    return listRecipesByCookbook(call, await request);
  }

  $async.Future<$0.QueryGetItemResponse> item_Pre($grpc.ServiceCall call, $async.Future<$0.QueryGetItemRequest> request) async {
    return item(call, await request);
  }

  $async.Future<$0.QueryGetRecipeResponse> recipe_Pre($grpc.ServiceCall call, $async.Future<$0.QueryGetRecipeRequest> request) async {
    return recipe(call, await request);
  }

  $async.Future<$0.QueryListCookbooksByCreatorResponse> listCookbooksByCreator_Pre($grpc.ServiceCall call, $async.Future<$0.QueryListCookbooksByCreatorRequest> request) async {
    return listCookbooksByCreator(call, await request);
  }

  $async.Future<$0.QueryGetCookbookResponse> cookbook_Pre($grpc.ServiceCall call, $async.Future<$0.QueryGetCookbookRequest> request) async {
    return cookbook(call, await request);
  }

  $async.Future<$0.QueryGetUsernameByAddressResponse> usernameByAddress($grpc.ServiceCall call, $0.QueryGetUsernameByAddressRequest request);
  $async.Future<$0.QueryGetAddressByUsernameResponse> addressByUsername($grpc.ServiceCall call, $0.QueryGetAddressByUsernameRequest request);
  $async.Future<$0.QueryGetTradeResponse> trade($grpc.ServiceCall call, $0.QueryGetTradeRequest request);
  $async.Future<$0.QueryListItemByOwnerResponse> listItemByOwner($grpc.ServiceCall call, $0.QueryListItemByOwnerRequest request);
  $async.Future<$0.QueryGetGoogleInAppPurchaseOrderResponse> googleInAppPurchaseOrder($grpc.ServiceCall call, $0.QueryGetGoogleInAppPurchaseOrderRequest request);
  $async.Future<$0.QueryListExecutionsByItemResponse> listExecutionsByItem($grpc.ServiceCall call, $0.QueryListExecutionsByItemRequest request);
  $async.Future<$0.QueryListExecutionsByRecipeResponse> listExecutionsByRecipe($grpc.ServiceCall call, $0.QueryListExecutionsByRecipeRequest request);
  $async.Future<$0.QueryGetExecutionResponse> execution($grpc.ServiceCall call, $0.QueryGetExecutionRequest request);
  $async.Future<$0.QueryListRecipesByCookbookResponse> listRecipesByCookbook($grpc.ServiceCall call, $0.QueryListRecipesByCookbookRequest request);
  $async.Future<$0.QueryGetItemResponse> item($grpc.ServiceCall call, $0.QueryGetItemRequest request);
  $async.Future<$0.QueryGetRecipeResponse> recipe($grpc.ServiceCall call, $0.QueryGetRecipeRequest request);
  $async.Future<$0.QueryListCookbooksByCreatorResponse> listCookbooksByCreator($grpc.ServiceCall call, $0.QueryListCookbooksByCreatorRequest request);
  $async.Future<$0.QueryGetCookbookResponse> cookbook($grpc.ServiceCall call, $0.QueryGetCookbookRequest request);
}
