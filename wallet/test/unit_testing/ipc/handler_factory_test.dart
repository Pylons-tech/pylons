import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/handler/handlers/create_cookbook_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/create_recipe_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/execute_recipe_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_cookbook_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_execution_by_id_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_execution_by_recipe_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_item_by_id_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_list_by_owner_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_recipe_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_recipes_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_trades_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/update_cookbook_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/update_recipe_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';

void main() {
  test('should return CreateCookBookHandler on TX_CREATE_COOKBOOK action', () {
    final handler = HandlerFactory().getHandler(SdkIpcMessage(
        json: '',
        action: HandlerFactory.TX_CREATE_COOKBOOK,
        sender: '',
        requestResponse: true));
    expect(true, handler is CreateCookbookHandler);
  });

  test('should return CreateRecipeHandler on TX_CREATE_RECIPE action', () {
    final handler = HandlerFactory().getHandler(SdkIpcMessage(
        json: '',
        action: HandlerFactory.TX_CREATE_RECIPE,
        sender: '',
        requestResponse: true));
    expect(true, handler is CreateRecipeHandler);
  });

  test('should return UpdateRecipeHandler on TX_UPDATE_RECIPE action', () {
    final handler = HandlerFactory().getHandler(SdkIpcMessage(
        json: '',
        action: HandlerFactory.TX_UPDATE_RECIPE,
        sender: '',
        requestResponse: true));
    expect(true, handler is UpdateRecipeHandler);
  });

  test('should return ExecuteRecipeHandler on TX_EXECUTE_RECIPE action', () {
    final handler = HandlerFactory().getHandler(SdkIpcMessage(
        json: '',
        action: HandlerFactory.TX_EXECUTE_RECIPE,
        sender: '',
        requestResponse: true));
    expect(true, handler is ExecuteRecipeHandler);
  });

  test('should return GetRecipesHandler on GET_RECIPES action', () {
    final handler = HandlerFactory().getHandler(SdkIpcMessage(
        json: '',
        action: HandlerFactory.GET_RECIPES,
        sender: '',
        requestResponse: true));
    expect(true, handler is GetRecipesHandler);
  });

  test('should return UpdateCookBookHandler on TX_UPDATE_COOKBOOK action', () {
    final handler = HandlerFactory().getHandler(SdkIpcMessage(
        json: '',
        action: HandlerFactory.TX_UPDATE_COOKBOOK,
        sender: '',
        requestResponse: true));
    expect(true, handler is UpdateCookbookHandler);
  });

  test('should return GetCookbookHandler on GetCookBook action', () {
    final handler = HandlerFactory().getHandler(SdkIpcMessage(
        json: '',
        action: HandlerFactory.GET_COOKBOOK,
        sender: '',
        requestResponse: true));
    expect(true, handler is GetCookbookHandler);
  });

  test('should return GetRecipeHandler on GetRecipe action', () {
    final handler = HandlerFactory().getHandler(SdkIpcMessage(
        json: '',
        action: HandlerFactory.GET_RECIPE,
        sender: '',
        requestResponse: true));
    expect(true, handler is GetRecipeHandler);
  });

  test(
      'should return GetExecutionByRecipe on GET_EXECUTION_BY_RECIPE_ID action',
      () {
    final handler = HandlerFactory().getHandler(SdkIpcMessage(
        json: '',
        action: HandlerFactory.GET_EXECUTION_BY_RECIPE_ID,
        sender: '',
        requestResponse: true));
    expect(true, handler is GetExecutionByRecipe);
  });

  test('should return GetItemByIdHandler on GET_ITEM_BY_ID action', () {
    final handler = HandlerFactory().getHandler(SdkIpcMessage(
        json: '',
        action: HandlerFactory.GET_ITEM_BY_ID,
        sender: '',
        requestResponse: true));
    expect(true, handler is GetItemByIdHandler);
  });

  test('should return GetListByOwnerHandler on GET_ITEM_BY_ID action', () {
    final handler = HandlerFactory().getHandler(SdkIpcMessage(
        json: '',
        action: HandlerFactory.GET_ITEMS_BY_OWNER,
        sender: '',
        requestResponse: true));
    expect(true, handler is GetItemsByOwnerHandler);
  });

  test('should return Execution based on GET_EXECUTION_BY_ID action', () {
    final handler = HandlerFactory().getHandler(SdkIpcMessage(
        json: '',
        action: HandlerFactory.GET_EXECUTION_BY_ID,
        sender: '',
        requestResponse: true));
    expect(true, handler is GetExecutionByIdHandler);
  });

  test('should return GetTradesHandler based on GET_TRADES action', () {
    final handler = HandlerFactory().getHandler(SdkIpcMessage(
        json: '',
        action: HandlerFactory.GET_TRADES,
        sender: '',
        requestResponse: true));
    expect(true, handler is GetTradesHandler);
  });
}
