import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pylons_wallet/model/export.dart';
import 'package:pylons_wallet/model/stripe_get_login_based_address.dart';
import 'package:pylons_wallet/model/stripe_loginlink_request.dart';
import 'package:pylons_wallet/model/stripe_loginlink_response.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/create_trade_bottom_sheet.dart';
import 'package:pylons_wallet/providers/account_provider.dart';
import 'package:pylons_wallet/services/data_stores/local_data_store.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';

import '../../generated/locale_keys.g.dart';

class StripeHandler {
  Repository repository;
  WalletsStore walletsStore;
  LocalDataSource localDataSource;
  AccountProvider accountProvider;

  StripeHandler({
    required this.repository,
    required this.walletsStore,
    required this.localDataSource,
    required this.accountProvider,
  });

  /// handleStripeAccountLink
  /// @param
  /// @return StripeFailure, String accountLink
  Future<Either<Failure, String>> handleStripeAccountLink() async {
    var token = '';
    var accountlink = "";

    accountlink = localDataSource.getStripeAccountId();

    if (accountlink != "") {
      token = localDataSource.getStripeToken();

      final accountlink_response = await repository.stripeGetLoginLink(StripeLoginLinkRequest(Account: accountlink, Signature: await walletsStore.signPureMessage(token)));
      if (accountlink_response.isLeft()) {
        return left(StripeFailure(LocaleKeys.stripe_account_link_failed.tr()));
      }

      final accountlink_info = accountlink_response.getOrElse(() => StripeLoginLinkResponse());
      if (accountlink_info.accountlink == "") {
        return left(StripeFailure(LocaleKeys.stripe_account_link_failed.tr()));
      }
      accountlink = accountlink_info.accountlink;

      saveStripeExistsFlagIfNeeded(accountlink);

      return right(accountlink);
    }

    final response = await repository.GenerateRegistrationToken(accountProvider.accountPublicInfo!.publicAddress);

    if (response.isLeft()) {
      return handleError(response);
    }

    final token_info = response.getOrElse(() => StripeGenerateRegistrationTokenResponse());

    if (token_info.token == "") {
      return left(StripeFailure(LocaleKeys.stripe_registration_token_failed.tr()));
    }

    localDataSource.saveStripeToken(token: token_info.token);

    token = token_info.token;

    final register_response = await repository.RegisterAccount(StripeRegisterAccountRequest(
      Token: token,
      Signature: await walletsStore.signPureMessage(token),
      Address: accountProvider.accountPublicInfo!.publicAddress,
    ));
    if (register_response.isLeft()) {
      return handleError(register_response);
    }

    final register_info = register_response.getOrElse(() => StripeRegisterAccountResponse());

    if (register_info.accountlink == "" || register_info.account == "") {
      return left(StripeFailure(LocaleKeys.stripe_register_account_failed.tr()));
    }

    localDataSource.saveStripeAccountId(accountId: register_info.account);
    accountlink = register_info.accountlink;

    saveStripeExistsFlagIfNeeded(accountlink);

    return right(accountlink);
  }

  /// This method will unparse the error and will check if it is related with user already exists it will update the account link
  Future<Either<Failure, String>> handleError(Either<Failure, dynamic> response) async {
    final failure = response.getLeft();

    if (failure is AccountAlreadyExistsFailure) {
      return getLinkBasedOnAddress();
    } else {
      return left(StripeFailure(LocaleKeys.stripe_registration_token_failed.tr()));
    }
  }

  Future<Either<Failure, String>> getLinkBasedOnAddress() async {
    final address = accountProvider.accountPublicInfo!.publicAddress;

    final getAccountLinkEither = await repository.getLoginLinkBasedOnAddress(StripeGetLoginBasedOnAddressRequest(address));

    if (getAccountLinkEither.isLeft()) {
      return left(StripeFailure(LocaleKeys.stripe_registration_token_failed.tr()));
    }

    localDataSource.saveStripeAccountId(accountId: getAccountLinkEither.toOption().toNullable()!.account);

    return Right(getAccountLinkEither.toOption().toNullable()!.accountlink);
  }

  void saveStripeExistsFlagIfNeeded(String accountlink) {
    if (!accountlink.contains(kStripeAccountNotCreatedIdentifier)) {
      repository.saveStripeAccountExistsLocal(isExist: true);
    }
  }
}
