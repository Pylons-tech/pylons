///
//  Generated code. Do not modify.
//  source: pylons/tx.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:pylons_wallet/modules/pylons/module/client/pylons/tx.pb.dart' as $1;
export 'tx.pb.dart';

class MsgClient extends $grpc.Client {
  static final _$createAccount =
      $grpc.ClientMethod<$1.MsgCreateAccount, $1.MsgCreateExecutionResponse>(
          '/pylons.Msg/CreateAccount',
          ($1.MsgCreateAccount value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgCreateExecutionResponse.fromBuffer(value));
  static final _$getPylons =
      $grpc.ClientMethod<$1.MsgGetPylons, $1.MsgGetPylonsResponse>(
          '/pylons.Msg/GetPylons',
          ($1.MsgGetPylons value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgGetPylonsResponse.fromBuffer(value));
  static final _$googleIAPGetPylons = $grpc.ClientMethod<
          $1.MsgGoogleIAPGetPylons, $1.MsgGoogleIAPGetPylonsResponse>(
      '/pylons.Msg/GoogleIAPGetPylons',
      ($1.MsgGoogleIAPGetPylons value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $1.MsgGoogleIAPGetPylonsResponse.fromBuffer(value));
  static final _$sendCoins =
      $grpc.ClientMethod<$1.MsgSendCoins, $1.MsgSendCoinsResponse>(
          '/pylons.Msg/SendCoins',
          ($1.MsgSendCoins value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgSendCoinsResponse.fromBuffer(value));
  static final _$sendItems =
      $grpc.ClientMethod<$1.MsgSendItems, $1.MsgSendItemsResponse>(
          '/pylons.Msg/SendItems',
          ($1.MsgSendItems value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgSendItemsResponse.fromBuffer(value));
  static final _$createCookbook =
      $grpc.ClientMethod<$1.MsgCreateCookbook, $1.MsgCreateCookbookResponse>(
          '/pylons.Msg/CreateCookbook',
          ($1.MsgCreateCookbook value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgCreateCookbookResponse.fromBuffer(value));
  static final _$handlerMsgUpdateCookbook =
      $grpc.ClientMethod<$1.MsgUpdateCookbook, $1.MsgUpdateCookbookResponse>(
          '/pylons.Msg/HandlerMsgUpdateCookbook',
          ($1.MsgUpdateCookbook value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgUpdateCookbookResponse.fromBuffer(value));
  static final _$createRecipe =
      $grpc.ClientMethod<$1.MsgCreateRecipe, $1.MsgCreateRecipeResponse>(
          '/pylons.Msg/CreateRecipe',
          ($1.MsgCreateRecipe value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgCreateRecipeResponse.fromBuffer(value));
  static final _$handlerMsgUpdateRecipe =
      $grpc.ClientMethod<$1.MsgUpdateRecipe, $1.MsgUpdateRecipeResponse>(
          '/pylons.Msg/HandlerMsgUpdateRecipe',
          ($1.MsgUpdateRecipe value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgUpdateRecipeResponse.fromBuffer(value));
  static final _$executeRecipe =
      $grpc.ClientMethod<$1.MsgExecuteRecipe, $1.MsgExecuteRecipeResponse>(
          '/pylons.Msg/ExecuteRecipe',
          ($1.MsgExecuteRecipe value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgExecuteRecipeResponse.fromBuffer(value));
  static final _$disableRecipe =
      $grpc.ClientMethod<$1.MsgDisableRecipe, $1.MsgDisableRecipeResponse>(
          '/pylons.Msg/DisableRecipe',
          ($1.MsgDisableRecipe value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgDisableRecipeResponse.fromBuffer(value));
  static final _$enableRecipe =
      $grpc.ClientMethod<$1.MsgEnableRecipe, $1.MsgEnableRecipeResponse>(
          '/pylons.Msg/EnableRecipe',
          ($1.MsgEnableRecipe value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgEnableRecipeResponse.fromBuffer(value));
  static final _$checkExecution =
      $grpc.ClientMethod<$1.MsgCheckExecution, $1.MsgCheckExecutionResponse>(
          '/pylons.Msg/CheckExecution',
          ($1.MsgCheckExecution value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgCheckExecutionResponse.fromBuffer(value));
  static final _$fiatItem =
      $grpc.ClientMethod<$1.MsgFiatItem, $1.MsgFiatItemResponse>(
          '/pylons.Msg/FiatItem',
          ($1.MsgFiatItem value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgFiatItemResponse.fromBuffer(value));
  static final _$updateItemString = $grpc.ClientMethod<$1.MsgUpdateItemString,
          $1.MsgUpdateItemStringResponse>(
      '/pylons.Msg/UpdateItemString',
      ($1.MsgUpdateItemString value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $1.MsgUpdateItemStringResponse.fromBuffer(value));
  static final _$createTrade =
      $grpc.ClientMethod<$1.MsgCreateTrade, $1.MsgCreateTradeResponse>(
          '/pylons.Msg/CreateTrade',
          ($1.MsgCreateTrade value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgCreateTradeResponse.fromBuffer(value));
  static final _$fulfillTrade =
      $grpc.ClientMethod<$1.MsgFulfillTrade, $1.MsgFulfillTradeResponse>(
          '/pylons.Msg/FulfillTrade',
          ($1.MsgFulfillTrade value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgFulfillTradeResponse.fromBuffer(value));
  static final _$disableTrade =
      $grpc.ClientMethod<$1.MsgDisableTrade, $1.MsgDisableTradeResponse>(
          '/pylons.Msg/DisableTrade',
          ($1.MsgDisableTrade value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgDisableTradeResponse.fromBuffer(value));
  static final _$enableTrade =
      $grpc.ClientMethod<$1.MsgEnableTrade, $1.MsgEnableTradeResponse>(
          '/pylons.Msg/EnableTrade',
          ($1.MsgEnableTrade value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.MsgEnableTradeResponse.fromBuffer(value));

  MsgClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options,
      $core.Iterable<$grpc.ClientInterceptor> interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$1.MsgCreateExecutionResponse> createAccount(
      $1.MsgCreateAccount request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$createAccount, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgGetPylonsResponse> getPylons(
      $1.MsgGetPylons request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$getPylons, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgGoogleIAPGetPylonsResponse> googleIAPGetPylons(
      $1.MsgGoogleIAPGetPylons request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$googleIAPGetPylons, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgSendCoinsResponse> sendCoins(
      $1.MsgSendCoins request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$sendCoins, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgSendItemsResponse> sendItems(
      $1.MsgSendItems request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$sendItems, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgCreateCookbookResponse> createCookbook(
      $1.MsgCreateCookbook request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$createCookbook, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgUpdateCookbookResponse> handlerMsgUpdateCookbook(
      $1.MsgUpdateCookbook request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$handlerMsgUpdateCookbook, request,
        options: options);
  }

  $grpc.ResponseFuture<$1.MsgCreateRecipeResponse> createRecipe(
      $1.MsgCreateRecipe request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$createRecipe, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgUpdateRecipeResponse> handlerMsgUpdateRecipe(
      $1.MsgUpdateRecipe request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$handlerMsgUpdateRecipe, request,
        options: options);
  }

  $grpc.ResponseFuture<$1.MsgExecuteRecipeResponse> executeRecipe(
      $1.MsgExecuteRecipe request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$executeRecipe, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgDisableRecipeResponse> disableRecipe(
      $1.MsgDisableRecipe request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$disableRecipe, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgEnableRecipeResponse> enableRecipe(
      $1.MsgEnableRecipe request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$enableRecipe, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgCheckExecutionResponse> checkExecution(
      $1.MsgCheckExecution request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$checkExecution, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgFiatItemResponse> fiatItem($1.MsgFiatItem request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$fiatItem, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgUpdateItemStringResponse> updateItemString(
      $1.MsgUpdateItemString request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$updateItemString, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgCreateTradeResponse> createTrade(
      $1.MsgCreateTrade request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$createTrade, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgFulfillTradeResponse> fulfillTrade(
      $1.MsgFulfillTrade request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$fulfillTrade, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgDisableTradeResponse> disableTrade(
      $1.MsgDisableTrade request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$disableTrade, request, options: options);
  }

  $grpc.ResponseFuture<$1.MsgEnableTradeResponse> enableTrade(
      $1.MsgEnableTrade request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$enableTrade, request, options: options);
  }
}

abstract class MsgServiceBase extends $grpc.Service {
  $core.String get $name => 'pylons.Msg';

  MsgServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$1.MsgCreateAccount, $1.MsgCreateExecutionResponse>(
            'CreateAccount',
            createAccount_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgCreateAccount.fromBuffer(value),
            ($1.MsgCreateExecutionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.MsgGetPylons, $1.MsgGetPylonsResponse>(
        'GetPylons',
        getPylons_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.MsgGetPylons.fromBuffer(value),
        ($1.MsgGetPylonsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.MsgGoogleIAPGetPylons,
            $1.MsgGoogleIAPGetPylonsResponse>(
        'GoogleIAPGetPylons',
        googleIAPGetPylons_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.MsgGoogleIAPGetPylons.fromBuffer(value),
        ($1.MsgGoogleIAPGetPylonsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.MsgSendCoins, $1.MsgSendCoinsResponse>(
        'SendCoins',
        sendCoins_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.MsgSendCoins.fromBuffer(value),
        ($1.MsgSendCoinsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.MsgSendItems, $1.MsgSendItemsResponse>(
        'SendItems',
        sendItems_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.MsgSendItems.fromBuffer(value),
        ($1.MsgSendItemsResponse value) => value.writeToBuffer()));
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
            'HandlerMsgUpdateCookbook',
            handlerMsgUpdateCookbook_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgUpdateCookbook.fromBuffer(value),
            ($1.MsgUpdateCookbookResponse value) => value.writeToBuffer()));
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
            'HandlerMsgUpdateRecipe',
            handlerMsgUpdateRecipe_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgUpdateRecipe.fromBuffer(value),
            ($1.MsgUpdateRecipeResponse value) => value.writeToBuffer()));
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
        $grpc.ServiceMethod<$1.MsgDisableRecipe, $1.MsgDisableRecipeResponse>(
            'DisableRecipe',
            disableRecipe_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgDisableRecipe.fromBuffer(value),
            ($1.MsgDisableRecipeResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.MsgEnableRecipe, $1.MsgEnableRecipeResponse>(
            'EnableRecipe',
            enableRecipe_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgEnableRecipe.fromBuffer(value),
            ($1.MsgEnableRecipeResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.MsgCheckExecution, $1.MsgCheckExecutionResponse>(
            'CheckExecution',
            checkExecution_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgCheckExecution.fromBuffer(value),
            ($1.MsgCheckExecutionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.MsgFiatItem, $1.MsgFiatItemResponse>(
        'FiatItem',
        fiatItem_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.MsgFiatItem.fromBuffer(value),
        ($1.MsgFiatItemResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.MsgUpdateItemString,
            $1.MsgUpdateItemStringResponse>(
        'UpdateItemString',
        updateItemString_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.MsgUpdateItemString.fromBuffer(value),
        ($1.MsgUpdateItemStringResponse value) => value.writeToBuffer()));
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
        $grpc.ServiceMethod<$1.MsgFulfillTrade, $1.MsgFulfillTradeResponse>(
            'FulfillTrade',
            fulfillTrade_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgFulfillTrade.fromBuffer(value),
            ($1.MsgFulfillTradeResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.MsgDisableTrade, $1.MsgDisableTradeResponse>(
            'DisableTrade',
            disableTrade_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgDisableTrade.fromBuffer(value),
            ($1.MsgDisableTradeResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.MsgEnableTrade, $1.MsgEnableTradeResponse>(
            'EnableTrade',
            enableTrade_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.MsgEnableTrade.fromBuffer(value),
            ($1.MsgEnableTradeResponse value) => value.writeToBuffer()));
  }

  $async.Future<$1.MsgCreateExecutionResponse> createAccount_Pre(
      $grpc.ServiceCall call,
      $async.Future<$1.MsgCreateAccount> request) async {
    return createAccount(call, await request);
  }

  $async.Future<$1.MsgGetPylonsResponse> getPylons_Pre(
      $grpc.ServiceCall call, $async.Future<$1.MsgGetPylons> request) async {
    return getPylons(call, await request);
  }

  $async.Future<$1.MsgGoogleIAPGetPylonsResponse> googleIAPGetPylons_Pre(
      $grpc.ServiceCall call,
      $async.Future<$1.MsgGoogleIAPGetPylons> request) async {
    return googleIAPGetPylons(call, await request);
  }

  $async.Future<$1.MsgSendCoinsResponse> sendCoins_Pre(
      $grpc.ServiceCall call, $async.Future<$1.MsgSendCoins> request) async {
    return sendCoins(call, await request);
  }

  $async.Future<$1.MsgSendItemsResponse> sendItems_Pre(
      $grpc.ServiceCall call, $async.Future<$1.MsgSendItems> request) async {
    return sendItems(call, await request);
  }

  $async.Future<$1.MsgCreateCookbookResponse> createCookbook_Pre(
      $grpc.ServiceCall call,
      $async.Future<$1.MsgCreateCookbook> request) async {
    return createCookbook(call, await request);
  }

  $async.Future<$1.MsgUpdateCookbookResponse> handlerMsgUpdateCookbook_Pre(
      $grpc.ServiceCall call,
      $async.Future<$1.MsgUpdateCookbook> request) async {
    return handlerMsgUpdateCookbook(call, await request);
  }

  $async.Future<$1.MsgCreateRecipeResponse> createRecipe_Pre(
      $grpc.ServiceCall call, $async.Future<$1.MsgCreateRecipe> request) async {
    return createRecipe(call, await request);
  }

  $async.Future<$1.MsgUpdateRecipeResponse> handlerMsgUpdateRecipe_Pre(
      $grpc.ServiceCall call, $async.Future<$1.MsgUpdateRecipe> request) async {
    return handlerMsgUpdateRecipe(call, await request);
  }

  $async.Future<$1.MsgExecuteRecipeResponse> executeRecipe_Pre(
      $grpc.ServiceCall call,
      $async.Future<$1.MsgExecuteRecipe> request) async {
    return executeRecipe(call, await request);
  }

  $async.Future<$1.MsgDisableRecipeResponse> disableRecipe_Pre(
      $grpc.ServiceCall call,
      $async.Future<$1.MsgDisableRecipe> request) async {
    return disableRecipe(call, await request);
  }

  $async.Future<$1.MsgEnableRecipeResponse> enableRecipe_Pre(
      $grpc.ServiceCall call, $async.Future<$1.MsgEnableRecipe> request) async {
    return enableRecipe(call, await request);
  }

  $async.Future<$1.MsgCheckExecutionResponse> checkExecution_Pre(
      $grpc.ServiceCall call,
      $async.Future<$1.MsgCheckExecution> request) async {
    return checkExecution(call, await request);
  }

  $async.Future<$1.MsgFiatItemResponse> fiatItem_Pre(
      $grpc.ServiceCall call, $async.Future<$1.MsgFiatItem> request) async {
    return fiatItem(call, await request);
  }

  $async.Future<$1.MsgUpdateItemStringResponse> updateItemString_Pre(
      $grpc.ServiceCall call,
      $async.Future<$1.MsgUpdateItemString> request) async {
    return updateItemString(call, await request);
  }

  $async.Future<$1.MsgCreateTradeResponse> createTrade_Pre(
      $grpc.ServiceCall call, $async.Future<$1.MsgCreateTrade> request) async {
    return createTrade(call, await request);
  }

  $async.Future<$1.MsgFulfillTradeResponse> fulfillTrade_Pre(
      $grpc.ServiceCall call, $async.Future<$1.MsgFulfillTrade> request) async {
    return fulfillTrade(call, await request);
  }

  $async.Future<$1.MsgDisableTradeResponse> disableTrade_Pre(
      $grpc.ServiceCall call, $async.Future<$1.MsgDisableTrade> request) async {
    return disableTrade(call, await request);
  }

  $async.Future<$1.MsgEnableTradeResponse> enableTrade_Pre(
      $grpc.ServiceCall call, $async.Future<$1.MsgEnableTrade> request) async {
    return enableTrade(call, await request);
  }

  $async.Future<$1.MsgCreateExecutionResponse> createAccount(
      $grpc.ServiceCall call, $1.MsgCreateAccount request);
  $async.Future<$1.MsgGetPylonsResponse> getPylons(
      $grpc.ServiceCall call, $1.MsgGetPylons request);
  $async.Future<$1.MsgGoogleIAPGetPylonsResponse> googleIAPGetPylons(
      $grpc.ServiceCall call, $1.MsgGoogleIAPGetPylons request);
  $async.Future<$1.MsgSendCoinsResponse> sendCoins(
      $grpc.ServiceCall call, $1.MsgSendCoins request);
  $async.Future<$1.MsgSendItemsResponse> sendItems(
      $grpc.ServiceCall call, $1.MsgSendItems request);
  $async.Future<$1.MsgCreateCookbookResponse> createCookbook(
      $grpc.ServiceCall call, $1.MsgCreateCookbook request);
  $async.Future<$1.MsgUpdateCookbookResponse> handlerMsgUpdateCookbook(
      $grpc.ServiceCall call, $1.MsgUpdateCookbook request);
  $async.Future<$1.MsgCreateRecipeResponse> createRecipe(
      $grpc.ServiceCall call, $1.MsgCreateRecipe request);
  $async.Future<$1.MsgUpdateRecipeResponse> handlerMsgUpdateRecipe(
      $grpc.ServiceCall call, $1.MsgUpdateRecipe request);
  $async.Future<$1.MsgExecuteRecipeResponse> executeRecipe(
      $grpc.ServiceCall call, $1.MsgExecuteRecipe request);
  $async.Future<$1.MsgDisableRecipeResponse> disableRecipe(
      $grpc.ServiceCall call, $1.MsgDisableRecipe request);
  $async.Future<$1.MsgEnableRecipeResponse> enableRecipe(
      $grpc.ServiceCall call, $1.MsgEnableRecipe request);
  $async.Future<$1.MsgCheckExecutionResponse> checkExecution(
      $grpc.ServiceCall call, $1.MsgCheckExecution request);
  $async.Future<$1.MsgFiatItemResponse> fiatItem(
      $grpc.ServiceCall call, $1.MsgFiatItem request);
  $async.Future<$1.MsgUpdateItemStringResponse> updateItemString(
      $grpc.ServiceCall call, $1.MsgUpdateItemString request);
  $async.Future<$1.MsgCreateTradeResponse> createTrade(
      $grpc.ServiceCall call, $1.MsgCreateTrade request);
  $async.Future<$1.MsgFulfillTradeResponse> fulfillTrade(
      $grpc.ServiceCall call, $1.MsgFulfillTrade request);
  $async.Future<$1.MsgDisableTradeResponse> disableTrade(
      $grpc.ServiceCall call, $1.MsgDisableTrade request);
  $async.Future<$1.MsgEnableTradeResponse> enableTrade(
      $grpc.ServiceCall call, $1.MsgEnableTrade request);
}
