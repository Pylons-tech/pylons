import 'package:easy_localization/easy_localization.dart';

List kTutorialItems = [
  {
    'header': 'upload_your_ipfs'.tr(),
    'description': 'pick_the_file'.tr(),
    'image': 'assets/images/tutorial1.png'
  },
  {
    'header': 'edit_your_nft'.tr(),
    'description': 'enter_information_describing_your_nft'.tr(),
    'image': 'assets/images/tutorial2.png'
  },
  {
    'header': 'publish_your_nft'.tr(),
    'header1': 'pylons_app'.tr(),
    'description': 'once_you_enter_all'.tr(),
    'image': 'assets/images/tutorial3.png'
  },
];

/// ```PNG assets
const kShareIcon = 'assets/images/share_ic.png';
const kSaveIcon = 'assets/images/save_ic.png';
const kTooltipBalloon = 'assets/images/tooltip_balloon.png';
const kIconDenomUsd = 'assets/images/denom_usd.png';
const kIconDenomPylon = 'assets/images/denom_pylon.png';
const kIconDenomAtom = 'assets/images/denom_atom.png';
const kIconDenomEmoney = 'assets/images/denom_emoney.png';
const kIconDenomAgoric = 'assets/images/denom_agoric.png';
const kIconDenomJuno = 'assets/images/denom_juno.png';
const kIconDenomETH = 'assets/images/denom_eth.png';
const kTextFieldSingleLine = 'assets/images/text_field_single_line.png';
const kTextFieldMultiLine = 'assets/images/text_field_multi_line.png';
const kTextFieldButton = 'assets/images/text_field_button.png';
const kPreviewGradient = 'assets/images/preview_gradient.png';
const kUploadThumbnail = 'assets/images/svg/upload_thumbnail.svg';
const kVideoThumbnailRectangle = 'assets/images/video_thumbnail_rectangle.png';
const kFullScreenIcon = 'assets/images/svg/full_screen_icon.svg';
const kAlertIcon = 'assets/images/svg/i_icon.svg';

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
const kSvgView = 'assets/images/svg/view.svg';
const kAddIcon = 'assets/images/svg/add.svg';
const kSearchIcon = 'assets/images/svg/search.svg';

const kDummyImg = 'assets/images/svg/dummy_img.png';
const kVideoIcon = 'assets/images/video_icon.png';
const kViewIpfs = 'assets/images/view_ipfs.png';

const kSvgPylonsLogo = 'assets/images/svg/pylons_logo.svg';
const kSvgIpfsLogo = 'assets/images/ipfs_logo.png';
const kSvgViewIcon = 'assets/images/svg/view_icon.svg';
const kGridIcon = 'assets/images/svg/grid.svg';
const kListIcon = 'assets/images/svg/list.svg';
const kOwnerVerifiedIcon = 'assets/images/svg/verified.svg';

const String kLoadingGif = 'assets/images/gifs/loading.gif';

/// ```URL constants
const ipfsDomain = 'https://ipfs.io/ipfs';
const proxyIpfsDomain = 'https://proxy.pylons.tech/ipfs';
const kPlayStoreUrl =
    'https://play.google.com/store/apps/details?id=tech.pylons.wallet';
const kWalletIOSId = 'xyz.pylons.wallet';
const kWalletAndroidId = 'tech.pylons.wallet';
const kWalletWebLink = 'https://wallet.pylons.tech';
const kWalletDynamicLink = 'pylons.page.link';

const kEaselEmail = "easel@pylons.tech";
const kPylons = "Pylons";

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
const double TABLET_MIN_WIDTH = 600;
const int kNumberOfSeconds = 1000;
const int kSixtySeconds = 60;
const int kFileCompressQuality = 50;

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
const kPleaseWait = 'Please Wait';
const kBack = 'Back';
const String kUniversalFontFamily = "UniversalSans";

/// ```Text constants
const kPreviewNoticeText =
    'The resolution & orientation of your NFT will remain fixed as seen in the grid.';
const kPriceNoticeText =
    'You can remove an active listing or revise the price of your NFT in your Pylons wallet';
const kNameAsArtistText = 'Your name as the artist';
const kGiveNFTNameText = 'Give your NFT a name';
const kEnterArtistNameText = 'Enter artist name';
const kEnterNFTNameText = 'Enter NFT name';
const kNameShouldHaveText = 'NFT name should have';
const kCharactersOrMoreText = 'characters or more';
const kDescribeYourNftText = 'Describe your NFT';
const kEnterNFTDescriptionText = 'Enter NFT description';
const kPriceText = 'Price';
const kEnterPriceText = 'Enter price';
const kEnterEditionText = 'Enter number of editions';
const kNoOfEditionText = 'Number of editions';
const kEnterRoyaltyText = 'Enter royalty in percentage';
const kRoyaltiesText = 'Royalties';
const kRoyaltyHintText = '5%';
const kRoyaltyNoteText =
    'Percentage of all secondary market sales automatically distributed to the NFT creator';
const kRoyaltyRangeText = 'Allowed royalty is between';
const kMinIsText = 'Minimum is';
const kMaxIsTextText = 'Maximum is';
const kCharacterLimitText = 'character limit';
const kEnterMoreThanText = 'Enter more than';
const kCharactersText = 'characters';
const kMaxText = 'maximum';
const kOkText = 'Ok';
const kPylonsAppNotInstalledText =
    'Pylons app is not installed on this device. Please install Pylons app to continue';
const kClickToInstallText = 'Click here to install';
const kClickToLogInText = 'Click here to log into Pylons';
const kWelcomeToEaselText = 'Welcome to Easel,';
const kEaselDescriptionText =
    'Easel is a NFT minter that allows you to create NFTs from any mobile device!\n\nOnce you successfully upload an audio, video or image file, enter the required information and press “Publish”, your file is transformed into a NFT that is stored on the Pylons blockchain indefinitely!\n\nYou’ll be able to view your new NFT in the Easel folder located in your Pylons Wallet.';
const kCreatedByText = 'Created by';
const kNftDetailsText = 'NFT Details';
const kDescribeText = 'Describe';
const kSizeText = 'Size';
const kDurationText = 'Duration';
const kDateText = 'Date';
const kRoyaltyText = 'Royalty';
const kPreview3dModelText = 'Click here to preview\nyour selected 3D Model';
const kMintMoreText = 'Mint More';
const kGoToWalletText = 'Go to Wallet';
const kChooseNFTFormatText = 'Choose your NFT format';
const kUploadNFTText = 'Upload NFT file';
const kEditNFTText = 'Edit your NFT Details';
const kPreviewYourNFTText = 'Preview your NFT file';
const kListNftText = 'List NFT';
const kPublishNftText = 'Publish NFT';

const kSelectNFTText = 'Select NFT file';
const kDetailNftText = 'NFT Details';
const kPriceNftText = 'NFT Pricing';
const kUploadText = 'Upload';
const kEditText = 'Edit';
const kPreviewText = 'Preview';
const kListText = 'List';
const kImageText = 'Image';
const kVideoText = 'Video';
const kAudioText = 'Audio';
const k3dText = '3D';
const kPdfText = 'Pdf';
const String kThreeDText = "ThreeD";
const kGetStarted = 'Get Started';
const kContinue = 'Continue';
const kWhyAppNeeded = 'Why the app is\nneeded?        \u21E9';
const kWhyAppNeededDesc1 =
    'Your Pylons app is your gateway to the Pylons ecosystem';
const kWhyAppNeededDescSummary1 = 'Discover new NFTs, apps & adventures';
const kWhyAppNeededDesc2 = 'It makes managing your crypto easy';
const kWhyAppNeededDescSummary2 =
    'No frills. No complexities. One wallet  address for all your crypto';
const kWhyAppNeededDesc3 = 'You can always delete it if you’d like';
const kWhyAppNeededDescSummary3 =
    'No subscriptions. We don’t sell your information. We only charge a fee when you purchase a NFT';
const kPylonsAlreadyInstalled = 'Pylons already installed.';
const kTapToSelect = 'Tap to Select';
const kCloseText = 'Close';
const kUploadHint2 = '• Image, Video, 3D or Audio';
const kUploadHint3 = '• One file per upload';
const kUploadHintAll = 'GB Limit.\nOne file per upload.';
const kHintNftName = 'Bird on Shoulder';
const kHintArtistName = 'Sarah Jackson';
const kHintNftDesc =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eimod tempor incididunt ut labore et dolore magna aliquaQ. Ut enim ad minim veniam, quis nostrud exercita.';
const kHintNoEdition = '100';
const kHintPrice = '10.87';
const kHintHashtag = 'Type in';
const kHashtagsText = 'Hashtags (optional)';
const kAddText = 'Add';
const kNetworkFeeWarnText =
    'A network fee of 10% of the listed price is required for all transactions that occur on-chain';

const kRecipeCreated = 'Recipe created';
const kErrProfileNotExist = 'profileDoesNotExist';
const kErrProfileFetch = 'Error occurred while fetching wallet profile';
const kErrPickFileFetch =
    'Error occurred while uploading the file, please try again';
const kErrUpload = 'Upload error occurred';
const kErrFileNotPicked = 'Pick a file';
const kErrUnsupportedFormat = 'Unsupported format';
const kErrFileMetaParse = 'Error occurred while parsing the chosen media file:';
const kErrRecipe = 'Recipe error :';
const kErrNoStripeAccount = 'Kindly register Stripe account in wallet';
const kTryAgain = "Try again";
const kPleaseTryAgain = "Something went wrong.\n Please try again.";
const kCancel = "Cancel";
const String videoPlayerNetworkError =
    'Unable to play the video right now. Please check your internet connection and try again.';
const kChooseFifteenSecondsOfAudio =
    "Choose 15s highlight of your audio for preview";
const kUploadingThumbnailMessage = "Uploading Thumbnail";
const videoPlayerError =
    "Some Error Occurred while playing the video. Please try again later.";
const kCannotLaunchThisUrl = "Cannot launch this URL";

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

const kThumbnailFileName = "temp.jpg";

//Loader Messages
const kCompressingMessage = "Compressing Thumbnail";
const kUploadingMessage = "Uploading";
const kLoadingMessage = "Loading...";

final List<String> stepLabels = ["upload", "draft", "publish"];

final List<String> imageAllowedExts = ["png", "jpg", "jpeg", "svg", "heif"];
final List<String> audioAllowedExts = ['mp3', 'ogg', 'wav', 'aac'];

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
const String kHashtagKey = "Hashtags";

const String kDescriptionTutorial = "description";
const String kHeaderTutorial = "header";
const String kImageTutorial = "image";

const String kNoInternet = 'No internet';
const String kRecipeNotFound = 'Recipe not found';
const String kCookBookNotFound = 'Cookbook not found';

const String kNftFormat = "NFT_Format";

/// Currency ABRR
const String kEmoneyAbb = "EEUR";
const String kAGoricAbb = "run";
const String kPYLNAbbrevation = 'PYLN';
const String kStripeUSD_ABR = 'USD';
const String kAgoricAbr = "RUN";
const String kAtomAbr = "ATOM";
const String kLunaAbr = "Luna";
const String kEthereumAbr = "ETH";

const String kDefault = 'Default';

const String kMyEaselNFT = 'My Easel NFT';
const String fromKey = 'from';
const String nftKey = 'nft';
const String kErrAddAudioThumbnail = 'Error while uploading thumbnail';
const String uploadYourThumbnail = 'Kindly upload thumbnail';

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
