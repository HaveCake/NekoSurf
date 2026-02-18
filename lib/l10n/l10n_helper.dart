/// Extension methods to access localized strings
/// This provides a bridge between the current AppStrings and future l10n integration
/// 
/// Usage:
/// - In widgets with BuildContext: context.l10n.appName
/// - Fallback to AppStrings when l10n is not yet available
/// 
/// Once flutter gen-l10n is run, this will use the generated AppLocalizations

import 'package:flutter/widgets.dart';
import 'package:flutter_chan/constants/app_strings.dart';

extension LocalizationExtension on BuildContext {
  /// Get the current app localizations
  /// Falls back to AppStrings if generated localizations are not available
  AppStringsWrapper get l10n {
    // TODO: Replace with AppLocalizations.of(this) after running flutter gen-l10n
    // return AppLocalizations.of(this)!;
    return AppStringsWrapper();
  }
}

/// Wrapper class that provides the same interface as generated localizations
/// This allows the code to work before running flutter gen-l10n
class AppStringsWrapper {
  String get appName => AppStrings.appName;
  String get add => AppStrings.add;
  String get cancel => AppStrings.cancel;
  String get delete => AppStrings.delete;
  String get download => AppStrings.download;
  String get remove => AppStrings.remove;
  String get share => AppStrings.share;
  String get settingsThreads => AppStrings.settingsThreads;
  String get settingsPrivacy => AppStrings.settingsPrivacy;
  String get settingsData => AppStrings.settingsData;
  String get cacheSize => AppStrings.cacheSize;
  String get deleteCache => AppStrings.deleteCache;
  String get watchedMediaRetentionPeriod => AppStrings.watchedMediaRetentionPeriod;
  String get selectRetentionPeriod => AppStrings.selectRetentionPeriod;
  String get clearWatchedMediaHistory => AppStrings.clearWatchedMediaHistory;
  String get sortNewest => AppStrings.sortNewest;
  String get sortOldest => AppStrings.sortOldest;
  String get clearBookmarks => AppStrings.clearBookmarks;
  String get removeBookmark => AppStrings.removeBookmark;
  String get setBookmark => AppStrings.setBookmark;
  String get deleteAttachmentTitle => AppStrings.deleteAttachmentTitle;
  String get openInBrowser => AppStrings.openInBrowser;
  String get openLink => AppStrings.openLink;
  String get replies => AppStrings.replies;
  String get permissionDeniedTitle => AppStrings.permissionDeniedTitle;
  String get permissionDeniedMessage => AppStrings.permissionDeniedMessage;
  String get permissionDeniedInstruction => AppStrings.permissionDeniedInstruction;
  String get openSystemSettings => AppStrings.openSystemSettings;
  String get fileSaved => AppStrings.fileSaved;
  String get fileDownloaded => AppStrings.fileDownloaded;
  String get downloading => AppStrings.downloading;
  String get fileConverting => AppStrings.fileConverting;
  String get downloadFailed => AppStrings.downloadFailed;
}
