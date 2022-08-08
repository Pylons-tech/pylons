import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fixnum/fixnum.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/model/export.dart';
import 'package:pylons_wallet/model/stripe_get_login_based_address.dart';
import 'package:pylons_wallet/model/stripe_loginlink_request.dart';
import 'package:pylons_wallet/model/stripe_loginlink_response.dart';
import 'package:pylons_wallet/services/data_stores/local_data_store.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';
import 'package:pylons_wallet/utils/formatter.dart';

class StripeHandler {
  Repository repository;
  WalletsStore walletsStore;
  LocalDataSource localDataSource;

  StripeHandler(
      {required this.repository,
      required this.walletsStore,
      required this.localDataSource});

  /// handleStripePayout
  /// @param amount
  /// @return StripeFailure, String Payout Transfer id
  Future<Either<Failure, String>> handleStripePayout(String amount) async {
    final dataSource = GetIt.I.get<LocalDataSource>();

    final walletsStore = GetIt.I.get<WalletsStore>();

    var token = '';
    var accountId = '';

    accountId = dataSource.getStripeAccountId();

    if (accountId == "") {
      final response = await repository.GenerateRegistrationToken(
          walletsStore.getWallets().value.last.publicAddress);

      if (response.isLeft()) {
        return left(StripeFailure("stripe_registration_token_failed".tr()));
      }

      token = response
          .getOrElse(() => StripeGenerateRegistrationTokenResponse())
          .token;

      if (token == "") {
        return left(StripeFailure("stripe_registration_token_failed".tr()));
      }

      dataSource.saveStripeToken(token: token);

      final register_response = await repository.RegisterAccount(
          StripeRegisterAccountRequest(
              Token: token,
              Signature: await walletsStore.signPureMessage(token),
              Address: walletsStore.getWallets().value.last.publicAddress));

      if (register_response.isLeft()) {
        return left(StripeFailure("stripe_register_account_failed".tr()));
      }

      final register_info =
          register_response.getOrElse(() => StripeRegisterAccountResponse());

      if (register_info.account == "" || register_info.accountlink == "") {
        return left(StripeFailure("stripe_register_account_failed".tr()));
      }

      dataSource.saveStripeAccountId(accountId: register_info.account);
    }

    final payoutToken_response =
        await repository.GeneratePayoutToken(StripeGeneratePayoutTokenRequest(
      amount: Int64.parseInt(amount.ValToUval()),
      address: walletsStore.getWallets().value.last.publicAddress,
    ));

    if (payoutToken_response.isLeft()) {
      return left(StripeFailure("stripe_payout_token_failed".tr()));
    }

    final payoutToken = payoutToken_response
        .getOrElse(() => StripeGeneratePayoutTokenResponse());

    if (payoutToken.token == "") {
      return left(StripeFailure("stripe_payout_token_failed".tr()));
    }

    final payout_response = await repository.Payout(StripePayoutRequest(
      address: walletsStore.getWallets().value.last.publicAddress,
      token: payoutToken.token,
      amount: Int64.parseInt(amount.ValToUval()),
      signature: await walletsStore.signPureMessage(payoutToken.token),
    ));

    if (payout_response.isLeft()) {
      return left(StripeFailure("stripe_payout_request_failed".tr()));
    }

    final payout_info = payout_response.getOrElse(() => StripePayoutResponse());

    if (payout_info.transfer_id == "") {
      return left(StripeFailure("stripe_payout_request_failed".tr()));
    }

    return right(payout_info.transfer_id);
  }

  /// handleStripeAccountLink
  /// @param
  /// @return StripeFailure, String accountLink
  Future<Either<Failure, String>> handleStripeAccountLink() async {
    final walletsStore = GetIt.I.get<WalletsStore>();

    var token = '';
    var accountlink = "";

    accountlink = localDataSource.getStripeAccountId();

    if (accountlink != "") {
      token = localDataSource.getStripeToken();

      final accountlink_response = await repository.stripeGetLoginLink(
          StripeLoginLinkRequest(
              Account: accountlink,
              Signature: await walletsStore.signPureMessage(token)));
      if (accountlink_response.isLeft()) {
        return left(StripeFailure("stripe_account_link_failed".tr()));
      }

      final accountlink_info =
          accountlink_response.getOrElse(() => StripeLoginLinkResponse());
      if (accountlink_info.accountlink == "") {
        return left(StripeFailure("stripe_account_link_failed".tr()));
      }
      accountlink = accountlink_info.accountlink;

      saveStripeExistsFlagIfNeeded(accountlink);

      return right(accountlink);
    }

    final response = await repository.GenerateRegistrationToken(
        walletsStore.getWallets().value.last.publicAddress);

    if (response.isLeft()) {
      return handleError(response);
    }

    final token_info =
        response.getOrElse(() => StripeGenerateRegistrationTokenResponse());

    if (token_info.token == "") {
      return left(StripeFailure("stripe_registration_token_failed".tr()));
    }

    localDataSource.saveStripeToken(token: token_info.token);

    token = token_info.token;

    final register_response = await repository.RegisterAccount(
        StripeRegisterAccountRequest(
            Token: token,
            Signature: await walletsStore.signPureMessage(token),
            Address: walletsStore.getWallets().value.last.publicAddress));
    if (register_response.isLeft()) {
      return handleError(register_response);
    }

    final register_info =
        register_response.getOrElse(() => StripeRegisterAccountResponse());

    if (register_info.accountlink == "" || register_info.account == "") {
      return left(StripeFailure("stripe_register_account_failed".tr()));
    }

    localDataSource.saveStripeAccountId(accountId: register_info.account);
    accountlink = register_info.accountlink;

    saveStripeExistsFlagIfNeeded(accountlink);

    return right(accountlink);
  }

  /// This method will unparse the error and will check if it is related with user already exists it will update the account link
  Future<Either<Failure, String>> handleError(
      Either<Failure, dynamic> response) async {
    final failure = response.swap().toOption().toNullable()!;

    if (failure is AccountAlreadyExistsFailure) {
      return getLinkBasedOnAddress();
    } else {
      return left(StripeFailure("stripe_registration_token_failed".tr()));
    }
  }

  Future<Either<Failure, String>> getLinkBasedOnAddress() async {
    final address = walletsStore.getWallets().value.last.publicAddress;

    final getAccountLinkEither = await repository.getLoginLinkBasedOnAddress(
        StripeGetLoginBasedOnAddressRequest(address));

    if (getAccountLinkEither.isLeft()) {
      return left(StripeFailure("stripe_registration_token_failed".tr()));
    }

    localDataSource.saveStripeAccountId(
        accountId: getAccountLinkEither.toOption().toNullable()!.account);

    return Right(getAccountLinkEither.toOption().toNullable()!.accountlink);
  }

  void saveStripeExistsFlagIfNeeded(String accountlink) {
    if (!accountlink.contains(kStripeAccountNotCreatedIdentifier)) {
      repository.saveStripeAccountExistsLocal(isExist: true);
    }
  }
}
