import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/models/nft_ownership_history.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/owner_view/widgets/tab_fields.dart';
import 'package:easel_flutter/services/third_party_services/audio_player_helper.dart';
import 'package:easel_flutter/services/third_party_services/video_player_helper.dart';
import 'package:flutter/material.dart';

class OwnerViewViewModel extends ChangeNotifier {
  final Repository repository;

  final AudioPlayerHelper audioPlayerHelper;
  final VideoPlayerHelper videoPlayerHelper;

  // final ShareHelper shareHelper;

  OwnerViewViewModel({
    required this.repository,
    // required this.walletsStore,
    required this.audioPlayerHelper,
    // required this.shareHelper,
    required this.videoPlayerHelper,
    // required this.accountPublicInfo,
  });

  late NFT _nft;
  bool _isLiking = true;
  bool likedByMe = false;

  bool collapsed = true;
  int viewCount = 1;
  int likesCount = 1;
  List<String> hashtagList = [];
  List<NftOwnershipHistory> nftOwnershipHistoryList = [];
  TabFields? selectedField;
  String owner = '';
  bool isOwnershipExpanded = false;
  bool isHistoryExpanded = false;
  bool isDetailsExpanded = false;
  NFT get nft => _nft;

  bool get isLiking => _isLiking;

  set isLiking(bool value) {
    _isLiking = value;
    notifyListeners();
  }

  bool _isViewingFullNft = false;

  bool get isViewingFullNft => _isViewingFullNft;

  set isViewingFullNft(bool value) {
    _isViewingFullNft = value;
    notifyListeners();
  }

  set nft(NFT value) {
    _nft = value;
    notifyListeners();
  }

  void toChangeCollapse() {
    collapsed = !collapsed;
    notifyListeners();
  }

  void closeExpansion() {
    isDetailsExpanded = false;
    isHistoryExpanded = false;
    isOwnershipExpanded = false;
    notifyListeners();
  }

  void onChangeTab(TabFields tab) {
    if (tab == selectedField && isExpansionOpen()) {
      closeExpansion();
      return;
    }

    selectedField = tab;
    getWhichTabIsExpanded();
  }

  bool isExpansionOpen() => isDetailsExpanded || isHistoryExpanded || isOwnershipExpanded;

  void getWhichTabIsExpanded() {
    isDetailsExpanded = false;
    isHistoryExpanded = false;
    isOwnershipExpanded = false;

    switch (selectedField) {
      case TabFields.ownership:
        isOwnershipExpanded = true;
        notifyListeners();
        break;
      case TabFields.history:
        isHistoryExpanded = true;
        notifyListeners();
        break;
      case TabFields.details:
        isDetailsExpanded = true;
        notifyListeners();
        break;
      default:
        return;
    }
  }

  Future<void> updateLikeStatus({required String recipeId, required String cookBookID}) async {
    isLiking = true;
    final bool temp = likedByMe;

    // final walletAddress = accountPublicInfo.publicAddress;
    // final updateLikeStatusEither = await repository.updateLikeStatus(
    //   recipeId: recipeId,
    //   cookBookID: cookBookID,
    //   walletAddress: walletAddress,
    // );

    // if (updateLikeStatusEither.isLeft()) {
    //   LocaleKeys.something_wrong.tr().show();
    //   return;
    // }
    // likedByMe = !likedByMe;
    // isLiking = false;
    // if (temp && likesCount > 0) {
    //   likesCount = likesCount - 1;
    // } else {
    //   likesCount = likesCount + 1;
    // }
  }
}
