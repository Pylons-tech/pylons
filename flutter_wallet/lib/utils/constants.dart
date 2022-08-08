import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle kCurrencyStyle = TextStyle(
    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp);
TextStyle kDropdownText =
    TextStyle(color: kBlack, fontSize: 13.sp, fontWeight: FontWeight.w600);
TextStyle kTransactionTitle = TextStyle(
    color: kBlack,
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    fontFamily: 'UniversalSans');

const Color kMainBG = Color(0xFFF2EFEA);
const Color kSelectedIcon = Color(0xFF616161);
const Color kUnselectedIcon = Color(0xFFC4C4C4);
const Color kTextColor = Color(0xFF201D1D);
const Color kButtonBuyNowColor = Color(0xFF00FF85);

const Color kTextBlackColor = Color(0xFF080830);
const Color kBlue = Color(0xFF1212C4);

const Color kPeach = Color(0xFFFFB094);
const Color kPeachDark = Color(0xFFED8864);
const Color kGray = Color(0xFF7B7979);
const Color kLightGray = Color(0xFFB3B3B3);
const Color kWhite = Color(0xFFFFFFFF);
const Color kYellow = Color(0xffFED564);
const Color kDarkPurple = Color(0xff0A004A);
const Color kDarkRed = Color(0xffEF4421);
const Color kDarkGreen = Color(0xFF3A8977);
const Color kWhite01 = Color(0xFFFBFBFB);
const Color kButtonColor = Color(0xFFFFFFFF);

const Color kUSDColor = kDarkGreen;
const Color kPylonsColor = kDarkRed;
const Color kAgoricColor = Color(0xFFF3BA2F);
const Color kEthereumColor = Color(0xFF2F1BC8);
const Color kEmoneyColor = Color(0xFF4838CF);
const Color kAtomColor = kDarkPurple;

const Color kDarkGrey = Color(0xFF333333);
const Color kGreyLight = Color.fromRGBO(219, 217, 215, 1);
const Color kCreateWalletButtonColorDark = Color.fromRGBO(8, 8, 48, 1);
const Color textFieldGreyColor = Color.fromRGBO(219, 217, 215, 1);

const Color kBackgroundColor = Color(0xffF2EFEA);
const Color kCopyColor = Color(0xffB6B6E8);
const Color kDarkDividerColor = Color(0xffE5E5E5);
const Color kTradeReceiptTextColor = Color(0xff8F8FCE);
const Color kHashtagColor = Color(0xFFB6B6E8);

const Color kUserInputTextColor = Color(0xff8D8C8C);
const Color kSettingsUserNameColor = kBlue;
const Color kForwardIconColor = Color(0x331212C4);
const Color kSwitchActiveColor = kDarkGreen;
const Color kSwitchInactiveColor = Color(0xffC4C4C4);
const Color kBlack = Color(0xff000000);
const Color kGreenBackground = Color(0xFF3B8978);
const Color kPurple = Color(0xFFBF8FCE);
const Color kPriceTagColor = Color(0xff3A8977);
const Color kPayNowBackgroundGrey = Color(0xffE5E5E5);
const Color kSubtitleColor = Color(0xff767676);

const Color kTransactionGreen = Color.fromRGBO(81, 161, 144, 1);
const Color kTransactionRed = Color.fromRGBO(239, 68, 33, 1);
Color k3DBackgroundColor = Colors.grey.shade200;

const double kIconSize = 24.0;
const double kSmallIconSize = 18.0;
const double kAppBarSize = 100.0;
const double kAppBarNormalSize = 60.0;
const int stringTrimConstantMax = 25;
const int stringTrimConstantMid = 20;
const int stringTrimConstantMin = 15;
const double pyLonToUsdConstant = 0.01;
const double kPrecision = 100000000000000000;
const double kRoyaltyPrecision = 10000000000000000;
const String kPylonDenom = "upylon";

const String kUniversalFontFamily = "UniversalSans";
const String kENV = 'ENV';
const String kLocal = 'local';
const String kPylo = 'pylo';

const String kPylonCoinName = "pylon";
const String kUSDDenom = "ustripeusd";
const String kUSD = "stripeusd";
const String kUSDCoinName = "usd";
const int kBigIntBase = 1000000;
const int kEthIntBase = 1000000000000000000;
const int kDenomInitial = 1;
const int kDenomFinal = 4;

const Map<String, dynamic> kCoinDenom = {
  'upylon': {
    "name": "Pylon",
    "denom": "upylon",
    "short": "pylon",
    "icon": "assets/images/icons/pylons_logo_24x24.png",
    "faucet": true
  },
  'BTC': {
    "name": "Bitcoin",
    "denom": "BTC",
    "short": "BTC",
    //"icon": "assets/images/icons/bitcoin.png", // todo - get bitcoin icon
    "faucet": false
  },
  'ustripeusd': {
    'name': "USD",
    "denom": "ustripeusd",
    "short": "usd",
    "icon": "assets/images/icons/ico_usd.png"
  },
  'UST': {
    'name': "USTerra",
    "denom": "uusd",
    "short": "ust",
    "icon": "assets/images/icons/ico_usd.png"
  },
  'Juno': {
    'name': "Juno",
    "denom": "ujunox",
    "short": "juno",
    "icon": "assets/images/icons/ico_usd.png"
  }
};

const String kAndroidEaselInstallLink = "market://details?id=tech.pylons.easel";
const String kIOSEaselInstallLink = "https://apps.apple.com/app/id1599330426";
const String kAndroidEaselLink = "pylons://easel/open";
const String kIOSEaselLink = "pylons-easel://open";

const String kPrivacyPolicyLink = "https://www.pylons.tech/p/";
const String kUnilinkUrl = "https://wallet.pylons.tech";
const String kUnilinkUrl3 = "pylons://";
const String kUnilinkSender = "wallet";

const String kStripeMerchantCountry = "US";
const String kStripeMerchantDisplayName = 'Pylons';

const String kStripeLoginLinkPrefix = "https://connect.stripe.com/express/";
const String kStripeAccountLinkPrefix =
    "https://connect.stripe.com/express/onboarding/";
const String kStripeEditSuffix = "/edit";
const String kStripeAccountSuffix = "#/account";
const String kStripeSignoutJS =
    "const hidebutton = ()=>{  var ret=false; [...document.querySelectorAll('button')].filter(e=>e.innerHTML.toUpperCase().indexOf('SIGN OUT') > -1).forEach(button=>{button.style.display='none'; ret=true;});  setTimeout(hidebutton, 500);}; hidebutton();";

const String SOMETHING_WENT_WRONG = 'Something went wrong';

//STRIPE ERROR STRING
const String CREATE_PAYMENTINTENT_FAILED =
    'Stripe PaymentIntent Creation Failed';
const String GEN_PAYMENTRECEIPT_FAILED =
    'Stripe Payment Receipt Generation Failed';
const String GEN_PAYOUTTOKEN_FAILED = 'Stripe Payout Token Generation Failed';
const String GEN_REGISTRATIONTOKEN_FAILED =
    'Stripe Registration Token Generation Failed';
const String GEN_UPDATETOKEN_FAILED = 'Stripe Update Token Generation Failed';
const String GET_ACCOUNTLINK_FAILED =
    'Stripe Get Connected Account Link Failed';
const String GET_LOGINLINK_FAILED =
    'Stripe Get Connected Account LOGIN Link Failed';
const String PAYOUT_FAILED = 'Stripe Payout Request Failed';
const String REGISTERACCOUNT_FAILED =
    'Stripe Register Connected Account Failed';
const String UPDATEACCOUNT_FAILED = 'Stripe Update Account Failed';
const String IBC_HASH_UPDATE_FAILED = 'IBC hash info getting Failed';
const String PLATFORM_FAILED = 'Platform exception occured';
const String CACHE_FAILED = 'No data saved';
const String NETWORK_ERROR = 'Network Error';

/// Repository
const String SOMETHING_WRONG_FETCHING_WALLETS =
    "Something went wrong while fetching wallets";

const String kIOSWalletId = 'xyz.pylons.wallet';
const String kAndroidId = 'tech.pylons.wallet';

const int API_SUCCESS_CODE = 200;
const int API_ERROR_CODE = 400;
const int kImageQuality = 100;
const int TABLET_MIN_LENGTH = 500;
const int kMnemonicStrength = 128;

const String kLunaAsset = 'luna';
const String kPylonsAsset = 'pylon';

const String kAgoric = "Agoric";
const String kJuno = "Juno";
const String kNone = "None";
const String kEmoney = "eMoney Euro";
const String kPylons = "Pylons";
const String kDollar = "U.S. Dollar";
const String kAtom = "ATOM";
const String kEthereum = "Ethereum";

const ANDROID_VERSION = '1.0.0+94';
const IOS_VERSION = '1.0.8+1';

const kCurrencyDecimalLength = 2;

const List<Color> colorList = [
  kYellow,
  kBlue,
  kDarkPurple,
  kDarkRed,
  kDarkGreen
];
const List<Color> colorListForPracticeTest = [
  kYellow,
  kDarkPurple,
  kDarkGreen,
  kBlue,
  kDarkRed,
];

/// Currency ABRR
const String kEmoneyAbb = "EEUR";
const String kAGoricAbb = "run";
const String kPYLN_ABBREVATION = 'PYLN';
const String kStripeUSD_ABR = 'USD';
const String kAgoricAbr = "RUN";
const String kAtomAbr = "ATOM";
const String kLunaAbr = "Luna";
const String kEthereumAbr = "ETH";
const String kEthereumSymbol = "weth-wei";
const String kDefault = 'Default';

/// Legal Screen
const String kLegalText = 'Legal';
const String kTermsOfServiceText = 'Terms of service';
const String kPrivacyPolicyText = 'Privacy policy';

/// Recovery Screen
const String kRecoveryText = 'Recovery';
const String kRecoveryPhraseText = 'Recovery Phrase';
const String kViewRecoveryPhraseText = 'View recovery phrase';
const String kPracticeTestText = 'Practice test';
const String kRecoveryMigration = 'Migrate Account';

/// Settings screen
const String kSettingsEmailAddress = "Email Address (optional)";
const String kCopy = "Copy";
const String kAlertDialogText =
    "Are you sure you want to delete your Pylons wallet from this device?";
const String kYes = "Yes";
const String kNo = "No";

/// General screen
const String kSaveText = "Save";
const String kWalletAddressText = "Wallet Address";
const String kBioText = "Bio";
const String kBioHintText =
    "Media Artist (3D, Motiongraphics) \nCreating & Collecting NFTs";
const String kStakeDigitalClaim = "Stake your digital claim";
const String kCreateWallet = "Create Wallet";
const String kRestoreWallet = "Restore Wallet";
const String kNetwork = "Network";
const String kDevNet = "devnet";
const String kTestNet = "testnet";
const String userIdKey = "userId";
const String kDataKey = "Data";
const String kTotalLikesKey = "totalLikes";
const String kTotalViewsKey = "totalViews";
const String kLikedKey = "liked";

/// General screen
const String kEnglishText = "english";
const String kRussianText = "russian";
const String kIndonesiaText = "indonesian";
const String kGermanyText = "german";
const String kKoreanText = "korean";
const String kJapanText = "japanese";
const String kSpanishText = "spanish";

/// Update screen
const String kAndroidAppLink =
    'https://play.google.com/store/apps/details?id=tech.pylons.wallet';
const String kIOSAppLink =
    'https://apps.apple.com/gb/app/cashero/id1598732789?ign-mpt=uo%3D2';

const String kRecipeId = 'Recipe ID';
const String kRecipes = 'recipes';
const String kLikes = 'likes';
const String kAddress = 'address';
const String kViews = 'views';
const String kView = 'view';
const String kYou = 'you';

const String kSoldOut = 'Sold Out';

/// Repository
const String NO_PROFILE_FOUND = 'No profile found in wallet';
const String SOMETHING_WRONG_SIGNING_TRANSACTION =
    'Something went wrong while signing transaction';
const String VIDEO_PLAYER_NETWORK_ERROR =
    'Unable to play the video right now. Please check your internet connection and try again.';

/// Trade Receipt Screen
const String kCloseText = "Close";
const String kCancelText = "Cancel";

/// Trade Receipt Screen
const String kTransactionCompleteText = "View Receipt";
const String kBigDipperTransactionViewingUrl =
    "https://wallet.pylons.tech/transactions/";

/// languages supported
List<Map<String, dynamic>> languagesSupported = [
  {
    "name": "english",
    "flag": "🇬🇧",
    'selected': false,
    "abbreviation": "(U.S.)",
    'languageCode': 'en'
  },
  {
    "name": "russian",
    "flag": "🇷🇺",
    'selected': false,
    "abbreviation": "(RU)",
    'languageCode': 'ru'
  },
  {
    "name": "indonesian",
    "flag": "🇮🇩",
    'selected': false,
    "abbreviation": "(IN)",
    'languageCode': 'id'
  },
  {
    "name": "german",
    "flag": "🇩🇪",
    'selected': false,
    "abbreviation": "(DU)",
    'languageCode': 'de'
  },
  {
    "name": "korean",
    "flag": "🇰🇷",
    'selected': false,
    "abbreviation": "(KO)",
    'languageCode': 'ko'
  },
  {
    "name": "japanese",
    "flag": "🇯🇵",
    'selected': false,
    "abbreviation": "(JA)",
    'languageCode': 'ja'
  },
  {
    "name": "spanish",
    "flag": "🇪🇸",
    'selected': false,
    "abbreviation": "(ES)",
    'languageCode': 'es'
  },
];

///review your nft

const String kPylonsFeeMsg =
    "The Pylons fee is the network fee assessed on all transactions equal to 10% of the listed price.";
const String kStripeAccountNotCreatedIdentifier = "onboarding";
const String kNftFormat = "NFT_Format";
const String kDuration = "Duration";
const kFileSize = "fileSize";

const String kCollapse = "  Collapse";

/// Nft viewmodel key values
const String kNftUrlKey = "NFT_URL";
const String kAppTypeKey = "App_Type";
const String kWidthKey = "Width";
const String kHeightKey = "Height";

const int kNumberOfSeconds = 1000;
const int kSixtySeconds = 60;
const int kTimeStampInt = 1000;

const int kDateConverterConstant = 1000;

const kHashtags = "Hashtags";

const kBuyPylonOne = "10 PYLN";
const kBuyPylonThree = "30 PYLN";
const kBuyPylonFive = "50 PYLN";
const kOneUSD = "\$1.00";
const kThreeUSD = "\$3.00";
const kFiveUSD = "\$5.00";

const kLOW_LOW_BALANCE_CONSTANT = "Tx error:5";

const kPylons1 = "pylons_10";
const kPylons3 = "pylons_35";
const kPylons5 = "pylons_60";

//NFT STRINGS KEYS
const kResidual = "Residual";
const kQuantity = "Quantity";
const kWidth = "Width";
const kHeight = "Height";
const kName = "Name";
const kAppType = "App_Type";
const kDescription = "Description";
const kNFTFormat = "NFT_Format";
const kNFTURL = "NFT_URL";
const kCreator = "Creator";
const kReload = "Reload";
const kThumbnailUrl = "Thumbnail_URL";
const kEasel = "Easel";
const kEaselNFT = "Easel_NFT";
const kUpylon = "upylon";
const kExtraInfo = "extraInfo";

const kItemId = "item_id";
const kCookbookId = "cookbook_id";
const kRecipe_id = "recipe_id";
const kSender = "sender";
const kSenderName = "sender_name";
const kReceiver = "receiver";
const kAmount = "amount";
const kCreatedAt = "created_at";

/// Assets

const kAlertIcon = "assets/images/icons/alert.svg";
const kUploadErrorIcon = "assets/images/icons/upload_error_background.svg";
const kSvgCloseButton = 'assets/images/svg/close_button.svg';
const email = "support@pylons.tech";
const mailto = "mailto";

const String k3DText = "3D";
const String kThreeDText = "ThreeD";

const String kRecipeIdMap = "recipeId";
const String kCookbookIdMap = "cookbookId";
const String FIREBASE_APP_CHECK_HEADER = "x-firebase-appcheck";

const String kDateWithTimeFormat = "MM/dd/yyyy HH:mm";
const int kMaxItemToShow = 11;
const String kHistory = "history";
const String kFirebaseLink = "https://pylons.page.link";

//transaction keys
const String kAddressKey = "address";
const String kAmountKey = "amount";
const String kCookbookIdKey = "cookbook_id";
const String kRecipeIdKey = "recipe_id";
const String kCreatedAtKey = "created_at";
const String kTypeKey = "type";
const String kTxId = "tx_id";

//ipc engine keys
const String kActionKey = "action";
const String kNftPurchaseKey = "purchase_nft";
const String kNftTradeKey = "purchase_trade";
const String kNftViewKey = "nft_view";
const String kItemIdKey = "item_id";
const String kTradeIdKey = "trade_id";
const String kLinkKey = "link";
const String kIpcEncodeMessage =
    "Wallet Busy: A transaction is already in progress";

//stripe payment receipt keys
const String kProductID = "productID";
const String kPayerAddr = "payerAddr";
const String kSignature = "signature";
const String kPurchaseID = "purchaseID";
const String kProcessorName = "processorName";
const String kPurchaseIdKey = "purchase_id";
const String kProcessorNameKey = "processor_name";
const String kPayerAddrKey = "payer_addr";
const String kProductIdKey = "product_id";

//Notification keys
const String kResultKey = "results";
const String kNftSold = "NFT Sold";
const String kSaleType = "Sale";
const String kMsgId = "_id";
const String kTxHash = "txhash";
const String kCoin = "coin";
const String kFrom = "from";
const String kItemFormat = "item_format";
const String kItemName = "item_name";
const String kItemImg = "item_img";
const String kRead = "read";
const String kSettled = "settled";
const String kTo = "to";
const String kType = "type";
const String kUpdatedAt = "updated_at";
const String kNotificationsIds = "notificationIDs";

const String kZeroDouble = "0.0";
const String kZeroInt = "0";

const ipfsDomain = 'https://ipfs.io/ipfs';
const proxyIpfsDomain = 'https://proxy.pylons.tech/ipfs';
