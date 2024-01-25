typedef OnLogError = void Function(
  dynamic exception, {
  StackTrace? stack,
  bool fatal,
});

typedef OnLogEvent = void Function(AnalyticsEventEnum event);

typedef OnLogMessage = void Function(String message);


enum AnalyticsEventEnum {
  noLink,
  chromeThrowLink,
  chromeThrowLinkParsingFailed,
  firebaseLink,
  link,
  shortLink,
  nftNotExists,
  easelLink,
  viewNFTLink,
  tradeNFTLink,
  unknownLink,
}

extension AnalyticsEventEnumExtension on AnalyticsEventEnum {
  String getEventName() {
    switch (this) {
      case AnalyticsEventEnum.noLink:
        return "No link";
      case AnalyticsEventEnum.chromeThrowLink:
        return "Chrome throw link";
      case AnalyticsEventEnum.chromeThrowLinkParsingFailed:
        return "Chrome throw link parsing failed";
      case AnalyticsEventEnum.firebaseLink:
        return "Firebase link";
      case AnalyticsEventEnum.link:
        return "Link";
      case AnalyticsEventEnum.shortLink:
        return "Short dynamic link";
      case AnalyticsEventEnum.nftNotExists:
        return "NFT doesn't exists";
      case AnalyticsEventEnum.easelLink:
        return "Easel link";
      case AnalyticsEventEnum.viewNFTLink:
        return "View NFT link";
      case AnalyticsEventEnum.tradeNFTLink:
        return "Trade NFT link";
      case AnalyticsEventEnum.unknownLink:
        return "Unknown link";
    }
  }
}
