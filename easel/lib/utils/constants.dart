import 'package:easy_localization/easy_localization.dart';

List kTutorialItems = [
  {'header': 'upload_your_ipfs'.tr(), 'description': 'pick_the_file'.tr(), 'image': 'assets/images/tutorial1.png'},
  {'header': 'edit_your_nft'.tr(), 'description': 'enter_information_describing_your_nft'.tr(), 'image': 'assets/images/tutorial2.png'},
  {'header': 'publish_your_nft'.tr(), 'header1': 'pylons_app'.tr(), 'description': 'once_you_enter_all'.tr(), 'image': 'assets/images/tutorial3.png'},
];

/// ```PNG assets
class PngUtils {
  static const kShareIcon = 'assets/images/share_ic.png';
  static const kSaveIcon = 'assets/images/save_ic.png';
  static const kTooltipBalloon = 'assets/images/tooltip_balloon.png';
  static const kIconDenomUsd = 'assets/images/denom_usd.png';
  static const kIconDenomPylon = 'assets/images/denom_pylon.png';
  static const kIconDenomAtom = 'assets/images/denom_atom.png';
  static const kIconDenomEmoney = 'assets/images/denom_emoney.png';
  static const kIconDenomAgoric = 'assets/images/denom_agoric.png';
  static const kIconDenomJuno = 'assets/images/denom_juno.png';
  static const kIconDenomETH = 'assets/images/denom_eth.png';
  static const kTextFieldSingleLine = 'assets/images/text_field_single_line.png';
  static const kTextFieldMultiLine = 'assets/images/text_field_multi_line.png';
  static const kTextFieldButton = 'assets/images/text_field_button.png';
  static const kPreviewGradient = 'assets/images/preview_gradient.png';
  static const kUploadThumbnail = 'assets/images/svg/upload_thumbnail.svg';
  static const kVideoThumbnailRectangle = 'assets/images/video_thumbnail_rectangle.png';
  static const kFullScreenIcon = 'assets/images/svg/full_screen_icon.svg';
  static const kAlertIcon = 'assets/images/svg/i_icon.svg';
}

/// ```SVG assets
const kSvgSplash = 'assets/images/svg/splash.svg';
const kSvgTabSplash = 'assets/images/svg/background_tab.svg';
const kSplashTabEasel = 'assets/images/svg/easel_tab.svg';
const kSplashNFTCreatorTab = 'assets/images/svg/nft_creator_tab.svg';
const kSvgRectBlue = 'assets/images/svg/rectangular_button_blue.svg';
const kSvgRectRed = 'assets/images/svg/rectangular_button_red.svg';
const kSvgDashedBox = 'assets/images/svg/dashed_box.svg';
const kSvgFileUpload = 'assets/images/svg/file_upload.svg';
const kSvgUploadErrorBG = 'assets/images/svg/upload_error_background.svg';
const kSvgCloseIcon = 'assets/images/svg/close_icon.svg';
const kSvgCloseButton = 'assets/images/svg/close_button.svg';
const kSvgNftFormatImage = 'assets/images/svg/nft_format_image.svg';
const kSvgForwardArrowIcon = 'assets/images/svg/forward_arrow.svg';
const kSvgNftFormatVideo = 'assets/images/svg/nft_format_video.svg';
const kSvgNftFormat3d = 'assets/images/svg/nft_format_3d.svg';
const kSvgNftFormatAudio = 'assets/images/svg/nft_format_audio.svg';
const kSvgMoreOption = 'assets/images/svg/more_options.svg';
const kSvgPublish = 'assets/images/svg/publish.svg';
const kSvgDelete = 'assets/images/svg/delete.svg';
const kAddIcon = 'assets/images/svg/add.svg';
const kSearchIcon = 'assets/images/svg/search.svg';

const kDummyImg = 'assets/images/svg/dummy_img.png';
const kVideoIcon = 'assets/images/video_icon.png';

const kSvgPylonsLogo = 'assets/images/svg/pylons_logo.svg';
const kSvgIpfsLogo = 'assets/images/ipfs_logo.png';
const kGridIcon = 'assets/images/svg/grid.svg';
const kListIcon = 'assets/images/svg/list.svg';
const kOwnerVerifiedIcon = 'assets/images/svg/verified.svg';

const String kLoadingGif = 'assets/images/gifs/loading.gif';

/// ```URL constants
const ipfsDomain = 'https://ipfs.io/ipfs';
const proxyIpfsDomain = 'https://proxy.pylons.tech/ipfs';
const kPlayStoreUrl = 'https://play.google.com/store/apps/details?id=tech.pylons.wallet';
const kWalletIOSId = 'xyz.pylons.wallet';
const kWalletAndroidId = 'tech.pylons.wallet';
const kWalletWebLink = 'https://wallet.pylons.tech';
const kWalletDynamicLink = 'pylons.page.link';

const kEaselEmail = "easel@pylons.tech";
const kPylons = "Pylons";
const kNFTName = "Nft Name";
const k3dFileName = "temp_three_d";

/// ```Number constants
const kMinNFTName = 9;
const kMinDescription = 20;
const kMinValue = 0.01;
const kMinEditionValue = 1;
const kMaxDescription = 256;
const kMaxEdition = 10000;
const kMinRoyalty = 0;
const kMaxRoyalty = 99.99;
const kFileSizeLimitInGB = 32;
const kFileSizeLimitForAudiVideoInGB = 0.2;
const kMaxPriceLength = 14;
const kSecInMillis = 1000;
const double tabletMinWidth = 600;
const int kNumberOfSeconds = 1000;
const int kSixtySeconds = 60;
const int kFileCompressQuality = 50;
const int kSplashScreenDuration = 3;
const double kPrecision = 100000000000000000;
const double kRoyaltyPrecision = 10000000000000000;

const int kBigIntBase = 1000000;
const int kEthIntBase = 1000000000000000000;

const suffixes = ["B", "KB", "MB", "GB", "TB"];

/// ````Reserved words, symbols, IDs etc
const kCookbookId = 'cookbook_id';
const kUsername = 'username';
const kArtistName = 'artistName';

const kPylonSymbol = 'upylon';
const kUsdSymbol = 'ustripeusd';
const kAtomSymbol = 'uatom';
const kEuroSymbol = 'eeur';
const kAgoricSymbol = 'urun';
const kJunoSymbol = 'ujunox';
const String kEthereumSymbol = "weth-wei";

const kPylonText = 'Pylon';
const kUSDText = 'USD';
const kAtomText = 'Atom';
const kEurText = 'EEur';
const kAgoricText = 'Agoric';
const kJunoText = 'Juno';
const kEthereum = "Ethereum";
const kNone = 'None';
const kBack = 'Back';
const String kUniversalFontFamily = "UniversalSans";

/// ```Text constants

const kRoyaltyHintText = '5%';

const kImageText = 'Image';
const kVideoText = 'Video';
const kAudioText = 'Audio';
const k3dText = '3D';
const kPdfText = 'Pdf';
const String kThreeDText = "ThreeD";
const kWhyAppNeeded = 'Why the app is\nneeded?        \u21E9';

const kUploadHint2 = '• Image, Video, 3D or Audio';

const kErrProfileNotExist = 'profileDoesNotExist';

const kErrRecipe = 'Recipe error :';

//NFT STRINGS KEYS
const kResidual = "Residual";
const kQuantity = "Quantity";
const kWidth = "Width";
const kHeight = "Height";
const kName = "Name";
const kAppType = "App_Type";
const kDescription = "Description";
const kHashtags = "Hashtags";
const kNFTFormat = "NFT_Format";
const kNFTURL = "NFT_URL";
const kCreator = "Creator";
const kCID = "cid";
const kThumbnailUrl = "Thumbnail_URL";
const kEasel = "Easel";
const kEaselNFT = "Easel_NFT";
const kUpylon = "upylon";
const kExtraInfo = "extraInfo";
const kDuration = "Duration";
const kFileSize = "fileSize";
const kRealWorld = "real_world";

const kThumbnailFileName = "temp.jpg";

final List<String> stepLabels = ["upload", "detail", "price   "];

final List<String> imageAllowedExts = ["png", "jpg", "jpeg", "svg", "heif", "gif"];
final List<String> audioAllowedExts = ['mp3', 'ogg', 'wav', 'aac'];
final List<String> threedAllowedExts = ['gltf', 'glb'];

/// Nft viewmodel key values
const String kNameKey = "Name";
const String kNftUrlKey = "NFT_URL";
const String kNftFormatKey = "NFT_Format";
const String kSizeKey = "Size";
const String kDescriptionKey = "Description";
const String kCreatorKey = "Creator";
const String kAppTypeKey = "App_Type";
const String kWidthKey = "Width";
const String kHeightKey = "Height";
const String kQuantityKey = "Quantity";

const String kDescriptionTutorial = "description";
const String kHeaderTutorial = "header";
const String kImageTutorial = "image";

const String kNftFormat = "NFT_Format";

/// Currency ABRR
const String kEmoneyAbb = "EEUR";
const String kAGoricAbb = "run";
const String kPYLNAbbrevation = 'PYLN';
const String kStripeUSDABR = 'USD';
const String kAgoricAbr = "RUN";
const String kAtomAbr = "ATOM";
const String kLunaAbr = "Luna";
const String kEthereumAbr = "ETH";

const String kDefault = 'Default';

const String kMyEaselNFT = 'My Easel NFT';
const String fromKey = 'from';
const String nftKey = 'nft';

/// Supported Formats

const mp3 = "mp3";
const ogg = "ogg";
const wav = "wav";
const aac = "aac";

const kDraft = "Draft";

const kVersion = "v0.1.0";

const supportedEmail = "support@pylons.tech";
const cookbookDesc = "Cookbook for Easel NFT";
const cookbookName = "Easel Cookbook";
const kVersionCookboox = "v0.0.1";
const kHashtagSymbol = "#";
const String costPerBlock = '0';
const String transferFeeAmount = '1';

const int kPageAnimationTimeInMillis = 300;

const kAmvKey = "amv";
const kApnKey = "apn";
const kIbiKey = "ibi";
const kImvKey = "imv";
const kLinkKey = "link";

const kTwelve = 12;

const one = 1;

const kSaveAsDraftDescKey = "Save_as_draft_decs_key";
const kSaveAsDraftPriceKey = "Save_as_draft_price_key";
const kSaveAsDraftPublishKey = "Save_as_draft_publish_key";
const kGridViewTileNFTKey = "GridViewTileNFTKey";
const kPublishTextKey = "publish";
const kPublishButtonKey = "publish_button_key";

class AnalyticsScreenEvents {
  static String tutorialScreen = "TutorialScreen";
  static String publishScreen = "PublishScreen";
  static String priceScreen = "PriceScreen";
  static String previewScreen = "PreviewScreen";
  static String createrHubScreen = "CreaterHubScreen";
  static String describeScreen = "DescribeScreen";
  static String chooseFormatScreen = "ChooseFormatScreen";

}
