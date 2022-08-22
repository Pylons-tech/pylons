/// Custom exceptions that can be thrown by API calls.
library pylons_flutter_exceptions;

/// Exception thrown by TX-emitting API calls when a cookbook already exists
/// on chain while we're trying to create it.
class CookbookAlreadyExistsException implements Exception {
  final String cookbook;
  final String cookbookSender;
  final String errMsg;

  CookbookAlreadyExistsException(
      this.cookbook, this.cookbookSender, this.errMsg);
}

/// Exception thrown by TX-emitting API calls when a cookbook does not exist on
/// the chain.
class CookbookDoesNotExistException implements Exception {
  final String cookbook;
  final String errMsg;

  CookbookDoesNotExistException(this.cookbook, this.errMsg);
}

/// Exception thrown by TX-emitting API calls when a cookbook cannot be modified
/// or a recipe cannot be created by the active profile because the cookbook is
/// owned by a different one.
class CookbookNotOwnedException implements Exception {
  final String cookbook;
  final String cbSender;
  final String errMsg;

  CookbookNotOwnedException(this.cookbook, this.cbSender, this.errMsg);
}

/// Exception thrown by TX-emitting API calls when an item to be used in
/// executing a recipe or creating a trade does not exist.
class ItemDoesNotExistException implements Exception {
  final String item;
  final String errMsg;

  ItemDoesNotExistException(this.item, this.errMsg);
}

/// Exception thrown by TX-emitting API calls when an item to be used in
/// executing a recipe or creating a trade is not owned by the active profile.
class ItemNotOwnedException implements Exception {
  final String item;
  final String itemOwner;
  final String errMsg;

  ItemNotOwnedException(this.item, this.itemOwner, this.errMsg);
}

/// Exception thrown by API calls that accept an address as an argument when
/// the supplied argument is not a valid address.
class NotAnAddressException implements Exception {
  final String address;
  final String errMsg;

  NotAnAddressException(this.address,
      {this.errMsg = 'Supplied address is not an address'});
}

/// Exception thrown by API calls when the wallet doesn't exist.
class NoWalletException implements Exception {
  final String errMsg;

  NoWalletException({this.errMsg = 'The wallet does not exist'});
}

/// Exception thrown by TX-emitting API calls when a provided payment ID does
/// not exist or is not correct for the purchase being made.
class PaymentNotValidException implements Exception {
  final String paymentId;
  final String errMsg;

  PaymentNotValidException(this.paymentId, this.errMsg);
}

/// Exception thrown by API calls when a profile does not exist on the chain.
class ProfileDoesNotExistException implements Exception {
  final String address;
  final String errMsg;

  ProfileDoesNotExistException(this.address,
      {this.errMsg = 'The account does not exist on the chain.'});
}

/// Exception thrown by TX-emitting API calls when a profile is not in a valid
/// state for the execution of a recipe.
class ProfileStateException implements Exception {
  final String errMsg;

  ProfileStateException(this.errMsg);
}

/// Exception thrown by TX-emitting API calls when a recipe already exists
/// on chain at the coordinates one is trying to be created at.
class RecipeAlreadyExistsException implements Exception {
  final String cookbook;
  final String recipeName;
  final String recipeId;
  final String errMsg;

  RecipeAlreadyExistsException(String c, String rN, String e)
      : cookbook = c,
        recipeName = rN,
        recipeId = '',
        errMsg = e;

  RecipeAlreadyExistsException.constructorWithRecipeID(String r, String e)
      : cookbook = '',
        recipeName = '',
        recipeId = r,
        errMsg = e;
}

/// Exception thrown by TX-emitting API calls when a recipe does not exist on
/// the chain.
class RecipeDoesNotExistException implements Exception {
  final String cookbook;
  final String recipeName;
  final String recipeId;
  final String errMsg;

  RecipeDoesNotExistException(String c, String rN, String e)
      : cookbook = c,
        recipeName = rN,
        recipeId = '',
        errMsg = e;

  RecipeDoesNotExistException.constructorWithRecipeID(String r, String e)
      : cookbook = '',
        recipeName = '',
        recipeId = r,
        errMsg = e;
}

/// Exception thrown by TX-emitting API calls when a recipe cannot be modified
/// by the active profile because it's owned by a different one.
class RecipeNotOwnedException implements Exception {
  final String cookbook;
  final String recipeName;
  final String recipeId;
  final String recipeSender;
  final String errMsg;

  RecipeNotOwnedException(this.cookbook, this.recipeName, this.recipeId,
      this.recipeSender, this.errMsg);
}

/// Exception thrown by TX-emitting API calls when a recipe is not in a valid
/// state for the operation that the transaction attempted to perform.
class RecipeStateException implements Exception {
  final String cookbook;
  final String recipeName;
  final String recipeId;
  final String errMsg;

  RecipeStateException(
      this.cookbook, this.recipeName, this.recipeId, this.errMsg);
}

/// Exception thrown by TX-emitting API calls when a recipe fails the sanity
/// check performed before the transaction is generated.
class RecipeValidationException implements Exception {
  final String cookbook;
  final String recipeName;
  final String recipeId;
  final String errMsg;

  RecipeValidationException(
      this.cookbook, this.recipeName, this.recipeId, this.errMsg);

  @override
  String toString() {
    return 'RecipeValidationException{cookbook: $cookbook, recipeName: $recipeName, recipeId: $recipeId, errMsg: $errMsg}';
  }
}

/// Exception thrown when an outgoing message gets an illegal response.
/// This should not be seen in production environments.
class ResponseException implements Exception {
  final String rawResponse;
  final String errMsg;

  ResponseException(this.rawResponse, this.errMsg);
}

/// Exception thrown by TX-emitting API calls when the Pylons node has an
/// internal error during processing of the emitted TX. If this occurs in
/// production environments, that's a problem.
class NodeInternalErrorException implements Exception {
  final int errorCode;
  final String nodeErrMsg;
  final String errMsg;

  NodeInternalErrorException(this.errorCode, this.nodeErrMsg, this.errMsg);
}

/// Exception thrown by API calls when they get an error they aren't prepared
/// for. This should absolutely, 100 percent never be seen in production
/// environments.
class UnhandledErrorException implements Exception {
  final String errType;
  final String errMsg;

  UnhandledErrorException(this.errType, this.errMsg);
}

/// Exception thrown when the user tries to setup the wallet again
class WalletInitializationAlreadyDoneException implements Exception {
  final String errMsg;

  WalletInitializationAlreadyDoneException(this.errMsg);
}

/// Exception thrown when the user tries to setup the wallet again
class WalletInitializationNotDone implements Exception {
  final String errMsg;

  WalletInitializationNotDone(this.errMsg);
}

/// Parent class for exceptions thrown during address encoding and decoding.
/// An exception of type AddressFormatException should never be thrown; throw
/// one of the child types instead.
class AddressFormatException implements Exception {}

/// Exception thrown by [Bech32Cosmos] when trying to encode an address with a bad human-readable part
class AddressFormatExceptionHrpLength implements AddressFormatException {
  final String errMsg;

  AddressFormatExceptionHrpLength(this.errMsg);
}

/// Exception thrown by [Bech32Cosmos] when trying to decode an address of incorrect length
class AddressFormatExceptionInputLength implements AddressFormatException {
  final String errMsg;

  AddressFormatExceptionInputLength(this.errMsg);
}

/// Exception thrown by [Bech32Cosmos] when trying to decode an address containing an invalid character
class AddressFormatExceptionInvalidCharacter implements AddressFormatException {
  final String errMsg;

  AddressFormatExceptionInvalidCharacter(this.errMsg);
}

/// Exception thrown by [Bech32Cosmos] when trying to decode an address with a data part of incorrect length
class AddressFormatExceptionDataLength implements AddressFormatException {
  final String errMsg;

  AddressFormatExceptionDataLength(this.errMsg);
}

/// Exception thrown by [Bech32Cosmos] when trying to decode an address with no human-readable part
class AddressFormatExceptionNoHrp implements AddressFormatException {
  final String errMsg;

  AddressFormatExceptionNoHrp(this.errMsg);
}

/// Exception thrown by [Bech32Cosmos] when trying to decode an address with a bad checksum
class AddressFormatExceptionChecksumFail implements AddressFormatException {
  final String errMsg;

  AddressFormatExceptionChecksumFail(this.errMsg);
}

/// Exception thrown by [Bech32Cosmos] when convertBits fails
class AddressFormatExceptionBitConvertFail implements AddressFormatException {
  final String errMsg;

  AddressFormatExceptionBitConvertFail(this.errMsg);
}
