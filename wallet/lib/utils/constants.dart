import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle kCurrencyStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp);
TextStyle kDropdownText = TextStyle(color: AppColors.kBlack, fontSize: 13.sp, fontWeight: FontWeight.w600);
TextStyle kTransactionTitle = TextStyle(color: AppColors.kBlack, fontSize: 20.sp, fontWeight: FontWeight.w700, fontFamily: 'UniversalSans');

class AppColors {
  static Color kMainBG = const Color(0xFFF2EFEA);
  static Color kSelectedIcon = const Color(0xFF616161);
  static Color kUnselectedIcon = const Color(0xFFC4C4C4);
  static Color kTextColor = const Color(0xFF201D1D);
  static Color kButtonBuyNowColor = const Color(0xFF00FF85);

  static Color kTextBlackColor = const Color(0xFF080830);
  static Color kBlue = const Color(0xFF1212C4);

  static Color kPeach = const Color(0xFFFFB094);
  static Color kPeachDark = const Color(0xFFED8864);
  static Color kGray = const Color(0xFF7B7979);
  static Color kLightGray = const Color(0xFFB3B3B3);
  static Color kWhite = const Color(0xFFFFFFFF);
  static Color kYellow = const Color(0xffFED564);
  static Color kDarkPurple = const Color(0xff0A004A);
  static Color kDarkRed = const Color(0xffEF4421);
  static Color kDarkGreen = const Color(0xFF3A8977);
  static Color kWhite01 = const Color(0xFFFBFBFB);
  static Color kButtonColor = const Color(0xFFFFFFFF);

  static Color kUSDColor = kDarkGreen;
  static Color kPylonsColor = kDarkRed;
  static Color kAgoricColor = const Color(0xFFF3BA2F);
  static Color kEthereumColor = const Color(0xFF2F1BC8);
  static Color kEmoneyColor = const Color(0xFF4838CF);
  static Color kAtomColor = kDarkPurple;

  static Color kDarkGrey = const Color(0xFF333333);
  static Color kGreyLight = const Color.fromRGBO(219, 217, 215, 1);
  static Color kCreateWalletButtonColorDark = const Color.fromRGBO(8, 8, 48, 1);
  static Color textFieldGreyColor = const Color.fromRGBO(219, 217, 215, 1);

  static Color kBackgroundColor = const Color(0xffF2EFEA);
  static Color kCopyColor = const Color(0xffB6B6E8);
  static Color kDarkDividerColor = const Color(0xffE5E5E5);
  static Color kTradeReceiptTextColor = const Color(0xff8F8FCE);
  static Color kHashtagColor = const Color(0xFFB6B6E8);

  static Color kUserInputTextColor = const Color(0xff8D8C8C);
  static Color kSettingsUserNameColor = kBlue;
  static Color kForwardIconColor = const Color(0x331212C4);
  static Color kSwitchActiveColor = kDarkGreen;
  static Color kSwitchInactiveColor = const Color(0xffC4C4C4);
  static Color kBlack = const Color(0xff000000);
  static Color kGreenBackground = const Color(0xFF3B8978);
  static Color kPurple = const Color(0xFFBF8FCE);
  static Color kPriceTagColor = const Color(0xff3A8977);
  static Color kPayNowBackgroundGrey = const Color(0xffE5E5E5);
  static Color kSubtitleColor = const Color(0xff767676);

  static Color kTransactionGreen = const Color.fromRGBO(81, 161, 144, 1);
  static Color kTransactionRed = const Color.fromRGBO(239, 68, 33, 1);
  static Color k3DBackgroundColor = Colors.grey.shade200;
  static Color kGreyColor = const Color.fromRGBO(141, 140, 140, 1);
}

const double kIconSize = 24.0;
const double kSmallIconSize = 18.0;
const double kAppBarSize = 100.0;
const double kAppBarNormalSize = 60.0;
const int stringTrimConstantMax = 25;
const int stringTrimConstantMid = 20;
const int stringTrimConstantMin = 15;
const double pyLonToUsdConstant = 0.01;
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
  'upylon': {"name": "Pylon", "denom": "upylon", "short": "pylon", "icon": "assets/images/icons/pylons_logo_24x24.png", "faucet": true},
  'BTC': {
    "name": "Bitcoin",
    "denom": "BTC",
    "short": "BTC",
    //"icon": "assets/images/icons/bitcoin.png", // todo - get bitcoin icon
    "faucet": false
  },
  'ustripeusd': {'name': "USD", "denom": "ustripeusd", "short": "usd", "icon": "assets/images/icons/ico_usd.png"},
  'UST': {'name': "USTerra", "denom": "uusd", "short": "ust", "icon": "assets/images/icons/ico_usd.png"},
  'Juno': {'name': "Juno", "denom": "ujunox", "short": "juno", "icon": "assets/images/icons/ico_usd.png"}
};

const String kAndroidEaselInstallLink = "market://details?id=tech.pylons.easel";
const String kIOSEaselInstallLink = "https://apps.apple.com/app/id1599330426";
const String kAndroidEaselLink = "pylons://easel/open";
const String kIOSEaselLink = "pylons-easel://open";

const String kPrivacyPolicyLink = "https://www.pylons.tech/p/";
const String kUnilinkUrl = "https://wallet.pylons.tech";
const String kDeepLink = "https://pylons.page.link";
const String bigDipperBaseLink = "https://wallet.pylons.tech/";
const String packageName = "tech.pylons.wallet";
const String bundleId = "xyz.pylons.wallet";
const String kUnilinkUrl3 = "pylons://";
const String kUnilinkSender = "wallet";

const String kStripeMerchantCountry = "US";
const String kStripeMerchantDisplayName = 'Pylons';

const String kStripeLoginLinkPrefix = "https://connect.stripe.com/express/";
const String kStripeAccountLinkPrefix = "https://connect.stripe.com/express/onboarding/";
const String kStripeEditSuffix = "/edit";
const String kStripeAccountSuffix = "#/account";
const String kStripeSignoutJS =
    "const hidebutton = ()=>{  var ret=false; [...document.querySelectorAll('button')].filter(e=>e.innerHTML.toUpperCase().indexOf('SIGN OUT') > -1).forEach(button=>{button.style.display='none'; ret=true;});  setTimeout(hidebutton, 500);}; hidebutton();";

const String SOMETHING_WENT_WRONG = 'Something went wrong';
const String kDuplicateIapReceiptCode = 'error:1106';

//STRIPE ERROR STRING
const String CREATE_PAYMENTINTENT_FAILED = 'Stripe PaymentIntent Creation Failed';
const String GEN_PAYMENTRECEIPT_FAILED = 'Stripe Payment Receipt Generation Failed';
const String GEN_PAYOUTTOKEN_FAILED = 'Stripe Payout Token Generation Failed';
const String GEN_REGISTRATIONTOKEN_FAILED = 'Stripe Registration Token Generation Failed';
const String GEN_UPDATETOKEN_FAILED = 'Stripe Update Token Generation Failed';
const String GET_ACCOUNTLINK_FAILED = 'Stripe Get Connected Account Link Failed';
const String GET_LOGINLINK_FAILED = 'Stripe Get Connected Account LOGIN Link Failed';
const String PAYOUT_FAILED = 'Stripe Payout Request Failed';
const String REGISTERACCOUNT_FAILED = 'Stripe Register Connected Account Failed';
const String UPDATEACCOUNT_FAILED = 'Stripe Update Account Failed';
const String IBC_HASH_UPDATE_FAILED = 'IBC Hash Info failed';
const String PLATFORM_FAILED = 'Platform exception occured';
const String CACHE_FAILED = 'No data saved';
const String NETWORK_ERROR = 'Network Error';

/// Repository
const String SOMETHING_WRONG_FETCHING_WALLETS = "Something went wrong while fetching wallets";

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

const ANDROID_VERSION = '1.0.1+143';
const IOS_VERSION = '1.0.8+1';

const kCurrencyDecimalLength = 2;

List<Color> colorList = [AppColors.kYellow, AppColors.kBlue, AppColors.kDarkPurple, AppColors.kDarkRed, AppColors.kDarkGreen];
List<Color> colorListForPracticeTest = [
  AppColors.kYellow,
  AppColors.kDarkPurple,
  AppColors.kDarkGreen,
  AppColors.kBlue,
  AppColors.kDarkRed,
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

/// General screen
const String kSaveText = "Save";
const String kBioText = "Bio";
const String kBioHintText = "Media Artist (3D, Motiongraphics) \nCreating & Collecting NFTs";
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
const String kVietnameseText = "vietnamese";

/// Update screen
const String kAndroidAppLink = 'https://play.google.com/store/apps/details?id=tech.pylons.wallet';
const String kIOSAppLink = 'https://apps.apple.com/gb/app/cashero/id1598732789?ign-mpt=uo%3D2';

const String kRecipeId = 'Recipe ID';
const String kRecipes = 'recipes';
const String kFeedbacks = 'UserFeedbacks';
const String kLikes = 'likes';
const String kAddress = 'address';
const String kViews = 'views';
const String kView = 'view';
const String kYou = 'you';

//feedback Ids
const String kSubjectKey = 'subject';
const String kFeedbackKey = 'feedback';
const String kTimeStampKey = 'timestamp';

const String kSoldOut = 'Sold Out';

/// Trade Receipt Screen
const String kTransactionCompleteText = "View Receipt";
const String kBigDipperTransactionViewingUrl = "https://wallet.pylons.tech/transactions/";

/// languages supported
List<Map<String, dynamic>> languagesSupported = [
  {"name": "english", "flag": "🇬🇧", 'selected': false, "abbreviation": "(U.S.)", 'languageCode': 'en'},
  {"name": "russian", "flag": "🇷🇺", 'selected': false, "abbreviation": "(RU)", 'languageCode': 'ru'},
  {"name": "indonesian", "flag": "🇮🇩", 'selected': false, "abbreviation": "(IN)", 'languageCode': 'id'},
  {"name": "german", "flag": "🇩🇪", 'selected': false, "abbreviation": "(DE)", 'languageCode': 'de'},
  {"name": "korean", "flag": "🇰🇷", 'selected': false, "abbreviation": "(KO)", 'languageCode': 'ko'},
  {"name": "japanese", "flag": "🇯🇵", 'selected': false, "abbreviation": "(JA)", 'languageCode': 'ja'},
  {"name": "spanish", "flag": "🇪🇸", 'selected': false, "abbreviation": "(ES)", 'languageCode': 'es'},
  {"name": "vietnamese", "flag": "🇻🇳", 'selected': false, "abbreviation": "(VIE)", 'languageCode': 'vi'},
];

///review your nft

const String kPylonsFeeMsg = "The Pylons fee is the network fee assessed on all transactions which is equal to 10% of the listed price.";
const String kStripeAccountNotCreatedIdentifier = "onboarding";
const String kNftFormat = "NFT_Format";
const String kDuration = "Duration";
const kFileSize = "fileSize";

const String kCollapse = "  Collapse";

/// Nft viewmodel key values
const String kNftUrlKey = "NFT_URL";
const String kAppTypeKey = "App_Type";

const int kNumberOfSeconds = 1000;
const int kSixtySeconds = 60;
const int kTimeStampInt = 1000;

const int kDateConverterConstant = 1000;
const kHashtags = "Hashtags";
const kRealWorld = "real_world";

const kLOW_LOW_BALANCE_CONSTANT = "Tx error:5";

//NFT STRINGS KEYS

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
const kTxTime = "txTime";
const kTxnId = "id";
const kUTC = "UTC";

const kItemId = "id";
const kCookbookId = "cookbook_id";
const kAmount = "amount";
const kCreatedAt = "created_at";

const cookbookIdKey = "cookbookId";
const recipeIdKey = "recipeId";

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
const String kWalletAddressIdMap = "walletAddress";
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
const String kMessageKey = "Message";
const String kSuccessKey = "Success";

//ipc engine keys

const String kNftPurchaseKey = "purchase_nft";
const String kNftTradeKey = "purchase_trade";
const String kNftViewKey = "nft_view";
const String kItemIdKey = "item_id";
const String kTradeIdKey = "trade_id";
const String kLinkKey = "link";
const String kIpcEncodeMessage = "Wallet Busy: A transaction is already in progress";

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
const String kTokenKey = "token";

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

const hintTextEmail = 'x@pylons.tech';

final defaultPylonsSKUs = jsonEncode([
  {"id": "pylons_10", "bonus": "", "subtitle": "\$1.00", "pylons": "10 PYLN"},
  {"id": "pylons_35", "bonus": "(+5 Bonus)", "subtitle": "\$3.00", "pylons": "35 PYLN"},
  {"id": "pylons_60", "bonus": "(+10 Bonus)", "subtitle": "\$5.00", "pylons": "50 PYLN"}
]);

const kMaxDescription = 256;

const kOwnerViewKeyValue = "owner_view_key";
const kOwnerViewDrawerKeyValue = "ownerview_header";
const kOwnerViewBottomSheetKeyValue = "bottom_sheet";
const kKeyboardUpButtonKeyValue = "keyboard_up_button";
const kExpandedBuyButtonKeyValue = "expanded_buy_button";

Map<String, Color> denomColors = {'upylon': const Color(0xFF5252d5), 'ustripeusd': const Color(0xFF85bb65), 'uusd': const Color(0xFF85bb65)};

const String kNftName = "nftName";
const String kNftPrice = "nftPrice";
const String kNftCurrency = "nftCurrency";
const String kPaymentIntentId = "payment_intent_id";
const String kClientSecret = "clientSecret";
const String kPaymentInfos = "payment_infos";

const String kRecipeID = "recipeID";
const String kCookbookID = "cookbookID";
const String kPaymentInfosMap = "paymentInfos";
const String kItemAlreadyOwned = "itemAlreadyOwned";

class AnalyticsScreenEvents {
  static String mainLanding = "MainLandingScreen";
  static String createKey = "CreateKeyScreen";
  static String importAccount = "ImportAccountScreen";
  static String updateApp = "UpdateScreen";
  static String home = "HomeScreen";
  static String settings = "SettingsScreen";
  static String legal = "LegalScreen";
  static String recovery = "RecoveryScreen";
  static String general = "GeneralScreen";
  static String security = "SecurityScreen";
  static String payment = "PaymentScreen";
  static String practice = "PracticeScreen";
  static String recoveryPhrase = "ViewReoveryPhraseScreen";
  static String transactionHistory = "TransactionHistoryScreen";
  static String addPylon = "AddPylonsScreen";
  static String transactionDetails = "TransactionDetailsScreen";
  static String messageScreen = "MessageScreen";
  static String pdfScreen = "PdfViewScreen";
  static String localTransactionHistory = "LocalTransactionHistoryScreen";
  static String localTransactionHistoryDetail = "LocalTransactionHistoryDetailScreen";
  static String ownerView = "OwnerViewScreen";
  static String purchaseView = "PurchaseViewScreen";
  static String unknown = "UnknownScreen";
}
