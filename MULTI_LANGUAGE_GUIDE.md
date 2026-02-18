# Multi-Language Support Implementation Guide

This document describes the multi-language support implementation for the NekoSurf app.

## Overview

The app now supports multiple languages with persistent language selection across app restarts. Currently implemented languages:
- **English (en)** - Default
- **Chinese Simplified (zh)** - 简体中文

## Architecture

### 1. Android Native Strings

Location: `android/app/src/main/res/values*/strings.xml`

```
android/app/src/main/res/
├── values/strings.xml           # English (default)
└── values-zh-rCN/strings.xml    # Chinese Simplified
```

The Android native strings are automatically selected based on the device locale. These are used for:
- App name in launcher
- Native Android components

### 2. Flutter Localization (ARB Format)

Location: `lib/l10n/`

```
lib/l10n/
├── app_en.arb    # English strings
├── app_zh.arb    # Chinese strings
└── l10n_helper.dart  # Helper for accessing localizations
```

**ARB (Application Resource Bundle)** is Flutter's standard format for localization. Each file contains:
- String keys
- Translated values
- Metadata and descriptions

### 3. LocaleManager

Location: `lib/blocs/locale_manager.dart`

**Purpose**: Manages locale state and persistence using SharedPreferences.

**Key Features**:
- Loads saved locale on app start
- Persists locale selection across app restarts
- Provides list of supported locales
- Notifies listeners when locale changes

**Usage Example**:
```dart
final localeManager = Provider.of<LocaleManager>(context);

// Get current locale
Locale currentLocale = localeManager.locale;

// Change locale
await localeManager.setLocale(const Locale('zh'));

// Get supported locales
List<Locale> locales = LocaleManager.supportedLocales;
```

### 4. Integration with Main App

**File**: `lib/main.dart`

The LocaleManager is integrated as a ChangeNotifier provider:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider<LocaleManager>(
      create: (_) => LocaleManager(),
    ),
    // ... other providers
  ],
  child: const AppWithTheme(),
)
```

The CupertinoApp uses the locale from LocaleManager:

```dart
CupertinoApp(
  locale: localeManager.locale,
  supportedLocales: LocaleManager.supportedLocales,
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  // ...
)
```

### 5. Language Settings UI

Location: `lib/pages/settings/setting_pages/language_settings.dart`

A dedicated settings page allows users to:
- View all supported languages
- See the currently selected language
- Change the app language
- Understand that their selection persists

Access from: **Settings → Language**

## How Language Selection Works

1. **First Launch**: App uses English (default)
2. **User Selection**: User navigates to Settings → Language and selects a language
3. **Immediate Update**: LocaleManager notifies all listeners, app rebuilds with new locale
4. **Persistence**: Selection is saved to SharedPreferences
5. **Next Launch**: App loads saved locale and uses it automatically

## Configuration Files

### pubspec.yaml

```yaml
flutter:
  generate: true  # Enable localization generation
```

### l10n.yaml

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

## Generating Localization Code

To generate the localization classes from ARB files, run:

```bash
flutter gen-l10n
```

This creates generated files in:
```
.dart_tool/flutter_gen/gen_l10n/
├── app_localizations.dart
├── app_localizations_en.dart
└── app_localizations_zh.dart
```

## Using Localized Strings

### Current Approach (Before gen-l10n)

Using the AppStrings constants:

```dart
import 'package:flutter_chan/constants/app_strings.dart';

Text(AppStrings.appName)
```

### Future Approach (After gen-l10n)

Using generated localizations:

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// In a widget with BuildContext:
Text(AppLocalizations.of(context)!.appName)

// Or using the helper extension:
import 'package:flutter_chan/l10n/l10n_helper.dart';
Text(context.l10n.appName)
```

## Adding a New Language

### Step 1: Add Android strings

Create `android/app/src/main/res/values-{locale}/strings.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Your Translation</string>
    <!-- ... other strings -->
</resources>
```

Examples:
- Spanish: `values-es/strings.xml`
- French: `values-fr/strings.xml`
- Japanese: `values-ja/strings.xml`

### Step 2: Add Flutter ARB file

Create `lib/l10n/app_{locale}.arb`:

```json
{
  "@@locale": "es",
  "appName": "Translation",
  "add": "Translation",
  // ... all other keys
}
```

### Step 3: Update LocaleManager

Add the new locale to `supportedLocales`:

```dart
static List<Locale> get supportedLocales => const [
  Locale('en'),
  Locale('zh'),
  Locale('es'), // New language
];
```

Add display name in `getLocaleName`:

```dart
static String getLocaleName(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return 'English';
    case 'zh':
      return '简体中文';
    case 'es':
      return 'Español';
    // ...
  }
}
```

### Step 4: Generate and Test

```bash
flutter gen-l10n
flutter run
```

## String Keys Reference

All 33 user-facing strings are localized:

| Category | Keys |
|----------|------|
| Common Actions | add, cancel, delete, download, remove, share |
| Settings | settingsThreads, settingsPrivacy, settingsData |
| Data Management | cacheSize, deleteCache, watchedMediaRetentionPeriod, selectRetentionPeriod, clearWatchedMediaHistory |
| Bookmarks | sortNewest, sortOldest, clearBookmarks, removeBookmark, setBookmark |
| Media | deleteAttachmentTitle, openInBrowser |
| Boards/Threads | openLink, replies |
| Permissions | permissionDeniedTitle, permissionDeniedMessage, permissionDeniedInstruction, openSystemSettings |
| File Operations | fileSaved, fileDownloaded, downloading, fileConverting, downloadFailed |

## Persistence Details

**Storage**: SharedPreferences (key: `selected_locale`)
**Lifecycle**:
1. App starts → LocaleManager loads from SharedPreferences
2. User changes language → LocaleManager saves to SharedPreferences
3. App restarts → LocaleManager loads saved locale
4. Uninstall → SharedPreferences cleared, resets to default

## Testing

### Manual Testing Checklist

1. ✅ Launch app - verify default language (English)
2. ✅ Navigate to Settings → Language
3. ✅ Select Chinese - verify UI updates immediately
4. ✅ Navigate through app - verify all strings are in Chinese
5. ✅ Close and reopen app - verify Chinese persists
6. ✅ Switch back to English - verify all strings update
7. ✅ Close and reopen app - verify English persists

### Automated Testing

```dart
testWidgets('Locale changes persist', (WidgetTester tester) async {
  final localeManager = LocaleManager();
  
  // Set Chinese
  await localeManager.setLocale(const Locale('zh'));
  expect(localeManager.locale.languageCode, 'zh');
  
  // Create new instance (simulates app restart)
  final newLocaleManager = LocaleManager();
  await Future.delayed(const Duration(milliseconds: 100)); // Wait for load
  
  expect(newLocaleManager.locale.languageCode, 'zh');
});
```

## Troubleshooting

### Issue: Strings not updating after changing language

**Solution**: Ensure CupertinoApp has `locale` and `supportedLocales` set correctly.

### Issue: Generated files not found

**Solution**: Run `flutter gen-l10n` to generate localization files.

### Issue: New language not appearing

**Solution**: 
1. Check locale is added to `supportedLocales` in LocaleManager
2. Verify ARB file exists in `lib/l10n/`
3. Run `flutter gen-l10n`

### Issue: Language doesn't persist

**Solution**: 
1. Check SharedPreferences is working
2. Verify LocaleManager constructor calls `_loadLocale()`
3. Check for errors in logs

## Future Enhancements

1. **Right-to-Left (RTL) Support**: For Arabic, Hebrew, etc.
   ```dart
   CupertinoApp(
     locale: localeManager.locale,
     localeResolutionCallback: (locale, supportedLocales) {
       // Handle RTL
     },
   )
   ```

2. **Fallback Locales**: Handle partial translations
3. **Plural Forms**: Support for quantity-based strings
4. **Date/Time Formatting**: Use intl package for locale-specific formatting
5. **Currency**: Locale-specific currency display

## Resources

- [Flutter Internationalization](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- [ARB Format Specification](https://github.com/google/app-resource-bundle)
- [Intl Package](https://pub.dev/packages/intl)
- [Flutter Localizations](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html)
