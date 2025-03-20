import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/9214589741';  //test
      //return 'ca-app-pub-7601426267595616/4033562742';  //real
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2435281174';  //test
      //return 'ca-app-pub-7601426267595616/7275621991'; //real
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712"; //test
      //return "ca-app-pub-7601426267595616/3209367988"; //real
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910"; //test
      //return "ca-app-pub-7601426267595616/6894495962"; //real
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";  //test
      //return "ca-app-pub-7601426267595616/4970006365"; //real
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";  //test
      //return "ca-app-pub-7601426267595616/4482921205";  //real
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}