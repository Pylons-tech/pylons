/// Types and functionality for interacting with the Pylons wallet.
///
/// The APIs exposed by this library, specifically, are the main way most
/// client apps should structure their interactions with the wallet.

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:pylons_sdk/src/generated/pylons/execution.pb.dart';
import '../pylons_sdk.dart';
import 'features/models/execution_list_by_recipe_response.dart';
import 'features/models/sdk_ipc_message.dart';
import 'generated/pylons/payment_info.pb.dart';
import 'features/models/sdk_ipc_response.dart';
import 'pylons_wallet/pylons_wallet_impl.dart';
import 'package:uni_links_platform_interface/uni_links_platform_interface.dart';

enum PylonsMode { dev, prod }

/// The PylonsWallet class is the main endpoint developers use for structured,
/// high-level interactions with the Pylons wallet.
abstract class PylonsWallet {
  static PylonsWallet? _instance;

  static PylonsWallet get instance {
    if (_instance == null) {
      throw WalletInitializationNotDone('Sdk not initialized');
    }

    return _instance!;
  }

  /// Initializes the wallet model.
  ///
  /// [mode] identifies which chain will be used - [PylonsMode.prod] will run on mainnet; [PylonsMode.dev] will run on testnet.
  ///
  /// [host] is the host to be used in an Android manifest and/or XCode setup, and is required for getting a respponse
  /// from the wallet.
  ///
  /// Throws [WalletInitializationAlreadyDoneException] if called while already initialized.
  static void setup({required PylonsMode mode, required String host}) {
    if (_instance != null) {
      throw WalletInitializationAlreadyDoneException(
          'Wallet is already initialized');
    }

    // At present, production/dev mode makes *no* difference as far as this SDK is concerned.
    // The wallet will use different values for its node URLs and chain ID, but that's already
    // set per-wallet-app, and is not in our control. If, in future, any meaningful changes in
    // functionality need to take place based on production mode, the switch statement below
    // should be uncommented and used for that. Note, though, that the most likely case -
    // wallets which can switch chains based on the expectations of client software -
    // _still_ wouldn't require any deeper logic from us here. We'd just want to pass our prod/dev
    // mode flag to the wallet.

    // TODO: There should be a way to inquire as to which network a (single-net) wallet uses.
    // Once that exists, the switch statement below should be uncommented, and we should crash if
    // the wallet is something different from what we're expecting.

    // switch (mode) {
    //   case PylonsMode.prod:
    //     break;
    //   case PylonsMode.dev:
    //     break;
    // }

    _instance =
        PylonsWalletImpl(host: host, uniLink: UniLinksPlatform.instance);
  }

  /// Async: Send the provided message over the IPC channel, then retrieve a
  /// response.
  ///
  /// [sdkipcMessage] is the prebuilt message to be sent; [completer] is the completer which will
  /// generate the final response.
  Future<SDKIPCResponse> sendMessage(
      SDKIPCMessage sdkipcMessage, Completer<SDKIPCResponse> completer);

  /// Async: Returns true if an IPC target exists. False otherwise.
  Future<bool> exists();

  /// Redirects user to the Pylons Wallet page on the Store.
  ///
  /// Returns true if it's available to launch the Store URL, false otherwise.
  Future<bool> goToInstall();

  /// Redirects user to the Pylons Wallet app.
  Future<SDKIPCResponse> goToPylons({bool requestResponse});

  /// Async: Retrieves the cookbook with provided ID [id].
  ///
  /// Response's data field is the retrieved [Cookbook].
  ///
  /// Error field may list one of the following exceptions in the event that the
  /// cookbook is not retrieved successfully:
  ///
  /// [NoWalletException] : There's no attached wallet.
  ///
  /// [NodeInternalErrorException] : The node threw an unexpected error when
  /// handling the query. This should not occur in production environments.
  ///
  /// [UnhandledErrorException] : Received an error from the wallet, but the
  /// error didn't match any errors we were expecting. This should really,
  /// really not occur in production environments.
  ///
  /// [ResponseException] : After sending the message to the wallet, the
  /// received response does not fit the expected format.
  ///
  /// If the operation fails due to an exception thrown by this library, that
  /// exception will be passed directly.
  Future<SDKIPCResponse<Cookbook>> getCookbook(String id);

  /// Async: Retrieves current state of profile with given address if provided,
  /// or current state of attached wallet's own profile if null.
  ///
  /// Response's data field is the retrieved [Profile].
  ///
  /// Error field may list one of the following exceptions in the event that the
  /// profile is not retrieved successfully:
  ///
  /// [NoWalletException] : There's no attached wallet.
  ///
  /// [NotAnAddressException] : An argument was provided, but did not pass
  /// address validation.
  ///
  /// [ProfileDoesNotExistException] : There is no profile at the provided
  /// address.
  ///
  /// [NodeInternalErrorException] : The node threw an unexpected error when
  /// handling the query. This should not occur in production environments.
  ///
  /// [UnhandledErrorException] : Received an error from the wallet, but the
  /// error didn't match any errors we were expecting. This should really,
  /// really not occur in production environments.
  ///
  /// [ResponseException] : After sending the message to the wallet, the
  /// received response does not fit the expected format.
  ///
  /// If the operation fails due to an exception thrown by this library, that
  /// exception will be passed directly.
  Future<SDKIPCResponse<Profile>> getProfile();

  /// Async: Retrieves a list of recipes on the Pylons chain in the cookbook with ID
  /// [cookbook].
  ///
  /// Response's data field is a [List]<[Recipe]> containing the retrieved recipes.
  /// This will ordinarily be "successful" even if there are no recipes to be retrieved,
  /// in which case it'll just give you an empty list.
  ///
  /// Error field may list one of the following exceptions in the event that the
  /// recipes are not retrieved successfully:
  ///
  /// [NoWalletException] : There's no attached wallet.
  ///
  /// [NodeInternalErrorException] : The node threw an unexpected error when
  /// handling the query. This should not occur in production environments.
  ///
  /// [UnhandledErrorException] : Received an error from the wallet, but the
  /// error didn't match any errors we were expecting. This should really,
  /// really not occur in production environments.
  ///
  /// [ResponseException] : After sending the message to the wallet, the
  /// received response does not fit the expected format.
  ///
  /// If the operation fails due to an exception thrown by this library, that
  /// exception will be passed directly.
  Future<SDKIPCResponse<List<Recipe>>> getRecipes(String cookbook);

  /// Async: Retrieves all current trades that exist on the Pylons chain based on the given [creator].
  ///
  /// Response's data field is a [List]<[Trade]> containing the retrieved trades. This will
  /// ordinarily be "successful" even if there are no trades to be retrieved,
  /// in which case it'll just give you an empty list.
  ///
  /// Error field may list one of the following exceptions in the event that the
  /// trades are not retrieved successfully:
  ///
  /// [NoWalletException] : There's no attached wallet.
  ///
  /// [NodeInternalErrorException] : The node threw an unexpected error when
  /// handling the query. This should not occur in production environments.
  ///
  /// [UnhandledErrorException] : Received an error from the wallet, but the
  /// error didn't match any errors we were expecting. This should really,
  /// really not occur in production environments.
  ///
  /// If the operation fails due to an exception thrown by this library, that
  /// exception will be passed directly.
  Future<SDKIPCResponse<List<Trade>>> getTrades(String creator);

  /// Async: Creates a transaction to buy an item using either Pylons or a
  /// third-party payment processor.
  ///
  /// TODO: Comprehensive list of processors and what they use paymentId for.
  ///
  /// TODO: This has been ported as it is in the Kotlin implementation, but
  /// it's worth noting that placeForSale doesn't expose a way to list an item
  /// for purchase using Stripe or anything like that. So is paymentId ever
  /// actually used here, or is it just an artifact of the fulfill-trade TX
  /// having that field? If the latter, we should eliminate paymentId from this
  /// call.
  ///
  /// Upon successful resolution of the transaction, response's data field is
  /// the state of the [Profile] after buying the item.
  ///
  /// Error field may list one of the following exceptions in the event that the
  /// transaction is not resolved successfully:
  ///
  /// [NoWalletException] : There's no attached wallet.
  ///
  /// [PaymentNotValidException] : The paymentId does not exist, or is not for
  /// the item being purchased.
  ///
  /// [ProfileStateException] : The active profile has insufficient Pylons for
  /// an item being purchased using Pylons.
  ///
  /// [ProfileDoesNotExistException] : TX rejected because profile doesn't exist
  /// on the chain.
  ///
  /// [NodeInternalErrorException] : TX rejected because the Pylons node had an
  /// internal error. This shouldn't be seen in production.
  ///
  /// [UnhandledErrorException] : Received an error from the wallet, but the
  /// error didn't match any errors we were expecting. This should really,
  /// really not occur in production environments.
  ///
  /// If the operation fails due to an exception thrown by this library, that
  /// exception will be passed directly.
  Future<SDKIPCResponse> txBuyItem(String tradeId, String paymentId);

  /// Async: Creates a transaction to buy the provided number of Pylons using a
  /// third-party payment processor.
  ///
  /// TODO: Comprehensive list of processors and what they use paymentId for.
  /// (I know we have Stripe integration; dunno if Google Play pylons purchase
  /// is still a thing.)
  ///
  /// Upon successful resolution of the transaction, response's data field is
  /// the state of the [Profile] after buying the Pylons.
  ///
  /// Error field may list one of the following exceptions in the event that the
  /// transaction is not resolved successfully:
  ///
  /// [NoWalletException] : There's no attached wallet.
  ///
  /// [PaymentNotValidException] : The paymentId does not exist, or is not for
  /// the number of Pylons we're attempting to purchase.
  ///
  /// [ProfileDoesNotExistException] : TX rejected because profile doesn't exist
  /// on the chain.
  ///
  /// [NodeInternalErrorException] : TX rejected because the Pylons node had an
  /// internal error. This shouldn't be seen in production.
  ///
  /// [UnhandledErrorException] : Received an error from the wallet, but the
  /// error didn't match any errors we were expecting. This should really,
  /// really not occur in production environments.
  ///
  /// If the operation fails due to an exception thrown by this library, that
  /// exception will be passed directly.
  Future<SDKIPCResponse> txBuyPylons(int pylons, String paymentId,
      {bool requestResponse});

  /// Async: Creates a transaction to create the provided [Cookbook] on the
  /// Pylons chain against the current profile.
  ///
  /// A cookbook with the same name as the provided one must not already exist.
  ///
  /// Upon successful resolution of the transaction, response's data field is
  /// the [Cookbook] as it newly exists on chain.
  ///
  /// Error field may list one of the following exceptions in the event that the
  /// transaction is not resolved successfully:
  ///
  /// [NoWalletException] : There's no attached wallet.
  ///
  /// [CookbookAlreadyExistsException] : TX rejected because a cookbook with the
  /// provided name already exists.
  ///
  /// [ProfileStateException] : The active profile was not able to create the
  /// cookbook on account of insufficient funds.
  ///
  /// [ProfileDoesNotExistException] : TX rejected because profile doesn't exist
  /// on the chain.
  ///
  /// [NodeInternalErrorException] : TX rejected because the Pylons node had an
  /// internal error. This shouldn't be seen in production.
  ///
  /// [UnhandledErrorException] : Received an error from the wallet, but the
  /// error didn't match any errors we were expecting. This should really,
  /// really not occur in production environments.
  ///
  /// If the operation fails due to an exception thrown by this library, that
  /// exception will be passed directly.
  Future<SDKIPCResponse> txCreateCookbook(Cookbook cookbook,
      {bool requestResponse = true});

  /// Async: Creates a transaction to create the provided [Recipe] on the Pylons
  /// chain against the current profile.
  ///
  /// A recipe must not already exist at the coordinates of the provided recipe.
  ///
  /// Upon successful resolution of the transaction, response's data field is
  /// the [Recipe] as it newly exists on chain.
  ///
  /// Error field may list one of the following exceptions in the event that the
  /// transaction is not resolved successfully:
  ///
  /// [NoWalletException] : There's no attached wallet.
  ///
  /// [RecipeValidationException] : No TX was created because the recipe failed
  /// basic clientside sanity-checking before one could be built. This could
  /// be because of impossible outputs, etc. The error message provides more
  /// info on why the sanity check failed.
  ///
  /// [CookbookNotOwnedException] : TX rejected because the active profile is not
  /// the owner of the cookbook in which the recipe was to be created.
  ///
  /// [CookbookDoesNotExistException] : TX rejected because the cookbook in
  /// which the recipe was to be created does not exist.
  ///
  /// [RecipeAlreadyExistsException] : TX rejected because recipe already exists
  /// at the provided coordinates.
  ///
  /// [ProfileStateException] : The active profile was not able to create the
  /// recipe on account of insufficient funds.
  ///
  /// [ProfileDoesNotExistException] : TX rejected because profile doesn't exist
  /// on the chain.
  ///
  /// [NodeInternalErrorException] : TX rejected because the Pylons node had an
  /// internal error. This shouldn't be seen in production.
  ///
  /// [UnhandledErrorException] : Received an error from the wallet, but the
  /// error didn't match any errors we were expecting. This should really,
  /// really not occur in production environments.
  ///
  /// If the operation fails due to an exception thrown by this library, that
  /// exception will be passed directly.
  Future<SDKIPCResponse> txCreateRecipe(Recipe recipe, {bool requestResponse});

  /// Async: Creates a transaction to execute the recipe with coordinates
  /// [cookbookId] : [recipeName] against the current profile.
  ///
  /// Upon successful resolution of the transaction, response's data field is
  /// the state of the active [Profile] after execution of the recipe.
  ///
  /// Error field may list one of the following exceptions in the event that the
  /// transaction is not resolved successfully:
  ///
  /// [NoWalletException] : There's no attached wallet.
  ///
  /// [RecipeDoesNotExistException] : TX rejected because recipe does not exist.
  ///
  /// [CookbookDoesNotExistException] : TX rejected because cookbook does not exist.
  ///
  /// [ProfileStateException] : TX rejected because profile doesn't have all
  /// necessary recipe inputs.
  ///
  /// [ProfileDoesNotExistException] : TX rejected because profile doesn't exist
  /// on the chain.
  ///
  /// [NodeInternalErrorException] : TX rejected because the Pylons node had an
  /// internal error. This shouldn't be seen in production.
  ///
  /// [UnhandledErrorException] : Received an error from the wallet, but the
  /// error didn't match any errors we were expecting. This should really,
  /// really not occur in production environments.
  ///
  /// If the operation fails due to an exception thrown by this library, that
  /// exception will be passed directly.
  Future<SDKIPCResponse> txExecuteRecipe(
      {required String cookbookId,
      required String recipeName,
      required List<String> itemIds,
      required int coinInputIndex,
      required List<PaymentInfo> paymentInfo,
      bool requestResponse});

  /// Async: Creates a transaction to post a trade of the provided [Item] for a
  /// price in pylons against the current profile.
  ///
  /// The active profile must own the item.
  ///
  /// Upon successful resolution of the transaction, response's data field is a
  /// [Tuple2] the state of the [Profile] after creation of the
  /// trade and the [Trade] as it newly exists on chain.
  ///
  /// Error field may list one of the following exceptions in the event that the
  /// transaction is not resolved successfully:
  ///
  /// [NoWalletException] : There's no attached wallet.
  ///
  /// [ItemDoesNotExistException] : TX rejected because the item does not
  /// exist on the chain.
  ///
  /// [ItemNotOwnedException] : TX rejected because the active profile is not
  /// the owner of the item to be placed for sale.
  ///
  /// [ProfileDoesNotExistException] : TX rejected because profile doesn't exist
  /// on the chain.
  ///
  /// [NodeInternalErrorException] : TX rejected because the Pylons node had an
  /// internal error. This shouldn't be seen in production.
  ///
  /// [UnhandledErrorException] : Received an error from the wallet, but the
  /// error didn't match any errors we were expecting. This should really,
  /// really not occur in production environments.
  ///
  /// If the operation fails due to an exception thrown by this library, that
  /// exception will be passed directly.
  Future<SDKIPCResponse> txPlaceForSale(ItemRef item, int price);

  /// Async: Creates a transaction to updates the provided [Cookbook] on the
  /// Pylons chain to match that provided against the current profile.
  ///
  /// A cookbook with the same name as the provided one must already exist and
  /// be owned by the active profile.
  ///
  /// Upon successful resolution of the transaction, response's data field is
  /// the [Cookbook] as it now exists on chain.
  ///
  /// Error field may list one of the following exceptions in the event that the
  /// transaction is not resolved successfully:
  ///
  /// [NoWalletException] : There's no attached wallet.
  ///
  /// [CookbookNotOwnedException] : TX rejected because the active profile is not
  /// the owner of the cookbook to be updated.
  ///
  /// [CookbookDoesNotExistException] : TX rejected because a cookbook with the
  /// provided name already exists.
  ///
  /// [ProfileStateException] : The active profile was not able to update the
  /// cookbook on account of insufficient funds.
  ///
  /// [ProfileDoesNotExistException] : TX rejected because profile doesn't exist
  /// on the chain.
  ///
  /// [NodeInternalErrorException] : TX rejected because the Pylons node had an
  /// internal error. This shouldn't be seen in production.
  ///
  /// [UnhandledErrorException] : Received an error from the wallet, but the
  /// error didn't match any errors we were expecting. This should really,
  /// really not occur in production environments.
  ///
  /// If the operation fails due to an exception thrown by this library, that
  /// exception will be passed directly.
  Future<SDKIPCResponse> txUpdateCookbook(Cookbook cookbook,
      {bool requestResponse});

  /// Async: Creates a transaction to updates the provided [Recipe] on the
  /// Pylons chain to match that provided against the current profile.
  ///
  /// A recipe must already exist at the coordinates of the provided recipe,
  /// and be owned by the current profile..
  ///
  /// Upon successful resolution of the transaction, response's data field is
  /// the [Recipe] as it now exists on chain.
  ///
  /// Error field may list one of the following exceptions in the event that the
  /// transaction is not resolved successfully:
  ///
  /// [NoWalletException] : There's no attached wallet.
  ///
  /// [RecipeValidationException] : No TX was created because the recipe failed
  /// basic clientside sanity-checking before one could be built. This could
  /// be because of impossible outputs, etc. The error message provides more
  /// info on why the sanity check failed.
  ///
  /// [RecipeNotOwnedException] : TX rejected because the active profile is not
  /// the owner of the recipe to be updated.
  ///
  /// [RecipeDoesNotExistException] : TX rejected because the recipe to be
  /// updated does not exist on the Pylons chain.
  ///
  /// [ProfileDoesNotExistException] : TX rejected because profile doesn't exist
  /// on the chain.
  ///
  /// [NodeInternalErrorException] : TX rejected because the Pylons node had an
  /// internal error. This shouldn't be seen in production.
  ///
  /// [UnhandledErrorException] : Received an error from the wallet, but the
  /// error didn't match any errors we were expecting. This should really,
  /// really not occur in production environments.
  ///
  /// If the operation fails due to an exception thrown by this library, that
  /// exception will be passed directly.
  Future<SDKIPCResponse> txUpdateRecipe(Recipe recipe, {bool requestResponse});

  /// This method gets the recipe based on the cookbookId and the recipeId
  /// Input : [cookbookId] the id of the cookbook which contains the recipe, [recipeId] the id of the recipe
  /// Output: [Recipe] the recipe that we need.
  Future<SDKIPCResponse<Recipe>> getRecipe(String cookbookId, String recipeId);

  /// This method returns the execution list based on the recipe
  /// Input : [cookbookId] the id of the cookbook which contains the recipe, [recipeId] the id of the recipe
  /// Output: [ExecutionListByRecipeResponse] contains execution list by recipe
  Future<SDKIPCResponse<ExecutionListByRecipeResponse>>
      getExecutionBasedOnRecipe(
          {required String cookbookId, required String recipeId});

  /// This method returns the list by owner
  /// Input : [owner] the id of the whose id you want to fetch
  /// Output: [Item] contains the list of the items by the owner
  Future<SDKIPCResponse<List<Item>>> getItemListByOwner(
      {required String owner});

  /// This method returns the get item by id
  /// Input : [cookbookId] the id of the cookbook which contains the item, [itemId] the id of the item
  /// Output: [Item] contains the item based on the id
  Future<SDKIPCResponse<Item>> getItemById(
      {required String cookbookId, required String itemId});

  /// This method returns the execution based on id
  /// Input : [id] the id of the execution
  /// Output: [Execution] contains the execution
  Future<SDKIPCResponse<Execution>> getExecutionBasedOnId({required String id});

  /// This method moves the user to stripe screen in order to create an account
  Future<SDKIPCResponse> showStripe();
}
