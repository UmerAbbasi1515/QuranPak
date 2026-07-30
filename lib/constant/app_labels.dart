import 'package:holy_quran/quran_dashboard/home/parah_screen.dart';

class AppLabels {
  AppLabels._();

  // Splash / Language
  static const String selectLanguage = 'select_lang';
  static const String appName = 'app_name';
  static const String welcomeSubtitle = 'welcome_subtitle';
  static const String letsStart = 'lets_start';
  static const String welcome = 'welcome';

  // Home
  static const String page = 'page';
  static const String juzz = 'juzz';
  static const String dua = 'dua';
  static const String para = 'para';
  static const String paras = 'paras';
  static const String continueReading = 'continue_reading';
  static const String savedPlaces = 'saved_places';
  static const String dailyDuas = 'daily_duas';
  static const String moreFeatures = 'more_features';
  static const String duasCollection = 'duas_collection';
  static const String exploreMore = 'explore_more';

  // Bottom Nav
  static const String home = 'home';
  static const String dailyDuasNav = 'daily_duas_nav';
  static const String settings = 'settings';
  static const String search = 'search';

  // Search
  static const String searchByName = 'search_by_name';

  // Jump to Page
  static const String goToPage = 'go_to_page';
  static const String jumpTo = 'jump_to';
  static const String jumpToPageDesc = 'jump_to_page_desc';
  static const String enterPageNumber = 'enter_page_number';

  // Reading
  // static const String readBy = 'read_by';
  static const String previous = 'previous';
  static const String next = 'next';
  static const String autoscroll = 'autoscroll';
  // static const String readyByParas = '$readBy $paras';
  // static const String readyBySurah = readBy + paras;

  // Bookmarks
  static const String bookmark = 'bookmark';
  static const String yourSavedVerses = 'your_saved_verses';
  static const String addBookmark = 'add_bookmark';
  static const String saveBookmarkDesc = 'save_bookmark_desc';
  static const String addNewBookmark = 'add_new_bookmark';
  static const String saveBookmark = 'save_bookmark';
  static const String deleteBookmark = 'delete_bookmark';
  static const String deleteBookmarkConfirm = 'delete_bookmark_confirm';
  static const String cancel = 'cancel';

  // Settings
  static const String notification = 'notification';
  static const String shareApp = 'share_app';
  static const String shareAppDesc = 'share_app_desc';
  static const String toggleOnOff = 'toggle_on_off';
  static const String rateUs = 'rate_us';
  static const String rateUsDesc = 'rate_us_desc';
  static const String about = 'about';
  static const String aboutDesc = 'about_desc';
  static const String privacyPolicy = 'privacy_policy';
  static const String darkMode = 'dark_mode';

  // Rate Us Dialog
  static const String loveUsingApp = 'love_using_app';
  static const String supportEncourage = 'support_encourage';
  static const String rateNow = 'rate_now';
  static const String maybeLater = 'maybe_later';

  // Duas
  static const String duaEveryMoment = 'dua_every_moment';
  static const String todays = 'todays';
  static const String duaFor = 'dua_for';

  static const List<ParahModel> parahList = [
    ParahModel(number: 1, englishName: 'Alif Lam Meem', arabicName: 'الم'),
    ParahModel(number: 2, englishName: 'Sayaqool', arabicName: 'سيقول'),
    ParahModel(number: 3, englishName: 'Tilkal Rusul', arabicName: 'تلك الرسل'),
    ParahModel(number: 4, englishName: 'Lan Tana Loo', arabicName: 'لن تنالوا'),
    ParahModel(number: 5, englishName: 'Wal Mohsanat', arabicName: 'والمحصنات'),
    ParahModel(
        number: 6, englishName: 'La Yuhibbullah', arabicName: 'لا يحب الله'),
    ParahModel(
        number: 7, englishName: 'Wa Iza Samiu', arabicName: 'وإذا سمعوا'),
    ParahModel(number: 8, englishName: 'Wa Lau Annana', arabicName: 'ولو أننا'),
    ParahModel(number: 9, englishName: 'Qalal Malao', arabicName: 'قال الملأ'),
    ParahModel(number: 10, englishName: "Wa A'lamu", arabicName: 'واعلموا'),
    ParahModel(number: 11, englishName: 'Yatazeroon', arabicName: 'يعتذرون'),
    ParahModel(
        number: 12,
        englishName: "Wa Ma Min Da'abat",
        arabicName: 'وما من دابة'),
    ParahModel(number: 13, englishName: 'Rubama', arabicName: 'ربما'),
    ParahModel(
        number: 14, englishName: 'Subhanallazi', arabicName: 'سبحان الذي'),
    ParahModel(number: 15, englishName: 'Qal Alam', arabicName: 'قال ألم'),
    ParahModel(number: 16, englishName: 'Aqtaraba', arabicName: 'اقترب'),
    ParahModel(number: 17, englishName: 'Qadd Aflaha', arabicName: 'قد أفلح'),
    ParahModel(
        number: 18, englishName: 'Wa Qalallazina', arabicName: 'وقال الذين'),
    ParahModel(number: 19, englishName: "A'man Khalaq", arabicName: 'أمن خلق'),
    ParahModel(
        number: 20, englishName: 'Utlu Ma Oohi', arabicName: 'اتل ما أوحي'),
    ParahModel(number: 21, englishName: 'Wa Manyaqnut', arabicName: 'ومن يقنت'),
    ParahModel(number: 22, englishName: 'Wa Mali', arabicName: 'وما لي'),
    ParahModel(number: 23, englishName: 'Faman Azlam', arabicName: 'فمن أظلم'),
    ParahModel(
        number: 24, englishName: 'Ilayhi Yuraddu', arabicName: 'إليه يرد'),
    ParahModel(number: 25, englishName: 'Ha Meem', arabicName: 'حم'),
    ParahModel(
        number: 26,
        englishName: 'Qala Fama Khatbukum',
        arabicName: 'قال فما خطبكم'),
    ParahModel(
        number: 27, englishName: 'Qad Sami Allah', arabicName: 'قد سمع الله'),
    ParahModel(
        number: 28, englishName: 'Tabarakallazi', arabicName: 'تبارك الذي'),
    ParahModel(number: 29, englishName: 'Amma', arabicName: 'عم'),
    ParahModel(
        number: 30, englishName: 'Amma Yatasaaloon', arabicName: 'عم يتساءلون'),
  ];
}
