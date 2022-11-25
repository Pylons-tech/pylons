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
 OwnerViewViewModel({
    required this.repository,
    // required this.accountPublicInfo,
    // required this.walletsStore,
    required this.audioPlayerHelper,
    // required this.shareHelper,
    required this.videoPlayerHelper,
    // required this.accountPublicInfo,
  });

  late NFT _nft;
  bool _isLiking = true;
  bool likedByMe = false;

  bool _collapsed = true;
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

  bool get collapsed => _collapsed;

  set collapsed(bool value) {
    _collapsed = value;
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
    _collapsed = !_collapsed;
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

}
