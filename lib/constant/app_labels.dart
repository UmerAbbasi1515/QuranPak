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
  static const String readBy = 'read_by';
  static const String previous = 'previous';
  static const String next = 'next';
  static const String autoscroll = 'autoscroll';

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
}

// Surah And Parhas
/// Arabic names of the 114 Surahs of the Quran, in order.
class SurahNames {
  static const List<String> arabic = [
    'الفاتحة', // 1
    'البقرة', // 2
    'آل عمران', // 3
    'النساء', // 4
    'المائدة', // 5
    'الأنعام', // 6
    'الأعراف', // 7
    'الأنفال', // 8
    'التوبة', // 9
    'يونس', // 10
    'هود', // 11
    'يوسف', // 12
    'الرعد', // 13
    'إبراهيم', // 14
    'الحجر', // 15
    'النحل', // 16
    'الإسراء', // 17
    'الكهف', // 18
    'مريم', // 19
    'طه', // 20
    'الأنبياء', // 21
    'الحج', // 22
    'المؤمنون', // 23
    'النور', // 24
    'الفرقان', // 25
    'الشعراء', // 26
    'النمل', // 27
    'القصص', // 28
    'العنكبوت', // 29
    'الروم', // 30
    'لقمان', // 31
    'السجدة', // 32
    'الأحزاب', // 33
    'سبأ', // 34
    'فاطر', // 35
    'يس', // 36
    'الصافات', // 37
    'ص', // 38
    'الزمر', // 39
    'غافر', // 40
    'فصلت', // 41
    'الشورى', // 42
    'الزخرف', // 43
    'الدخان', // 44
    'الجاثية', // 45
    'الأحقاف', // 46
    'محمد', // 47
    'الفتح', // 48
    'الحجرات', // 49
    'ق', // 50
    'الذاريات', // 51
    'الطور', // 52
    'النجم', // 53
    'القمر', // 54
    'الرحمن', // 55
    'الواقعة', // 56
    'الحديد', // 57
    'المجادلة', // 58
    'الحشر', // 59
    'الممتحنة', // 60
    'الصف', // 61
    'الجمعة', // 62
    'المنافقون', // 63
    'التغابن', // 64
    'الطلاق', // 65
    'التحريم', // 66
    'الملك', // 67
    'القلم', // 68
    'الحاقة', // 69
    'المعارج', // 70
    'نوح', // 71
    'الجن', // 72
    'المزمل', // 73
    'المدثر', // 74
    'القيامة', // 75
    'الإنسان', // 76
    'المرسلات', // 77
    'النبأ', // 78
    'النازعات', // 79
    'عبس', // 80
    'التكوير', // 81
    'الانفطار', // 82
    'المطففين', // 83
    'الانشقاق', // 84
    'البروج', // 85
    'الطارق', // 86
    'الأعلى', // 87
    'الغاشية', // 88
    'الفجر', // 89
    'البلد', // 90
    'الشمس', // 91
    'الليل', // 92
    'الضحى', // 93
    'الشرح', // 94
    'التين', // 95
    'العلق', // 96
    'القدر', // 97
    'البينة', // 98
    'الزلزلة', // 99
    'العاديات', // 100
    'القارعة', // 101
    'التكاثر', // 102
    'العصر', // 103
    'الهمزة', // 104
    'الفيل', // 105
    'قريش', // 106
    'الماعون', // 107
    'الكوثر', // 108
    'الكافرون', // 109
    'النصر', // 110
    'المسد', // 111
    'الإخلاص', // 112
    'الفلق', // 113
    'الناس', // 114
  ];
}

/// Arabic names of the 30 Paras / Ajza' (Juz') of the Quran, in order.
/// Each Para is traditionally named after its opening word(s).
class ParaNames {
  static const List<String> arabic = [
    'الم', // Para 1
    'سيقول', // Para 2
    'تلك الرسل', // Para 3
    'لن تنالوا', // Para 4
    'والمحصنات', // Para 5
    'لا يحب الله', // Para 6
    'وإذا سمعوا', // Para 7
    'ولو أننا', // Para 8
    'قال الملأ', // Para 9
    'واعلموا', // Para 10
    'يعتذرون', // Para 11
    'وما من دابة', // Para 12
    'وما أبرئ', // Para 13
    'ربما', // Para 14
    'سبحان الذي', // Para 15
    'قال ألم', // Para 16
    'اقترب للناس', // Para 17
    'قد أفلح', // Para 18
    'وقال الذين', // Para 19
    'أمن خلق', // Para 20
    'اتل ما أوحي', // Para 21
    'ومن يقنت', // Para 22
    'وما لي', // Para 23
    'فمن أظلم', // Para 24
    'إليه يرد', // Para 25
    'حم', // Para 26
    'قال فما خطبكم', // Para 27
    'قد سمع الله', // Para 28
    'تبارك الذي', // Para 29
    'عم', // Para 30
  ];
}
