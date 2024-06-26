import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/denom.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/models/picked_file_model.dart';
import 'package:easel_flutter/models/save_nft.dart';
import 'package:easel_flutter/models/storage_response_model.dart';
import 'package:easel_flutter/models/upload_progress.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/services/third_party_services/audio_player_helper.dart';
import 'package:easel_flutter/services/third_party_services/quick_node.dart';
import 'package:easel_flutter/services/third_party_services/video_player_helper.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/failure/failure.dart';
import 'package:easel_flutter/utils/file_utils_helper.dart';
import 'package:easel_flutter/widgets/audio_widget.dart';
import 'package:easel_flutter/widgets/loading_with_progress.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:media_info/media_info.dart';
import 'package:pylons_sdk/low_level.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import 'generated/locale_keys.g.dart';

typedef OnUploadProgressCallback = void Function(UploadProgress uploadProgress);

class EaselProvider extends ChangeNotifier {
  final VideoPlayerHelper videoPlayerHelper;
  final AudioPlayerHelper audioPlayerHelperForFile;
  final AudioPlayerHelper audioPlayerHelperForUrl;
  final FileUtilsHelper fileUtilsHelper;
  final Repository repository;
  final MediaInfo mediaInfo;

  EaselProvider({
    required this.videoPlayerHelper,
    required this.audioPlayerHelperForFile,
    required this.audioPlayerHelperForUrl,
    required this.fileUtilsHelper,
    required this.repository,
    required this.mediaInfo,
  });

  File? _file;
  NftFormat _nftFormat = NftFormat.supportedFormats[0];
  String _fileName = "";
  String _fileExtension = "";
  String _fileSize = "0";
  int _fileHeight = 0;
  int _fileWidth = 0;
  int _fileDuration = 0;
  String? _cookbookId;
  String _recipeId = "";
  bool stripeAccountExists = false;
  FreeDrop isFreeDrop = FreeDrop.unselected;

  Denom _selectedDenom = Denom.availableDenoms.first;
  List<Denom> supportedDenomList = [];

  late NFT _publishedNFTClicked;

  NFT get publishedNFTClicked => _publishedNFTClicked;

  bool willLoadFirstTime = true;

  bool collapsed = false;

  final StreamController<UploadProgress> _uploadProgressController = StreamController.broadcast();

  Stream<UploadProgress> get uploadProgressStream => _uploadProgressController.stream;

  void setPublishedNFTClicked(NFT nft) {
    _publishedNFTClicked = nft;
    notifyListeners();
  }

  String _publishedNFTDuration = "";

  String get publishedNFTDuration => _publishedNFTDuration;

  void setPublishedNFTDuration(String duration) {
    _publishedNFTDuration = duration;
    notifyListeners();
  }

  File? _videoThumbnail;

  File? get videoThumbnail => _videoThumbnail;

  void setVideoThumbnail(File? file) {
    _videoThumbnail = file;
    notifyListeners();
  }

  File? _pdfThumbnail;

  File? get pdfThumbnail => _pdfThumbnail;

  void setPdfThumbnail(File? file) {
    _pdfThumbnail = file;
    notifyListeners();
  }

  File? get file => _file;

  NftFormat get nftFormat => _nftFormat;

  String get fileName => _fileName;

  String get fileExtension => _fileExtension;

  String get fileSize => _fileSize;

  int get fileHeight => _fileHeight;

  int get fileDuration => _fileDuration;

  int get fileWidth => _fileWidth;

  Denom get selectedDenom => _selectedDenom;

  String get recipeId => _recipeId;

  String? get cookbookId => _cookbookId;

  TextEditingController artistNameController = TextEditingController();
  TextEditingController artNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController noOfEditionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController royaltyController = TextEditingController();
  File? _audioThumbnail;

  File? get audioThumbnail => _audioThumbnail;

  bool _isInitializedForFile = false;
  bool _isInitializedForNetwork = false;

  bool get isInitializedForFile => _isInitializedForFile;

  bool get isInitializedForNetwork => _isInitializedForNetwork;

  set setIsInitialized(bool value) {
    _isInitializedForFile = value;
    notifyListeners();
  }

  set setIsInitializedUrl(bool value) {
    _isInitializedForNetwork = value;
    notifyListeners();
  }

  List<String> hashtagsList = [];

  String currentUsername = '';

  late VideoPlayerController videoPlayerController;

  bool _isVideoLoading = true;

  bool get isVideoLoading => _isVideoLoading;

  set isVideoLoading(bool value) {
    _isVideoLoading = value;
    notifyListeners();
  }

  String _videoLoadingError = "";

  String get videoLoadingError => _videoLoadingError;

  set videoLoadingError(String value) {
    _videoLoadingError = value;
    notifyListeners();
  }

  late ValueNotifier<ProgressBarState> audioProgressNotifier;
  late ValueNotifier<ButtonState> buttonNotifier;

  void initStore() {
    _file = null;
    _nftFormat = NftFormat.supportedFormats[0];
    _fileName = "";
    _fileSize = "0";
    _fileHeight = 0;
    _fileWidth = 0;
    _fileDuration = 0;
    _recipeId = "";
    _selectedDenom = Denom.availableDenoms.first;

    artistNameController.clear();
    artNameController.clear();
    descriptionController.clear();
    noOfEditionController.clear();
    priceController.clear();
    royaltyController.clear();
    hashtagsList.clear();
    willLoadFirstTime = true;
    isFreeDrop = FreeDrop.unselected;
    collapsed = false;
    notifyListeners();
  }

  void toChangeCollapse() {
    collapsed = !collapsed;
    notifyListeners();
  }

  void initializeTextEditingControllerWithEmptyValues() {
    artistNameController.text = '';
    artNameController.text = '';
    descriptionController.text = '';
    noOfEditionController.text = '';
    priceController.text = '';
    royaltyController.text = '';
    hashtagsList.clear();
    notifyListeners();
  }

  void setTextFieldValuesDescription({String? artName, String? description, String? hashtags}) {
    artNameController.text = artName ?? "";
    descriptionController.text = description ?? "";
    if (hashtags!.isNotEmpty) {
      hashtagsList = hashtags.split(',');
    }
    notifyListeners();
  }

  void setTextFieldValuesPrice({String? royalties, String? price, String? edition, String? denom, FreeDrop? freeDrop}) {
    royaltyController.text = royalties ?? "";
    priceController.text = price ?? "";
    noOfEditionController.text = edition ?? "";
    _selectedDenom = denom != "" ? Denom.availableDenoms.firstWhere((element) => element.symbol == denom) : Denom.availableDenoms.first;
    isFreeDrop = freeDrop!;
    notifyListeners();
  }

  void updateIsFreeDropStatus(FreeDrop val) {
    isFreeDrop = val;
    notifyListeners();
  }

  void stopVideoIfPlaying() {
    if (!videoPlayerController.value.isInitialized) {
      return;
    }
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
    }
  }

  Future<void> setFormat(BuildContext context, NftFormat format) async {
    _nftFormat = format;
    notifyListeners();
  }

  Future<NftFormat?> resolveNftFormat(BuildContext context, String ext) async {
    for (final format in NftFormat.supportedFormats) {
      if (format.extensions.contains(ext)) {
        return _nftFormat = format;
      }
    }
    notifyListeners();
    return null;
  }

  /// VIDEO PLAYER FUNCTIONS
  Future<void> initializeVideoPlayerWithFile() async {
    videoLoadingError = "";
    isVideoLoading = true;
    videoPlayerHelper.initializeVideoPlayerWithFile(file: _file!);
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

  void delayLoading() {
    Future.delayed(const Duration(seconds: 2));
    isVideoLoading = false;
    notifyListeners();
  }

  Future<void> initializeVideoPlayerWithUrl({required String publishedNftUrl}) async {
    videoLoadingError = "";
    isVideoLoading = true;
    videoPlayerHelper.initializeVideoPlayerWithUrl(videoUrl: publishedNftUrl);
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

  void playVideo() {
    videoPlayerHelper.playVideo();
    notifyListeners();
  }

  void pauseVideo() {
    videoPlayerHelper.pauseVideo();
    notifyListeners();
  }

  void seekVideo(Duration position) {
    videoPlayerHelper.seekToVideo(position: position);
  }

  void disposeVideoController() {
    videoPlayerController.removeListener(() {});
    videoPlayerHelper.destroyVideoPlayer();
  }

  void setAudioThumbnail(File? file) {
    _audioThumbnail = file;
    notifyListeners();
  }

  Future initializeAudioPlayer({required String publishedNFTUrl}) async {
    audioProgressNotifier = ValueNotifier<ProgressBarState>(
      ProgressBarState(
        current: Duration.zero,
        buffered: Duration.zero,
        total: Duration.zero,
      ),
    );
    buttonNotifier = ValueNotifier<ButtonState>(ButtonState.loading);

    setIsInitializedUrl = await audioPlayerHelperForUrl.setUrl(url: publishedNFTUrl);

    if (isInitializedForNetwork) {
      audioPlayerHelperForUrl.playerStateStream().listen((playerState) {
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
            audioPlayerHelperForFile.seekAudio(position: Duration.zero);
            audioPlayerHelperForFile.pauseAudio();
        }
      });
    }
    audioPlayerHelperForUrl.positionStream().listen((position) {
      final oldState = audioProgressNotifier.value;
      audioProgressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    audioPlayerHelperForUrl.bufferedPositionStream().listen((bufferedPosition) {
      final oldState = audioProgressNotifier.value;
      audioProgressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    audioPlayerHelperForUrl.durationStream().listen((totalDuration) {
      final oldState = audioProgressNotifier.value;
      audioProgressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void playAudio({required bool forFile}) {
    if (forFile) {
      audioPlayerHelperForFile.playAudio();
    } else {
      audioPlayerHelperForUrl.playAudio();
    }
  }

  void pauseAudio({required bool forFile}) {
    if (forFile) {
      audioPlayerHelperForFile.pauseAudio();
    } else {
      audioPlayerHelperForUrl.pauseAudio();
    }
  }

  void seekAudio(Duration position, {required bool forFile}) {
    if (forFile) {
      audioPlayerHelperForFile.seekAudio(position: position);
    } else {
      audioPlayerHelperForUrl.seekAudio(position: position);
    }
  }

  Future<void> disposeAudioController() async {
    audioProgressNotifier = ValueNotifier<ProgressBarState>(
      ProgressBarState(
        current: Duration.zero,
        buffered: Duration.zero,
        total: Duration.zero,
      ),
    );
    buttonNotifier = ValueNotifier<ButtonState>(ButtonState.loading);
    audioPlayerHelperForFile.destroyAudioPlayer();
  }

  void initializePlayers({required NFT publishedNFT}) {
    switch (publishedNFT.assetType.toAssetTypeEnum()) {
      case AssetType.Audio:
        initializeAudioPlayer(publishedNFTUrl: publishedNFT.url.changeDomain());
        break;
      case AssetType.Image:
        break;
      case AssetType.Video:
        initializeVideoPlayerWithUrl(publishedNftUrl: publishedNFT.url.changeDomain());
        break;

      default:
        break;
    }
  }

  bool isPylonsInstalled = false;

  Future<void> populateUserName() async {
    isPylonsInstalled = await PylonsWallet.instance.exists();
    if (currentUsername.isEmpty) {
      final String savedArtistName = repository.getArtistName();

      currentUsername = savedArtistName;
    }
    notifyListeners();
  }

  Future<void> setFile({required String filePath, required String fileName}) async {
    _file = File(filePath);
    _fileName = fileName;
    _fileSize = repository.getFileSizeString(fileLength: _file!.lengthSync());
    _fileExtension = repository.getExtension(_fileName);
    await _getMetadata(_file!);
    notifyListeners();
  }

  /// get media attributes (width/height/duration) of the file
  /// input [file] and sets [_fileHeight], [_fileWidth], and [_fileDuration]
  Future<void> _getMetadata(File file) async {
    if (_nftFormat.format == NFTTypes.pdf || _nftFormat.format == NFTTypes.threeD) {
      return;
    }

    final Map<String, dynamic> info;

    try {
      info = await mediaInfo.getMediaInfo(file.path);
    } on PlatformException {
      _fileWidth = 0;
      _fileHeight = 0;
      _fileDuration = 0;
      return;
    }

    switch (_nftFormat.format) {
      case NFTTypes.image:
        _fileWidth = info['width'] as int;
        _fileHeight = info['height'] as int;
        break;
      case NFTTypes.video:
      case NFTTypes.audio:
        _fileDuration = info['durationMs'] as int;
        break;
      case NFTTypes.threeD:
        break;
      case NFTTypes.pdf:
        break;
    }
  }

  void setSelectedDenom(Denom value) {
    _selectedDenom = value;
    notifyListeners();
  }

  /// send createCookBook tx message to the wallet app
  /// return true or false depending on the response from the wallet app
  Future<bool> createCookbook() async {
    _cookbookId = await repository.autoGenerateCookbookId();
    final cookBook1 = Cookbook(
      creator: "",
      id: _cookbookId,
      name: cookbookName,
      description: cookbookDesc,
      developer: artistNameController.text,
      version: kVersionCookboox,
      supportEmail: supportedEmail,
      enabled: true,
    );

    final response = await PylonsWallet.instance.txCreateCookbook(cookBook1);
    if (response.success) {
      repository.saveCookBookGeneratorUsername(currentUsername);
      return true;
    }

    navigatorKey.showMsg(message: response.error);
    return false;
  }

  void saveArtistName(String name) {
    repository.saveArtistName(name);
  }

  void toCheckSavedArtistName() {
    final String savedArtistName = repository.getArtistName();

    if (savedArtistName.isNotEmpty) {
      artistNameController.text = savedArtistName;
      notifyListeners();
      return;
    }
    artistNameController.text = currentUsername;
    notifyListeners();
  }

  bool showStripeDialog() => !stripeAccountExists && _selectedDenom.symbol == kUsdSymbol && isFreeDrop == FreeDrop.no;

  /// sends a createRecipe Tx message to the wallet
  /// return true or false depending on the response from the wallet app
  Future<bool> createRecipe({required NFT nft}) async {
    final scaffoldMessengerState = navigatorKey.getState();
    // get device cookbook id
    _cookbookId = repository.getCookbookId();
    final String savedUserName = repository.getCookBookGeneratorUsername();

    if (_cookbookId == null || isDifferentUserName(savedUserName)) {
      // create cookbook
      final isCookBookCreated = await createCookbook();

      if (isCookBookCreated) {
        // this delay is added to wait the transaction is settle
        // on the blockchain
        Future.delayed(const Duration(milliseconds: 800));
        // get device cookbook id
        _cookbookId = repository.getCookbookId();
        notifyListeners();
      } else {
        return false;
      }
    }

    _recipeId = repository.autoGenerateEaselId();

    disposePlayers(assetType: nft.assetType);

    final String tradePercentage = BigInt.from(int.parse(nft.tradePercentage.trim()) * kRoyaltyPrecision).toString();

    final String price = isFreeDrop == FreeDrop.yes ? "0" : _selectedDenom.formatAmount(price: priceController.text);

    final recipe = nft.createRecipe(
      cookbookId: _cookbookId!,
      recipeId: _recipeId,
      hashtagsList: hashtagsList,
      isFreeDrop: isFreeDrop,
      symbol: _selectedDenom.symbol,
      tradePercentage: tradePercentage,
      price: price,
    );

    final response = await PylonsWallet.instance.txCreateRecipe(recipe, requestResponse: false);

    if (!response.success) {
      scaffoldMessengerState?.show(message: "$kErrRecipe ${response.error}");
      return false;
    }
    scaffoldMessengerState?.show(message: LocaleKeys.recipe_created.tr());
    final nftFromRecipe = NFT.fromRecipe(recipe);
    GetIt.I.get<CreatorHubViewModel>().updatePublishedNFTList(nft: nftFromRecipe);
    deleteNft(nft.id);
    return true;
  }

  bool isDifferentUserName(String savedUserName) => currentUsername.isNotEmpty && savedUserName != currentUsername;

  Future<void> shareNFT(Size size) async {
    final String url = repository.generateEaselLinkForShare(
      cookbookId: _cookbookId ?? '',
      recipeId: _recipeId,
    );
    Share.share(
      "$kMyEaselNFT\n\n$url",
      subject: kMyEaselNFT,
      sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
    );
  }

  Future<void> onVideoThumbnailPicked() async {
    videoPlayerController.pause();
    final pickedFile = await repository.pickFile(NftFormat.supportedFormats[0]);

    final result = pickedFile.getOrElse(
      () => PickedFileModel(
        path: "",
        fileName: "",
        extension: "",
      ),
    );

    if (result.path.isEmpty) return;
    setVideoThumbnail(File(result.path));
  }

  Future<void> onPdfThumbnailPicked() async {
    final pickedFile = await repository.pickFile(NftFormat.supportedFormats[0]);

    final result = pickedFile.getOrElse(
      () => PickedFileModel(
        path: "",
        fileName: "",
        extension: "",
      ),
    );

    if (result.path.isEmpty) return;
    setPdfThumbnail(File(result.path));
  }

  void populateCoinsIfPylonsNotExists() {
    supportedDenomList = Denom.availableDenoms;

    if (supportedDenomList.isNotEmpty) {
      _selectedDenom = supportedDenomList.first;
    }
  }

  @override
  void dispose() {
    artistNameController.dispose();
    artNameController.dispose();
    descriptionController.dispose();
    noOfEditionController.dispose();
    royaltyController.dispose();
    super.dispose();
  }

  Future<SDKIPCResponse<Profile>> getProfile() async {
    final sdkResponse = await PylonsWallet.instance.getProfile();

    if (sdkResponse.success) {
      currentUsername = sdkResponse.data!.username;
      stripeAccountExists = sdkResponse.data!.stripeExists;

      supportedDenomList = Denom.availableDenoms.where((Denom e) => sdkResponse.data!.supportedCoins.contains(e.symbol)).toList();

      if (supportedDenomList.isNotEmpty && selectedDenom.symbol.isEmpty) {
        _selectedDenom = supportedDenomList.first;
      }
    }
    artistNameController.text = currentUsername;
    notifyListeners();

    return sdkResponse;
  }

  Future initializeAudioPlayerForFile({required File file}) async {
    audioProgressNotifier = ValueNotifier<ProgressBarState>(
      ProgressBarState(
        current: Duration.zero,
        buffered: Duration.zero,
        total: Duration.zero,
      ),
    );

    buttonNotifier = ValueNotifier<ButtonState>(ButtonState.loading);
    if (_file == null) {
      LocaleKeys.error_playing_audio.tr().show();
      return;
    }
    setIsInitialized = await audioPlayerHelperForFile.setFile(file: _file!.path);

    if (isInitializedForFile) {
      audioPlayerHelperForFile.playerStateStream().listen((event) {}).onData((playerState) async {
        final isPlaying = playerState.playing;
        final processingState = playerState.processingState;

        switch (processingState) {
          case ProcessingState.idle:
            await audioPlayerHelperForFile.setFile(file: _file!.path);
            break;
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
            audioPlayerHelperForFile.seekAudio(position: Duration.zero);
            audioPlayerHelperForFile.pauseAudio();
        }
      });
    }
    audioPlayerHelperForFile.positionStream().listen((event) {}).onData((position) {
      final oldState = audioProgressNotifier.value;
      audioProgressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    audioPlayerHelperForFile.bufferedPositionStream().listen((event) {}).onData((bufferedPosition) {
      final oldState = audioProgressNotifier.value;
      audioProgressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });
    audioPlayerHelperForFile.durationStream().listen((event) {}).onData((totalDuration) {
      final oldState = audioProgressNotifier.value;
      audioProgressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  File getThumbnailType(NFTTypes format) {
    switch (format) {
      case NFTTypes.audio:
        return audioThumbnail!;
      case NFTTypes.video:
        return videoThumbnail!;
      case NFTTypes.pdf:
        return pdfThumbnail!;
      default:
        return File("");
    }
  }

  bool isThumbnailPresent() => nftFormat.format == NFTTypes.audio || nftFormat.format == NFTTypes.video || nftFormat.format == NFTTypes.pdf;

  Future<bool> saveNftLocally(UploadStep step) async {
    final scaffoldMessengerOptionalState = navigatorKey.getState();

    if (nftFormat.format == NFTTypes.audio) {
      audioPlayerHelperForFile.pauseAudio();
    }

    if (nftFormat.format == NFTTypes.video) {
      videoPlayerController.pause();
    }

    int id = 0;
    if (!_file!.existsSync()) {
      navigatorKey.currentState!.overlay!.context.show(message: LocaleKeys.err_pick_file.tr());
      return false;
    }
    final loading = LoadingProgress()..showLoadingWithProgress(message: LocaleKeys.uploading.tr());

    initializeTextEditingControllerWithEmptyValues();
    StorageResponseModel uploadThumbnailResponse = StorageResponseModel.initial();

    if (isThumbnailPresent()) {
      final uploadResponse = await repository.uploadFile(
        file: getThumbnailType(nftFormat.format),
        onUploadProgressCallback: (value) {},
      );
      if (uploadResponse.isLeft()) {
        loading.dismiss();
        LocaleKeys.something_wrong_while_uploading.tr().show();
        return false;
      }
      uploadThumbnailResponse = uploadResponse.getOrElse(() => StorageResponseModel.initial());
    }

    final shouldUploadToQuickNode = QuickNode.listOfQuickNodeAllowedExtension().contains(fileExtension.toLowerCase());

    Either<Failure, StorageResponseModel> response;

    if (!shouldUploadToQuickNode) {
      response = await repository.uploadFile(
        file: _file!,
        onUploadProgressCallback: (value) {
          _uploadProgressController.sink.add(value);
        },
      );
    } else {
      response = await repository.uploadFileUsingQuickNode(
        uploadIPFSInput: UploadIPFSInput(fileName: fileName, filePath: file!.path, contentType: QuickNode.getContentType(fileExtension)),
        onUploadProgressCallback: (value) {
          _uploadProgressController.sink.add(value);
        },
      );
    }

    if (response.isLeft()) {
      loading.dismiss();
      LocaleKeys.something_wrong_while_uploading.tr().show();
      return false;
    }
    final fileUploadResponse = response.getOrElse(() => StorageResponseModel.initial());
    loading.dismiss();

    nft = NFT(
      type: NftType.TYPE_ITEM.name,
      ibcCoins: IBCCoins.upylon.name,
      assetType: nftFormat.format.getTitle(),
      cookbookID: cookbookId ?? "",
      width: fileWidth.toString(),
      creator: repository.getArtistName(),
      tradePercentage: royaltyController.text,
      height: fileHeight.toString(),
      duration: fileDuration.toString(),
      fileExtension: _fileExtension,
      description: descriptionController.text,
      fileSize: _fileSize,
      recipeID: recipeId,
      fileName: _file!.path.split("/").last,
      cid: fileUploadResponse.value?.cid ?? "",
      step: step.name,
      thumbnailUrl: (isThumbnailPresent()) ? "$ipfsDomain/${uploadThumbnailResponse.value?.cid}" : "",
      name: artistNameController.text,
      url: "$ipfsDomain/${fileUploadResponse.value?.cid}",
      price: priceController.text,
      dateTime: DateTime.now().millisecondsSinceEpoch,
    );

    final saveNftResponse = await repository.saveNft(nft);

    if (saveNftResponse.isLeft()) {
      scaffoldMessengerOptionalState?.show(message: LocaleKeys.save_error.tr());

      return false;
    }

    id = saveNftResponse.getOrElse(() => 0);

    final NFT newNFT = NFT(
      id: id,
      type: NftType.TYPE_ITEM.name,
      ibcCoins: IBCCoins.upylon.name,
      assetType: nftFormat.format.getTitle(),
      cookbookID: cookbookId ?? "",
      width: fileWidth.toString(),
      tradePercentage: royaltyController.text,
      height: fileHeight.toString(),
      duration: fileDuration.toString(),
      description: descriptionController.text,
      recipeID: recipeId,
      step: step.name,
      fileName: _file!.path.split("/").last,
      fileExtension: fileExtension,
      cid: fileUploadResponse.value?.cid ?? "",
      thumbnailUrl: (isThumbnailPresent()) ? "$ipfsDomain/${uploadThumbnailResponse.value?.cid}" : "",
      name: artistNameController.text,
      url: "$ipfsDomain/${fileUploadResponse.value?.cid}",
      price: priceController.text,
    );

    if (id < 1) {
      LocaleKeys.save_error.tr().show();
      return false;
    }
    repository.setCacheDynamicType(key: nftKey, value: newNFT);
    setAudioThumbnail(null);

    setVideoThumbnail(null);

    return true;
  }

  Future<bool> updateNftFromDescription(int id) async {
    final scaffoldMessengerState = navigatorKey.getState();
    String hashtags = "";
    if (hashtagsList.isNotEmpty) {
      hashtags = hashtagsList.join(',');
    }
    final SaveNft saveNftForDescription = SaveNft(
      id: id,
      nftDescription: descriptionController.text,
      nftName: artNameController.text,
      creatorName: artistNameController.text,
      step: UploadStep.descriptionAdded.name,
      hashtags: hashtags,
      dateTime: DateTime.now().millisecondsSinceEpoch,
    );
    final saveNftResponse = await repository.updateNftFromDescription(saveNft: saveNftForDescription);

    final nftResult = await repository.getNft(id);
    final dataFromLocal = nftResult.getOrElse(() => nft);
    repository.setCacheDynamicType(key: nftKey, value: dataFromLocal);
    if (saveNftResponse.isLeft()) {
      scaffoldMessengerState?.show(message: LocaleKeys.save_error.tr());

      return false;
    }

    return saveNftResponse.getOrElse(() => false);
  }

  Future<bool> updateNftFromPrice(int id) async {
    final navigatorState = navigatorKey.getState();

    final SaveNft saveNftForPrice = SaveNft(
      id: id,
      tradePercentage: royaltyController.text,
      price: priceController.text,
      quantity: noOfEditionController.text,
      step: UploadStep.priceAdded.name,
      denomSymbol: isFreeDrop == FreeDrop.yes ? "" : selectedDenom.symbol,
      isFreeDrop: isFreeDrop,
      dateTime: DateTime.now().millisecondsSinceEpoch,
    );
    final saveNftResponse = await repository.updateNftFromPrice(saveNft: saveNftForPrice);

    final nftResult = await repository.getNft(id);
    final dataFromLocal = nftResult.getOrElse(() => nft);
    repository.setCacheDynamicType(key: nftKey, value: dataFromLocal);
    if (saveNftResponse.isLeft()) {
      navigatorState?.show(message: LocaleKeys.save_error.tr());
      return false;
    }
    return saveNftResponse.getOrElse(() => false);
  }

  Future<void> deleteNft(int? id) async {
    if (id == null) return;
    await repository.deleteNft(id);
  }

  void toHashtagList(String hashtag) {
    hashtagsList = hashtag.split(kHashtagSymbol);
  }

  void disposePlayers({required String assetType}) {
    if (assetType == AssetType.Audio.name) {
      setAudioThumbnail(null);
      audioPlayerHelperForFile.pauseAudio();
      audioPlayerHelperForUrl.pauseAudio();
      return;
    }

    if (assetType == AssetType.Video.name) {
      setVideoThumbnail(null);
      videoPlayerController.dispose();
      return;
    }
  }

  void setLog({required String screenName}) {
    repository.logUserJourney(screenName: screenName);
  }

  late NFT nft;
  bool isUrlLoaded = false;
}

enum ButtonState { paused, playing, loading }
