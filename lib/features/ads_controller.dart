import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MobileAdsController extends GetxController {
  // ads
  BannerAd? bannerAd;
  final RxBool isBannerLoaded = false.obs;
  InterstitialAd? _interstitialAd;

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-3940256099942544/1033173712', // TEST ID — replace with your real one
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadInterstitialAd(); // preload the next one
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      // ad wasn't ready — just proceed without showing one
    }
  }

  void loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId:
          'ca-app-pub-3940256099942544/6300978111', // TEST ID — replace with your real one
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isBannerLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          isBannerLoaded.value = false;
          ad.dispose();
        },
      ),
    )..load();
  }
}
