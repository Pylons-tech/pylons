const double tabletMinWidth = 600;
const int kSplashScreenDuration = 3;
const String kUniversalFontFamily = "UniversalSans";
const int kPageAnimationTimeInMillis = 300;
const kDraft = "Draft";

final List<String> stepLabels = ["overview", "detail", "perks", "price"];

/// ```SVG assets
class SVGUtils {
  static const kSvgSplash = 'assets/images/svg/splash.svg';
  static const kSvgUpload = "assets/images/svg/upload.svg";

}

/// ```PNG assets
class PngUtils {
  static const kTextFieldSingleLine = 'assets/images/text_field_single_line.png';
  static const kTextFieldMultiLine = 'assets/images/text_field_multi_line.png';
}
