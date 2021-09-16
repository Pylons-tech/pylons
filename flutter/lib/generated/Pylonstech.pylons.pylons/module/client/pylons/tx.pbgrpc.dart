///
//  Generated code. Do not modify.
//  source: pylons/tx.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'tx.pb.dart' as $1;
export 'tx.pb.dart';

class MsgClient extends $grpc.Client {
  static final _$updateAccount =
      $grpc.ClientMethod<$1.MsgUpdateAccount, $1.MsgUpdateAccountResponse>(
          '/Pylonstech.pylons.pylons.Msg/UpdateAccount',
          ($1.MsgUpdateAccount value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgUpdateAccountResponse.fromBuffer(value));
  static final _$fulfillTrade =
      $grpc.ClientMethod<$1.MsgFulfillTrade, $1.MsgFulfillTradeResponse>(
          '/Pylonstech.pylons.pylons.Msg/FulfillTrade',
          ($1.MsgFulfillTrade value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgFulfillTradeResponse.fromBuffer(value));
  static final _$createTrade =
      $grpc.ClientMethod<$1.MsgCreateTrade, $1.MsgCreateTradeResponse>(
          '/Pylonstech.pylons.pylons.Msg/CreateTrade',
          ($1.MsgCreateTrade value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgCreateTradeResponse.fromBuffer(value));
  static final _$cancelTrade =
      $grpc.ClientMethod<$1.MsgCancelTrade, $1.MsgCancelTradeResponse>(
          '/Pylonstech.pylons.pylons.Msg/CancelTrade',
          ($1.MsgCancelTrade value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgCancelTradeResponse.fromBuffer(value));
  static final _$completeExecutionEarly = $grpc.ClientMethod<
          $1.MsgCompleteExecutionEarly, $1.MsgCompleteExecutionEarlyResponse>(
      '/Pylonstech.pylons.pylons.Msg/CompleteExecutionEarly',
      ($1.MsgCompleteExecutionEarly value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $1.MsgCompleteExecutionEarlyResponse.fromBuffer(value));
  static final _$transferCookbook = $grpc.ClientMethod<$1.MsgTransferCookbook,
          $1.MsgTransferCookbookResponse>(
      '/Pylonstech.pylons.pylons.Msg/TransferCookbook',
      ($1.MsgTransferCookbook value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $1.MsgTransferCookbookResponse.fromBuffer(value));
  static final _$googleInAppPurchaseGetCoins = $grpc.ClientMethod<
          $1.MsgGoogleInAppPurchaseGetCoins,
          $1.MsgGoogleInAppPurchaseGetCoinsResponse>(
      '/Pylonstech.pylons.pylons.Msg/GoogleInAppPurchaseGetCoins',
      ($1.MsgGoogleInAppPurchaseGetCoins value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $1.MsgGoogleInAppPurchaseGetCoinsResponse.fromBuffer(value));
  static final _$createAccount =
      $grpc.ClientMethod<$1.MsgCreateAccount, $1.MsgCreateAccountResponse>(
          '/Pylonstech.pylons.pylons.Msg/CreateAccount',
          ($1.MsgCreateAccount value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgCreateAccountResponse.fromBuffer(value));
  static final _$sendItems =
      $grpc.ClientMethod<$1.MsgSendItems, $1.MsgSendItemsResponse>(
          '/Pylonstech.pylons.pylons.Msg/SendItems',
          ($1.MsgSendItems value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgSendItemsResponse.fromBuffer(value));
  static final _$executeRecipe =
      $grpc.ClientMethod<$1.MsgExecuteRecipe, $1.MsgExecuteRecipeResponse>(
          '/Pylonstech.pylons.pylons.Msg/ExecuteRecipe',
          ($1.MsgExecuteRecipe value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgExecuteRecipeResponse.fromBuffer(value));
  static final _$setItemString =
      $grpc.ClientMethod<$1.MsgSetItemString, $1.MsgSetItemStringResponse>(
          '/Pylonstech.pylons.pylons.Msg/SetItemString',
          ($1.MsgSetItemString value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgSetItemStringResponse.fromBuffer(value));
  static final _$createRecipe =
      $grpc.ClientMethod<$1.MsgCreateRecipe, $1.MsgCreateRecipeResponse>(
          '/Pylonstech.pylons.pylons.Msg/CreateRecipe',
          ($1.MsgCreateRecipe value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgCreateRecipeResponse.fromBuffer(value));
  static final _$updateRecipe =
      $grpc.ClientMethod<$1.MsgUpdateRecipe, $1.MsgUpdateRecipeResponse>(
          '/Pylonstech.pylons.pylons.Msg/UpdateRecipe',
          ($1.MsgUpdateRecipe value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgUpdateRecipeResponse.fromBuffer(value));
  static final _$createCookbook =
      $grpc.ClientMethod<$1.MsgCreateCookbook, $1.MsgCreateCookbookResponse>(
          '/Pylonstech.pylons.pylons.Msg/CreateCookbook',
          ($1.MsgCreateCookbook value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgCreateCookbookResponse.fromBuffer(value));
  static final _$updateCookbook =
      $grpc.ClientMethod<$1.MsgUpdateCookbook, $1.MsgUpdateCookbookResponse>(
          '/Pylonstech.pylons.pylons.Msg/UpdateCookbook',
          ($1.MsgUpdateCookbook value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgUpdateCookbookResponse.fromBuffer(value));

  MsgClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options,
      $core.Iterable<$grpc.ClientInterceptor> interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$1.MsgUpdateAccountResponse> updateAccount(
      $1.MsgUpdateAccount request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$updateAccount, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgFulfillTradeResponse> fulfillTrade(
      $1.MsgFulfillTrade request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$fulfillTrade, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgCreateTradeResponse> createTrade(
      $1.MsgCreateTrade request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$createTrade, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgCancelTradeResponse> cancelTrade(
      $1.MsgCancelTrade request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$cancelTrade, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgCompleteExecutionEarlyResponse>
      completeExecutionEarly($1.MsgCompleteExecutionEarly request,
          {$grpc.CallOptions options}) {
    return $createUnaryCall(_$completeExecutionEarly, request,
        options: options);
  }

  $grpc.ResponseFuture<$1.MsgTransferCookbookResponse> transferCookbook(
      $1.MsgTransferCookbook request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$transferCookbook, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgGoogleInAppPurchaseGetCoinsResponse>
      googleInAppPurchaseGetCoins($1.MsgGoogleInAppPurchaseGetCoins request,
          {$grpc.CallOptions options}) {
    return $createUnaryCall(_$googleInAppPurchaseGetCoins, request,
        options: options);
  }

  $grpc.ResponseFuture<$1.MsgCreateAccountResponse> createAccount(
      $1.MsgCreateAccount request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$createAccount, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgSendItemsResponse> sendItems(
      $1.MsgSendItems request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$sendItems, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgExecuteRecipeResponse> executeRecipe(
      $1.MsgExecuteRecipe request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$executeRecipe, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgSetItemStringResponse> setItemString(
      $1.MsgSetItemString request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$setItemString, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgCreateRecipeResponse> createRecipe(
      $1.MsgCreateRecipe request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$createRecipe, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgUpdateRecipeResponse> updateRecipe(
      $1.MsgUpdateRecipe request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$updateRecipe, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgCreateCookbookResponse> createCookbook(
      $1.MsgCreateCookbook request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$createCookbook, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgUpdateCookbookResponse> updateCookbook(
      $1.MsgUpdateCookbook request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$updateCookbook, request, options: options);
  }
}

abstract class MsgServiceBase extends $grpc.Service {
  $core.String get $name => 'Pylonstech.pylons.pylons.Msg';

  MsgServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$1.MsgUpdateAccount, $1.MsgUpdateAccountResponse>(
            'UpdateAccount',
            updateAccount_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgUpdateAccount.fromBuffer(value),
            ($1.MsgUpdateAccountResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.MsgFulfillTrade, $1.MsgFulfillTradeResponse>(
            'FulfillTrade',
            fulfillTrade_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgFulfillTrade.fromBuffer(value),
            ($1.MsgFulfillTradeResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.MsgCreateTrade, $1.MsgCreateTradeResponse>(
            'CreateTrade',
            createTrade_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgCreateTrade.fromBuffer(value),
            ($1.MsgCreateTradeResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.MsgCancelTrade, $1.MsgCancelTradeResponse>(
            'CancelTrade',
            cancelTrade_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgCancelTrade.fromBuffer(value),
            ($1.MsgCancelTradeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.MsgCompleteExecutionEarly,
            $1.MsgCompleteExecutionEarlyResponse>(
        'CompleteExecutionEarly',
        completeExecutionEarly_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.MsgCompleteExecutionEarly.fromBuffer(value),
        ($1.MsgCompleteExecutionEarlyResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.MsgTransferCookbook,
            $1.MsgTransferCookbookResponse>(
        'TransferCookbook',
        transferCookbook_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.MsgTransferCookbook.fromBuffer(value),
        ($1.MsgTransferCookbookResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.MsgGoogleInAppPurchaseGetCoins,
            $1.MsgGoogleInAppPurchaseGetCoinsResponse>(
        'GoogleInAppPurchaseGetCoins',
        googleInAppPurchaseGetCoins_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.MsgGoogleInAppPurchaseGetCoins.fromBuffer(value),
        ($1.MsgGoogleInAppPurchaseGetCoinsResponse value) =>
            value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.MsgCreateAccount, $1.MsgCreateAccountResponse>(
            'CreateAccount',
            createAccount_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgCreateAccount.fromBuffer(value),
            ($1.MsgCreateAccountResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.MsgSendItems, $1.MsgSendItemsResponse>(
        'SendItems',
        sendItems_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.MsgSendItems.fromBuffer(value),
        ($1.MsgSendItemsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.MsgExecuteRecipe, $1.MsgExecuteRecipeResponse>(
            'ExecuteRecipe',
            executeRecipe_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgExecuteRecipe.fromBuffer(value),
            ($1.MsgExecuteRecipeResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.MsgSetItemString, $1.MsgSetItemStringResponse>(
            'SetItemString',
            setItemString_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgSetItemString.fromBuffer(value),
            ($1.MsgSetItemStringResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.MsgCreateRecipe, $1.MsgCreateRecipeResponse>(
            'CreateRecipe',
            createRecipe_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgCreateRecipe.fromBuffer(value),
            ($1.MsgCreateRecipeResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.MsgUpdateRecipe, $1.MsgUpdateRecipeResponse>(
            'UpdateRecipe',
            updateRecipe_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgUpdateRecipe.fromBuffer(value),
            ($1.MsgUpdateRecipeResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.MsgCreateCookbook, $1.MsgCreateCookbookResponse>(
            'CreateCookbook',
            createCookbook_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgCreateCookbook.fromBuffer(value),
            ($1.MsgCreateCookbookResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.MsgUpdateCookbook, $1.MsgUpdateCookbookResponse>(
            'UpdateCookbook',
            updateCookbook_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgUpdateCookbook.fromBuffer(value),
            ($1.MsgUpdateCookbookResponse value) => value.writeToBuffer()));
  }

  $async.Future<$1.MsgUpdateAccountResponse> updateAccount_Pre(
      $grpc.ServiceCall call,
      $async.Future<$1.MsgUpdateAccount> request) async {
    return updateAccount(call, await request);
  }

  $async.Future<$1.MsgFulfillTradeResponse> fulfillTrade_Pre(
      $grpc.ServiceCall call, $async.Future<$1.MsgFulfillTrade> request) async {
    return fulfillTrade(call, await request);
  }

  $async.Future<$1.MsgCreateTradeResponse> createTrade_Pre(
      $grpc.ServiceCall call, $async.Future<$1.MsgCreateTrade> request) async {
    return createTrade(call, await request);
  }

  $async.Future<$1.MsgCancelTradeResponse> cancelTrade_Pre(
      $grpc.ServiceCall call, $async.Future<$1.MsgCancelTrade> request) async {
    return cancelTrade(call, await request);
  }

  $async.Future<$1.MsgCompleteExecutionEarlyResponse>
      completeExecutionEarly_Pre($grpc.ServiceCall call,
          $async.Future<$1.MsgCompleteExecutionEarly> request) async {
    return completeExecutionEarly(call, await request);
  }

  $async.Future<$1.MsgTransferCookbookResponse> transferCookbook_Pre(
      $grpc.ServiceCall call,
      $async.Future<$1.MsgTransferCookbook> request) async {
    return transferCookbook(call, await request);
  }

  $async.Future<$1.MsgGoogleInAppPurchaseGetCoinsResponse>
      googleInAppPurchaseGetCoins_Pre($grpc.ServiceCall call,
          $async.Future<$1.MsgGoogleInAppPurchaseGetCoins> request) async {
    return googleInAppPurchaseGetCoins(call, await request);
  }

  $async.Future<$1.MsgCreateAccountResponse> createAccount_Pre(
      $grpc.ServiceCall call,
      $async.Future<$1.MsgCreateAccount> request) async {
    return createAccount(call, await request);
  }

  $async.Future<$1.MsgSendItemsResponse> sendItems_Pre(
      $grpc.ServiceCall call, $async.Future<$1.MsgSendItems> request) async {
    return sendItems(call, await request);
  }

  $async.Future<$1.MsgExecuteRecipeResponse> executeRecipe_Pre(
      $grpc.ServiceCall call,
      $async.Future<$1.MsgExecuteRecipe> request) async {
    return executeRecipe(call, await request);
  }

  $async.Future<$1.MsgSetItemStringResponse> setItemString_Pre(
      $grpc.ServiceCall call,
      $async.Future<$1.MsgSetItemString> request) async {
    return setItemString(call, await request);
  }

  $async.Future<$1.MsgCreateRecipeResponse> createRecipe_Pre(
      $grpc.ServiceCall call, $async.Future<$1.MsgCreateRecipe> request) async {
    return createRecipe(call, await request);
  }

  $async.Future<$1.MsgUpdateRecipeResponse> updateRecipe_Pre(
      $grpc.ServiceCall call, $async.Future<$1.MsgUpdateRecipe> request) async {
    return updateRecipe(call, await request);
  }

  $async.Future<$1.MsgCreateCookbookResponse> createCookbook_Pre(
      $grpc.ServiceCall call,
      $async.Future<$1.MsgCreateCookbook> request) async {
    return createCookbook(call, await request);
  }

  $async.Future<$1.MsgUpdateCookbookResponse> updateCookbook_Pre(
      $grpc.ServiceCall call,
      $async.Future<$1.MsgUpdateCookbook> request) async {
    return updateCookbook(call, await request);
  }

  $async.Future<$1.MsgUpdateAccountResponse> updateAccount(
      $grpc.ServiceCall call, $1.MsgUpdateAccount request);
  $async.Future<$1.MsgFulfillTradeResponse> fulfillTrade(
      $grpc.ServiceCall call, $1.MsgFulfillTrade request);
  $async.Future<$1.MsgCreateTradeResponse> createTrade(
      $grpc.ServiceCall call, $1.MsgCreateTrade request);
  $async.Future<$1.MsgCancelTradeResponse> cancelTrade(
      $grpc.ServiceCall call, $1.MsgCancelTrade request);
  $async.Future<$1.MsgCompleteExecutionEarlyResponse> completeExecutionEarly(
      $grpc.ServiceCall call, $1.MsgCompleteExecutionEarly request);
  $async.Future<$1.MsgTransferCookbookResponse> transferCookbook(
      $grpc.ServiceCall call, $1.MsgTransferCookbook request);
  $async.Future<$1.MsgGoogleInAppPurchaseGetCoinsResponse>
      googleInAppPurchaseGetCoins(
          $grpc.ServiceCall call, $1.MsgGoogleInAppPurchaseGetCoins request);
  $async.Future<$1.MsgCreateAccountResponse> createAccount(
      $grpc.ServiceCall call, $1.MsgCreateAccount request);
  $async.Future<$1.MsgSendItemsResponse> sendItems(
      $grpc.ServiceCall call, $1.MsgSendItems request);
  $async.Future<$1.MsgExecuteRecipeResponse> executeRecipe(
      $grpc.ServiceCall call, $1.MsgExecuteRecipe request);
  $async.Future<$1.MsgSetItemStringResponse> setItemString(
      $grpc.ServiceCall call, $1.MsgSetItemString request);
  $async.Future<$1.MsgCreateRecipeResponse> createRecipe(
      $grpc.ServiceCall call, $1.MsgCreateRecipe request);
  $async.Future<$1.MsgUpdateRecipeResponse> updateRecipe(
      $grpc.ServiceCall call, $1.MsgUpdateRecipe request);
  $async.Future<$1.MsgCreateCookbookResponse> createCookbook(
      $grpc.ServiceCall call, $1.MsgCreateCookbook request);
  $async.Future<$1.MsgUpdateCookbookResponse> updateCookbook(
      $grpc.ServiceCall call, $1.MsgUpdateCookbook request);
}
