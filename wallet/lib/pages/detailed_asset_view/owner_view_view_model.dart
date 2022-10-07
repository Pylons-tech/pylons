import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/model/nft_ownership_history.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/audio_player_helper.dart';
import 'package:pylons_wallet/services/third_party_services/share_helper.dart';
import 'package:pylons_wallet/services/third_party_services/video_player_helper.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';
import 'package:video_player/video_player.dart';

import '../owner_purchase_view_common/button_state.dart';
import '../owner_purchase_view_common/progress_bar_state.dart';

class OwnerViewViewModel extends ChangeNotifier {
  late NFT nft;
  final Repository repository;
  final WalletsStore walletsStore;
  final AudioPlayerHelper audioPlayerHelper;
  final VideoPlayerHelper videoPlayerHelper;
  final ShareHelper shareHelper;

  OwnerViewViewModel({
    required this.repository,
    required this.walletsStore,
    required this.audioPlayerHelper,
    required this.shareHelper,
    required this.videoPlayerHelper,
  });

  String owner = '';

  bool _toggled = true;

  bool get toggled => _toggled;

  VideoPlayerController? videoPlayerController;

  

  late StreamSubscription playerStateSubscription;

  late StreamSubscription positionStreamSubscription;

  late StreamSubscription bufferPositionSubscription;

  late StreamSubscription durationStreamSubscription;

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

  bool likedByMe = false;

  String _videoLoadingError = "";

  String get videoLoadingError => _videoLoadingError;

  set videoLoadingError(String value) {
    _videoLoadingError = value;
    notifyListeners();
  }

  List<String> hashtagList = [];

  List<NftOwnershipHistory> nftOwnershipHistoryList = [];

  late bool _collapsed = true;

  bool get collapsed => _collapsed;

  set collapsed(bool value) {
    _collapsed = value;
    notifyListeners();
  }

  AccountPublicInfo? accountPublicInfo;

  Future initOwnerName() async {
    accountPublicInfo = walletsStore.getWallets().value.last;
    owner = accountPublicInfo?.name ?? "";
    notifyListeners();
  }

  bool _isLiking = true;

  bool _isViewingFullNft = false;

  bool get isViewingFullNft => _isViewingFullNft;

  set isViewingFullNft(bool value) {
    _isViewingFullNft = value;
    notifyListeners();
  }

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

  void initializeData() {
    nftDataInit(recipeId: nft.recipeID, cookBookId: nft.cookbookID, itemId: nft.itemID);
    initOwnerName();
    initializePlayers();
    toHashtagList();
  }

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

  void initializePlayers() {
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

// TODO :Solve this listener bug
    videoPlayerController?.addListener(() {
      if (videoPlayerController!.value.hasError) {
        videoLoadingError = videoPlayerController!.value.errorDescription!;
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
    videoPlayerController?.removeListener(() {});
    videoPlayerHelper.destroyVideoPlayer();
  }

  bool isUrlLoaded = false;

  Future<void> initializeAudioPlayer() async {
    audioProgressNotifier = ValueNotifier<ProgressBarState>(
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
    }

    positionStreamSubscription = audioPlayerHelper.positionStream().listen((position) {
      final oldState = audioProgressNotifier.value;
      audioProgressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    bufferPositionSubscription = audioPlayerHelper.bufferedPositionStream().listen((bufferedPosition) {
      final oldState = audioProgressNotifier.value;
      audioProgressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    durationStreamSubscription = audioPlayerHelper.durationStream().listen((totalDuration) {
      final oldState = audioProgressNotifier.value;
      audioProgressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
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

  void setToggle({required bool toggle}) {
    _toggled = toggle;
    notifyListeners();
  }

  void toHashtagList() {
    hashtagList = nft.hashtags.split("#");
  }

  void toChangeCollapse() {
    _collapsed = !_collapsed;
    notifyListeners();
  }

  Future<void> shareNFTLink({required Size size}) async {
    final address = GetIt.I.get<WalletsStore>().getWallets().value.last.publicAddress;

    final link = await repository.createDynamicLinkForRecipeNftShare(address: address, nft: nft);
    return link.fold((l) {
      "something_wrong".tr().show();
      return null;
    }, (r) {
      shareHelper.shareText(text: r, size: size);
      return null;
    });
  }

  void logEvent() {
    repository.logUserJourney(screenName: AnalyticsScreenEvents.ownerView);
  }



  ValueNotifier<ProgressBarState> audioProgressNotifier  = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );

  ValueNotifier<ButtonState> buttonNotifier = ValueNotifier(ButtonState.loading);
}
