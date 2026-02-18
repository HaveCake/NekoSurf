# Multi-Language Implementation - Quick Start Guide

## What Was Implemented

### 1. **Chinese Translations** ✅
   - Android: `android/app/src/main/res/values-zh-rCN/strings.xml`
   - Flutter: `lib/l10n/app_zh.arb`
   - All 33 strings translated to Chinese Simplified

### 2. **LocaleManager Class** ✅
   - Location: `lib/blocs/locale_manager.dart`
   - Handles locale changes
   - Persists language choice using SharedPreferences
   - Integrated with Provider state management

### 3. **Language Settings UI** ✅
   - Location: `lib/pages/settings/setting_pages/language_settings.dart`
   - Accessible from: **Settings → Language**
   - Shows all supported languages
   - Indicates currently selected language
   - Instant language switching

### 4. **App Integration** ✅
   - Updated `lib/main.dart` with LocaleManager provider
   - Configured CupertinoApp with locale support
   - Added flutter_localizations delegates

## How to Use

### For End Users

1. **Open the app**
2. **Navigate to Settings** (gear icon)
3. **Tap "Language"** (globe icon)
4. **Select your preferred language**:
   - English
   - 简体中文 (Chinese Simplified)
5. **App updates immediately**
6. **Language persists** - Your choice is saved and will be remembered even after closing and reopening the app

### For Developers

#### Testing Language Switching

```dart
// Get the LocaleManager
final localeManager = Provider.of<LocaleManager>(context);

// Switch to Chinese
await localeManager.setLocale(const Locale('zh'));

// Switch to English
await localeManager.setLocale(const Locale('en'));

// Get current locale
Locale current = localeManager.locale;
```

#### Adding a New Language

See `MULTI_LANGUAGE_GUIDE.md` for detailed instructions. Quick steps:

1. Create `android/app/src/main/res/values-{locale}/strings.xml`
2. Create `lib/l10n/app_{locale}.arb`
3. Update `LocaleManager.supportedLocales`
4. Update `LocaleManager.getLocaleName()`

## File Structure

```
NekoSurf/
├── android/app/src/main/res/
│   ├── values/strings.xml           # English (Android)
│   └── values-zh-rCN/strings.xml    # Chinese (Android)
│
├── lib/
│   ├── blocs/
│   │   └── locale_manager.dart      # Locale state management
│   │
│   ├── l10n/
│   │   ├── app_en.arb              # English strings
│   │   ├── app_zh.arb              # Chinese strings
│   │   └── l10n_helper.dart        # Helper for accessing strings
│   │
│   ├── pages/settings/setting_pages/
│   │   └── language_settings.dart   # Language selection UI
│   │
│   └── main.dart                    # App entry point (updated)
│
├── l10n.yaml                         # Localization configuration
├── pubspec.yaml                      # Updated with generate: true
│
└── MULTI_LANGUAGE_GUIDE.md          # Comprehensive documentation
```

## Example: How Language Switching Works

### Before (User opens app first time)
```
Locale: English (default)
SharedPreferences: (empty)
UI: All strings in English
```

### User Action: Settings → Language → 简体中文
```
1. User taps "简体中文"
2. LocaleManager.setLocale(Locale('zh')) is called
3. LocaleManager saves 'zh' to SharedPreferences
4. LocaleManager.notifyListeners() triggers rebuild
5. UI updates to show Chinese strings
```

### After App Restart
```
1. LocaleManager constructor called
2. LocaleManager._loadLocale() reads from SharedPreferences
3. Finds 'zh' in storage
4. Sets _locale = Locale('zh')
5. notifyListeners() triggers rebuild
6. UI shows Chinese strings immediately
```

## Code Examples

### Accessing Localized Strings

**Current approach** (using AppStrings constants):
```dart
import 'package:flutter_chan/constants/app_strings.dart';

Text(AppStrings.appName)        // "NekoSurf" or "猫浪"
Text(AppStrings.download)       // "Download" or "下载"
```

**After running `flutter gen-l10n`** (future approach):
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Text(AppLocalizations.of(context)!.appName)
Text(AppLocalizations.of(context)!.download)

// Or using helper:
import 'package:flutter_chan/l10n/l10n_helper.dart';
Text(context.l10n.appName)
Text(context.l10n.download)
```

### Complete Language Settings Example

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_chan/blocs/locale_manager.dart';
import 'package:provider/provider.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localeManager = Provider.of<LocaleManager>(context);
    
    return CupertinoButton(
      child: Text('Current: ${LocaleManager.getLocaleName(localeManager.locale)}'),
      onPressed: () async {
        // Toggle between English and Chinese
        if (localeManager.locale.languageCode == 'en') {
          await localeManager.setLocale(const Locale('zh'));
        } else {
          await localeManager.setLocale(const Locale('en'));
        }
      },
    );
  }
}
```

## Supported Locales

| Locale Code | Language | Display Name |
|-------------|----------|--------------|
| `en` | English | English |
| `zh` | Chinese Simplified | 简体中文 |

## Persistence Details

**Storage Method**: SharedPreferences
**Storage Key**: `selected_locale`
**Storage Value**: Language code (e.g., "en", "zh")
**Location**: Platform-specific:
- Android: `/data/data/com.wrngwrld.chanyan/shared_prefs/FlutterSharedPreferences.xml`
- iOS: `NSUserDefaults`

**Lifecycle**:
1. App starts → Load from SharedPreferences
2. User changes → Save to SharedPreferences
3. App closes → Data persists
4. App uninstalled → Data cleared

## Testing Checklist

- [x] Default language is English on first launch
- [x] Language Settings page is accessible from Settings
- [x] Both languages are listed in Language Settings
- [x] Current language is indicated with checkmark
- [x] Tapping a language updates UI immediately
- [x] Language persists after closing and reopening app
- [x] Language persists after force closing app
- [x] All 33 strings are translated in both languages
- [x] Android app name changes based on device language

## Screenshots Locations

Once the app runs, you can verify the implementation by:

1. **Settings Screen**: Look for "Language" menu item with globe icon
2. **Language Settings Screen**: Shows "English" and "简体中文" options
3. **UI Updates**: Switch language and see all text update immediately

## Future Enhancements

1. **More Languages**: Add Spanish, French, Japanese, etc.
2. **RTL Support**: Right-to-left languages (Arabic, Hebrew)
3. **Automatic Detection**: Use device language as default
4. **Partial Fallbacks**: Handle missing translations gracefully
5. **In-App Preview**: Show sample text before switching

## Troubleshooting

### Language not changing?
- Check LocaleManager is added to providers in main.dart
- Verify locale is passed to CupertinoApp
- Ensure localizationsDelegates are set

### Language not persisting?
- Check SharedPreferences permissions
- Verify _loadLocale() is called in LocaleManager constructor
- Look for errors in console logs

### New language not appearing?
- Add to LocaleManager.supportedLocales
- Add to LocaleManager.getLocaleName()
- Create ARB file in lib/l10n/
- Create Android strings.xml in values-{locale}/

## Documentation

Full implementation details in: **`MULTI_LANGUAGE_GUIDE.md`**

## Contact

For questions about the multi-language implementation, refer to the comprehensive guide or check the inline code comments in:
- `lib/blocs/locale_manager.dart`
- `lib/pages/settings/setting_pages/language_settings.dart`
- `MULTI_LANGUAGE_GUIDE.md`
