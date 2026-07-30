import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holy_quran/core/data/quran_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Everything the user can change, persisted to disk and observable so the UI
/// rebuilds the moment a setting changes.
class AppPrefs extends GetxService {
  static AppPrefs get to => Get.find<AppPrefs>();

  static const _kThemeMode = 'theme_mode';
  static const _kTranslationId = 'translation_id';
  static const _kShowTranslation = 'show_translation';
  static const _kArabicFontSize = 'arabic_font_size';
  static const _kTranslationFontSize = 'translation_font_size';
  static const _kBookmarks = 'bookmarks';
  static const _kLastRead = 'last_read';

  static const double minArabicFontSize = 18;
  static const double maxArabicFontSize = 40;
  static const double minTranslationFontSize = 12;
  static const double maxTranslationFontSize = 24;

  late final SharedPreferences _prefs;

  final themeMode = ThemeMode.system.obs;
  final translationId = QuranTranslations.all.first.id.obs;
  final showTranslation = true.obs;
  final arabicFontSize = 26.0.obs;
  final translationFontSize = 15.0.obs;

  /// Verse keys ("2:255"), most recently added first.
  final bookmarks = <String>[].obs;
  final lastRead = Rxn<LastRead>();

  TranslationOption get translation =>
      QuranTranslations.byId(translationId.value);

  Future<AppPrefs> init() async {
    _prefs = await SharedPreferences.getInstance();

    themeMode.value = ThemeMode.values[
        (_prefs.getInt(_kThemeMode) ?? ThemeMode.system.index)
            .clamp(0, ThemeMode.values.length - 1)];
    translationId.value =
        _prefs.getString(_kTranslationId) ?? QuranTranslations.all.first.id;
    showTranslation.value = _prefs.getBool(_kShowTranslation) ?? true;
    arabicFontSize.value = (_prefs.getDouble(_kArabicFontSize) ?? 26.0)
        .clamp(minArabicFontSize, maxArabicFontSize);
    translationFontSize.value =
        (_prefs.getDouble(_kTranslationFontSize) ?? 15.0)
            .clamp(minTranslationFontSize, maxTranslationFontSize);
    bookmarks.value = _prefs.getStringList(_kBookmarks) ?? <String>[];
    lastRead.value = LastRead.decode(_prefs.getString(_kLastRead));

    return this;
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    _prefs.setInt(_kThemeMode, mode.index);
  }

  void setTranslation(String id) {
    translationId.value = id;
    _prefs.setString(_kTranslationId, id);
  }

  void setShowTranslation(bool value) {
    showTranslation.value = value;
    _prefs.setBool(_kShowTranslation, value);
  }

  void setArabicFontSize(double value) {
    final clamped = value.clamp(minArabicFontSize, maxArabicFontSize);
    arabicFontSize.value = clamped;
    _prefs.setDouble(_kArabicFontSize, clamped);
  }

  void setTranslationFontSize(double value) {
    final clamped = value.clamp(minTranslationFontSize, maxTranslationFontSize);
    translationFontSize.value = clamped;
    _prefs.setDouble(_kTranslationFontSize, clamped);
  }

  bool isBookmarked(String verseKey) => bookmarks.contains(verseKey);

  /// Returns true when the verse ended up bookmarked.
  bool toggleBookmark(String verseKey) {
    final added = !bookmarks.contains(verseKey);
    if (added) {
      bookmarks.insert(0, verseKey);
    } else {
      bookmarks.remove(verseKey);
    }
    _prefs.setStringList(_kBookmarks, bookmarks);
    return added;
  }

  void clearBookmarks() {
    bookmarks.clear();
    _prefs.setStringList(_kBookmarks, const []);
  }

  void saveLastRead(int surahNumber, int verseNumber) {
    final entry = LastRead(
      surahNumber: surahNumber,
      verseNumber: verseNumber,
      savedAt: DateTime.now(),
    );
    lastRead.value = entry;
    _prefs.setString(_kLastRead, entry.encode());
  }
}
