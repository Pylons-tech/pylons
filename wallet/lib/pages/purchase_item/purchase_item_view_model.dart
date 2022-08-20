import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/model/nft_ownership_history.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/audio_player_helper.dart';
import 'package:pylons_wallet/services/third_party_services/share_helper.dart';
import 'package:pylons_wallet/services/third_party_services/video_player_helper.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/extension.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';
import 'package:video_player/video_player.dart';

class PurchaseItemViewModel extends ChangeNotifier {
  NFT nft = NFT(ibcCoins: IBCCoins.upylon);
  bool darkMode = false;

  WalletsStore walletsStore;

  ValueNotifier<bool> shouldShowBuyNow = ValueNotifier(false);
  final AudioPlayerHelper audioPlayerHelper;
  final VideoPlayerHelper videoPlayerHelper;

  final Repository repository;
  ShareHelper shareHelper;

  PurchaseItemViewModel(this.walletsStore,
      {required this.audioPlayerHelper,
      required this.videoPlayerHelper,
      required this.repository,
      required this.shareHelper});

  late StreamSubscription playerStateSubscription;
  late StreamSubscription positionStreamSubscription;
  late StreamSubscription bufferPositionSubscription;
  late StreamSubscription durationStreamSubscription;

  late VideoPlayerController videoPlayerController;

  bool _isVideoLoading = true;

  bool get isVideoLoading => _isVideoLoading;

  set isVideoLoading(bool value) {
    _isVideoLoading = value;
    notifyListeners();
  }

  int _likesCount = 0;

  int get likesCount => _likesCount;

  set likesCount(int value) {
    _likesCount = value;
    notifyListeners();
  }

  bool _likedByMe = false;

  bool get likedByMe => _likedByMe;

  set likedByMe(bool value) {
    _likedByMe = value;
    notifyListeners();
  }

  bool _isLiking = false;

  bool get isLiking => _isLiking;

  set isLiking(bool value) {
    _isLiking = value;
    notifyListeners();
  }

  int _viewsCount = 0;

  int get viewsCount => _viewsCount;

  set viewsCount(int value) {
    _viewsCount = value;
    notifyListeners();
  }

  String _videoLoadingError = "";

  String get videoLoadingError => _videoLoadingError;

  set videoLoadingError(String value) {
    _videoLoadingError = value;
    notifyListeners();
  }

  late ValueNotifier<ProgressBarState> progressNotifier;
  late ValueNotifier<ButtonState> buttonNotifier;

  late bool collapsed = true;

  List<String> hashtagList = [];
  List<NftOwnershipHistory> nftOwnershipHistoryList = [];

  AccountPublicInfo? accountPublicInfo;

  void setNFT(NFT nft) {
    this.nft = nft;
    final walletsList = walletsStore.getWallets().value;
    accountPublicInfo = walletsList.last;
    final isCurrentUserNotOwner = walletsList
        .where((element) => element.publicAddress == nft.ownerAddress)
        .isEmpty;

    final isMaxNFtNotMinted = nft.quantity - nft.amountMinted > 0;

    switch (nft.type) {
      case NftType.TYPE_RECIPE:
        shouldShowBuyNow.value = isMaxNFtNotMinted && isCurrentUserNotOwner;
        break;
      case NftType.TYPE_ITEM:
      case NftType.TYPE_TRADE:
        shouldShowBuyNow.value = isCurrentUserNotOwner;
        break;
    }

    notifyListeners();
  }

  void initializeData({required NFT nft}) {
    nftDataInit(recipeId: nft.recipeID, cookBookId: nft.cookbookID);
    initializePlayers(nft);
    toHashtagList();
  }

  Future<SdkIpcResponse> paymentForRecipe() async {
    const jsonExecuteRecipe = '''
      {
        "creator": "",
        "cookbookId": "",
        "recipeId": "",
        "coinInputsIndex": 0
        }
        ''';

    final jsonMap = jsonDecode(jsonExecuteRecipe) as Map;
    jsonMap[kCookbookIdMap] = nft.cookbookID;
    jsonMap[kRecipeIdMap] = nft.recipeID;

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

  void destroyPlayers(NFT nft) {
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

  Future<void> nftDataInit(
      {required String recipeId, required String cookBookId}) async {
    final walletAddress = walletsStore.getWallets().value.last.publicAddress;
    if (nft.type != NftType.TYPE_RECIPE) {
      final nftOwnershipHistory = await repository.getNftOwnershipHistory(
          recipeID: recipeId, cookBookId: cookBookId);
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
      "something_wrong".tr().show();
      return;
    }

    final viewsCountEither = await repository.getViewsCount(
      recipeId: recipeId,
      cookBookID: cookBookId,
    );

    if (viewsCountEither.isLeft()) {
      "something_wrong".tr().show();
      return;
    }

    viewsCount = viewsCountEither.getOrElse(() => 0);
  }

  Future<void> updateLikeStatus(
      {required String recipeId, required String cookBookID}) async {
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
      playerStateSubscription =
          audioPlayerHelper.playerStateStream().listen((playerState) {
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

      positionStreamSubscription =
          audioPlayerHelper.positionStream().listen((position) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: position,
          buffered: oldState.buffered,
          total: oldState.total,
        );
      });

      bufferPositionSubscription =
          audioPlayerHelper.bufferedPositionStream().listen((bufferedPosition) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: bufferedPosition,
          total: oldState.total,
        );
      });

      durationStreamSubscription =
          audioPlayerHelper.durationStream().listen((totalDuration) {
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

  void shareNFT(Size size) {
    final String address = accountPublicInfo?.publicAddress ?? "";
    var msg = "";
    switch (nft.type) {
      case NftType.TYPE_TRADE:
        msg = nft.tradeID.createTradeLink(address: address);
        break;

      case NftType.TYPE_ITEM:
        msg = nft.itemID
            .createPurchaseNFT(cookBookId: nft.cookbookID, address: address);
        break;

      case NftType.TYPE_RECIPE:
        msg = nft.recipeID
            .createDynamicLink(cookbookId: nft.cookbookID, address: address);
        break;
    }

    shareHelper.shareText(text: msg, size: size);
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
