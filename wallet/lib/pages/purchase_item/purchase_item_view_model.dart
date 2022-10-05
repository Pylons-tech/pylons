import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/model/nft_ownership_history.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/execution.pb.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/audio_player_helper.dart';
import 'package:pylons_wallet/services/third_party_services/share_helper.dart';
import 'package:pylons_wallet/services/third_party_services/video_player_helper.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';
import 'package:video_player/video_player.dart';

class PurchaseItemViewModel extends ChangeNotifier {
  PurchaseItemViewModel(this.walletsStore, {required this.audioPlayerHelper, required this.videoPlayerHelper, required this.repository, required this.shareHelper});

  bool get isViewingFullNft => _isViewingFullNft;

  set isViewingFullNft(bool value) {
    _isViewingFullNft = value;
    notifyListeners();
  }

  bool get isVideoLoading => _isVideoLoading;

  set isVideoLoading(bool value) {
    _isVideoLoading = value;
    notifyListeners();
  }

  int get likesCount => _likesCount;

  set likesCount(int value) {
    _likesCount = value;
    notifyListeners();
  }

  bool get likedByMe => _likedByMe;

  set likedByMe(bool value) {
    _likedByMe = value;
    notifyListeners();
  }

  bool _isLiking = true;

  bool get isLiking => _isLiking;

  set isLiking(bool value) {
    _isLiking = value;
    notifyListeners();
  }

  int get viewsCount => _viewsCount;

  set viewsCount(int value) {
    _viewsCount = value;
    notifyListeners();
  }

  String get videoLoadingError => _videoLoadingError;

  set videoLoadingError(String value) {
    _videoLoadingError = value;
    notifyListeners();
  }

  late bool _collapsed = true;

  bool get collapsed => _collapsed;

  set collapsed(bool value) {
    _collapsed = value;
    notifyListeners();
  }

  void setNFT(NFT nft) {
    _nft = nft;
    final walletsList = walletsStore.getWallets().value;
    accountPublicInfo = walletsList.last;

    repository.logPurchaseItem(recipeId: nft.recipeID, recipeName: nft.name, author: nft.creator, purchasePrice: double.parse(nft.price) / kBigIntBase);
  }

  void initializeData() {
    nftDataInit(recipeId: nft.recipeID, cookBookId: nft.cookbookID, itemId: nft.itemID);
    initializePlayers(nft);
    toHashtagList();
  }

  Future<SdkIpcResponse<Execution>> paymentForRecipe() async {
    const jsonExecuteRecipe = '''
      {
        "creator": "",
        "cookbookId": "",
        "recipeId": "",
        "nftName": "",
        "nftPrice": "",
        "nftCurrency": "",
        "coinInputsIndex": 0
        }
        ''';

    final jsonMap = jsonDecode(jsonExecuteRecipe) as Map;
    jsonMap[kCookbookIdMap] = nft.cookbookID;
    jsonMap[kRecipeIdMap] = nft.recipeID;
    jsonMap[kNftName] = nft.name;
    jsonMap[kNftPrice] = nft.ibcCoins.getCoinWithProperDenomination(nft.price);
    jsonMap[kNftCurrency] = nft.ibcCoins.getAbbrev();

    final showLoader = Loading()..showLoading();

    final response = await walletsStore.executeRecipe(jsonMap);
    showLoader.dismiss();
    return response;
  }

  Future<void> paymentForTrade() async {
    final showLoader = Loading()..showLoading();
    const json = '''
        {
          "ID": 0
        }
        ''';
    final jsonMap = jsonDecode(json) as Map;
    jsonMap["ID"] = nft.tradeID;
    final response = await walletsStore.fulfillTrade(jsonMap);

    showLoader.dismiss();

    (response.success ? "purchase_nft_success".tr() : response.error).show();

    showLoader.dismiss();
  }

  void initializePlayers(NFT nft) {
    switch (nft.assetType) {
      case AssetType.Audio:
        initializeAudioPlayer();
        break;
      case AssetType.Image:
        break;
      case AssetType.Video:
        initializeVideoPlayer();
        break;

      default:
        break;
    }
  }

  void destroyPlayers() {
    switch (nft.assetType) {
      case AssetType.Audio:
        disposeAudioController();
        break;
      case AssetType.Image:
        break;
      case AssetType.Video:
        disposeVideoController();
        break;
      default:
        break;
    }
  }

  Future<void> initializeVideoPlayer() async {
    videoPlayerHelper.initializeVideoPlayer(url: nft.url);
    videoPlayerController = videoPlayerHelper.getVideoPlayerController();
    delayLoading();
    notifyListeners();

    videoPlayerController.addListener(() {
      if (videoPlayerController.value.hasError) {
        videoLoadingError = videoPlayerController.value.errorDescription!;
      }
      notifyListeners();
    });
  }

  Future<void> delayLoading() async {
    Future.delayed(const Duration(seconds: 3));
    isVideoLoading = false;
  }

  void playVideo() {
    videoPlayerHelper.playVideo();
  }

  void pauseVideo() {
    videoPlayerHelper.pauseVideo();
  }

  void seekVideo(Duration position) {
    videoPlayerHelper.seekToVideo(position: position);
  }

  void disposeVideoController() {
    videoPlayerController.removeListener(() {});
    videoPlayerHelper.destroyVideoPlayer();
  }

  bool isUrlLoaded = false;

  Future<void> nftDataInit({required String recipeId, required String cookBookId, required String itemId}) async {
    final walletAddress = walletsStore.getWallets().value.last.publicAddress;
    if (nft.type != NftType.TYPE_RECIPE) {
      final nftOwnershipHistory = await repository.getNftOwnershipHistory(itemId: itemId, cookBookId: cookBookId);
      if (nftOwnershipHistory.isLeft()) {
        "something_wrong".tr().show();
        return;
      }

      nftOwnershipHistoryList = nftOwnershipHistory.getOrElse(() => []);
    }

    final likesCountEither = await repository.getLikesCount(
      cookBookID: cookBookId,
      recipeId: recipeId,
    );

    if (likesCountEither.isLeft()) {
      "something_wrong".tr().show();
      return;
    }

    likesCount = likesCountEither.getOrElse(() => 0);

    final likedByMeEither = await repository.ifLikedByMe(
      cookBookID: cookBookId,
      recipeId: recipeId,
      walletAddress: walletAddress,
    );

    if (likedByMeEither.isLeft()) {
      "something_wrong".tr().show();
      return;
    }

    likedByMe = likedByMeEither.getOrElse(() => false);

    final countViewEither = await repository.countAView(
      recipeId: recipeId,
      walletAddress: walletAddress,
      cookBookID: cookBookId,
    );

    if (countViewEither.isLeft()) {
      return;
    }

    final viewsCountEither = await repository.getViewsCount(
      recipeId: recipeId,
      cookBookID: cookBookId,
    );

    if (viewsCountEither.isLeft()) {
      return;
    }
    isLiking = false;

    viewsCount = viewsCountEither.getOrElse(() => 0);
  }

  Future<void> updateLikeStatus({required String recipeId, required String cookBookID}) async {
    isLiking = true;
    final bool temp = likedByMe;

    final walletAddress = walletsStore.getWallets().value.last.publicAddress;
    final updateLikeStatusEither = await repository.updateLikeStatus(
      recipeId: recipeId,
      cookBookID: cookBookID,
      walletAddress: walletAddress,
    );

    if (updateLikeStatusEither.isLeft()) {
      "something_wrong".tr().show();
      return;
    }
    likedByMe = !likedByMe;
    isLiking = false;
    if (temp && likesCount > 0) {
      likesCount = likesCount - 1;
    } else {
      likesCount = likesCount + 1;
    }
  }

  Future<void> initializeAudioPlayer() async {
    progressNotifier = ValueNotifier<ProgressBarState>(
      ProgressBarState(
        current: Duration.zero,
        buffered: Duration.zero,
        total: Duration.zero,
      ),
    );
    buttonNotifier = ValueNotifier<ButtonState>(ButtonState.loading);

    isUrlLoaded = await audioPlayerHelper.setUrl(url: nft.url);

    if (isUrlLoaded) {
      playerStateSubscription = audioPlayerHelper.playerStateStream().listen((playerState) {
        final isPlaying = playerState.playing;
        final processingState = playerState.processingState;

        switch (processingState) {
          case ProcessingState.loading:
          case ProcessingState.buffering:
            buttonNotifier.value = ButtonState.loading;
            break;

          case ProcessingState.ready:
            if (!isPlaying) {
              buttonNotifier.value = ButtonState.paused;
              break;
            }
            buttonNotifier.value = ButtonState.playing;
            break;

          default:
            audioPlayerHelper.seekAudio(position: Duration.zero);
            audioPlayerHelper.pauseAudio();
        }
      });

      positionStreamSubscription = audioPlayerHelper.positionStream().listen((position) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: position,
          buffered: oldState.buffered,
          total: oldState.total,
        );
      });

      bufferPositionSubscription = audioPlayerHelper.bufferedPositionStream().listen((bufferedPosition) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: bufferedPosition,
          total: oldState.total,
        );
      });

      durationStreamSubscription = audioPlayerHelper.durationStream().listen((totalDuration) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: oldState.buffered,
          total: totalDuration ?? Duration.zero,
        );
      });
    }
  }

  void playAudio() {
    audioPlayerHelper.playAudio();
  }

  void pauseAudio() {
    audioPlayerHelper.pauseAudio();
  }

  void seekAudio(Duration position) {
    audioPlayerHelper.seekAudio(position: position);
  }

  void disposeAudioController() {
    if (isUrlLoaded) {
      playerStateSubscription.cancel();
      bufferPositionSubscription.cancel();
      durationStreamSubscription.cancel();
      positionStreamSubscription.cancel();
    }
    audioPlayerHelper.destroyAudioPlayer();
  }

  void toHashtagList() {
    hashtagList = nft.hashtags.split("#");
  }

  void toChangeCollapse() {
    collapsed = !collapsed;
    notifyListeners();
  }

  Future<void> shareNFTLink({required Size size}) async {
    final address = walletsStore.getWallets().value.last.publicAddress;

    final link = await repository.createDynamicLinkForRecipeNftShare(address: address, nft: nft);
    return link.fold((l) {
      "something_wrong".tr().show();
      return null;
    }, (r) {
      shareHelper.shareText(text: r, size: size);
      return null;
    });
  }

  Future<Either<String, bool>> shouldShowSwipeToBuy({required String selectedDenom, required double requiredAmount}) async {
    final accountPublicInfo = walletsStore.getWallets().value.last;
    final balancesEither = await repository.getBalance(accountPublicInfo.publicAddress);

    if (balancesEither.isLeft()) {
      return Left("something_wrong".tr());
    }

    if (balancesEither.getOrElse(() => []).isEmpty) {
      return const Right(false);
    }

    if (selectedDenom == IBCCoins.ustripeusd.name) {
      return const Right(true);
    }

    final mappedBalances = balancesEither.getOrElse(() => []).where((element) => element.denom == selectedDenom).toList();
    if (mappedBalances.isEmpty) {
      return const Right(false);
    }

    final unWrappedBalanceAmountForSelectedCoin = double.parse(mappedBalances.first.amount.toString()) / kBigIntBase;

    if (unWrappedBalanceAmountForSelectedCoin < requiredAmount) {
      return const Right(false);
    }
    return const Right(true);
  }

  void addLogForCart() {
    repository.logAddToCart(
      recipeId: nft.recipeID,
      recipeName: nft.name,
      author: nft.creator,
      purchasePrice: double.parse(nft.price) / kBigIntBase,
      currency: nft.ibcCoins.name,
    );
  }

  @visibleForTesting
  bool isRealWorldPaymentAllowed({required bool isPlatformAndroid}) {
    if (isPlatformAndroid) {
      return true;
    } else {
      return nft.realWorld;
    }
  }

  /// Conditions
  /// If item is available for buying
  /// If nft is free drop show the button
  /// If any currency other than stripe usd show button
  /// If stripe payment is allowed or nft
  bool showBuyNowButton({required bool isPlatformAndroid}) {
    if (!(nft.amountMinted < nft.quantity)) {
      return false;
    }

    if (double.parse(nft.price) == 0) {
      return true;
    }

    if (nft.ibcCoins != IBCCoins.ustripeusd) {
      return true;
    }

    return isRealWorldPaymentAllowed(isPlatformAndroid: isPlatformAndroid);
  }

  NFT get nft => _nft;

  final AudioPlayerHelper audioPlayerHelper;
  final VideoPlayerHelper videoPlayerHelper;
  final Repository repository;
  final ShareHelper shareHelper;
  NFT _nft = NFT(ibcCoins: IBCCoins.upylon);
  bool darkMode = false;
  bool _isViewingFullNft = false;
  AccountPublicInfo? accountPublicInfo;
  late StreamSubscription playerStateSubscription;
  late StreamSubscription positionStreamSubscription;
  late StreamSubscription bufferPositionSubscription;
  late StreamSubscription durationStreamSubscription;
  late VideoPlayerController videoPlayerController;
  late ValueNotifier<ProgressBarState> progressNotifier;
  late ValueNotifier<ButtonState> buttonNotifier;
  WalletsStore walletsStore;
  String _videoLoadingError = "";
  int _viewsCount = 0;
  int _likesCount = 0;
  List<String> hashtagList = [];
  List<NftOwnershipHistory> nftOwnershipHistoryList = [];
  bool _isVideoLoading = true;
  bool _likedByMe = false;

  void logEvent() {
    repository.logUserJourney(screenName: AnalyticsScreenEvents.purchaseView);
  }
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });

  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { paused, playing, loading }
