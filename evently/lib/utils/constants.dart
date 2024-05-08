const double tabletMinWidth = 600;
const int kSplashScreenDuration = 3;
const String kUniversalFontFamily = "UniversalSans";
const int kPageAnimationTimeInMillis = 300;
const kDraft = "Draft";

final List<String> stepLabels = ["overview", "detail", "perks", "price"];

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

const kMaxPriceLength = 14;
const int kBigIntBase = 1000000;
const int kEthIntBase = 1000000000000000000;

/// ```SVG assets
class SVGUtils {
  static const kSvgSplash = 'assets/images/svg/splash.svg';
  static const kSvgUpload = "assets/images/svg/upload.svg";
  static const kShirt = "assets/images/svg/shirt.svg";
  static const kGift = "assets/images/svg/gift.svg";
  static const kDrinks = "assets/images/svg/drinks.svg";
  static const kMinus = "assets/images/svg/minus.svg";
  static const kDiamond = "assets/images/svg/diamond.svg";
}

/// ```PNG assets
class PngUtils {
  static const kTextFieldSingleLine = 'assets/images/text_field_single_line.png';
  static const kTextFieldMultiLine = 'assets/images/text_field_multi_line.png';
  static const kDarkPurpleSingleLine = 'assets/images/svg/dark_purple_single_line.png';
  static const kLightPurpleSingleLine = 'assets/images/svg/light_purple_single_line.png';
  static const kTextFieldButton = 'assets/images/text_field_button.png';
  static const kIconDenomUsd = 'assets/images/denom_usd.png';
  static const kIconDenomPylon = 'assets/images/denom_pylon.png';
  static const kHostPreview = "assets/images/host_preview.png";
  /// will remove this variable for ui dev
  /// i need this variable to be used
  static const kPhantom = "assets/images/phantom.png";
  static const kDottedLine = "assets/images/dotted_line.png";
}
