# Multi-Language Architecture Diagram

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         NekoSurf App                            │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                     main.dart                           │   │
│  │                                                         │   │
│  │  MultiProvider(                                         │   │
│  │    providers: [                                         │   │
│  │      ChangeNotifierProvider<LocaleManager>(),           │   │
│  │      ... other providers                                │   │
│  │    ]                                                    │   │
│  │  )                                                      │   │
│  │                                                         │   │
│  │  CupertinoApp(                                          │   │
│  │    locale: localeManager.locale,  ←─────────────┐      │   │
│  │    supportedLocales: [en, zh],                  │      │   │
│  │    localizationsDelegates: [...]                │      │   │
│  │  )                                              │      │   │
│  └─────────────────────────────────────────────────┼──────┘   │
│                                                    │          │
│  ┌─────────────────────────────────────────────────┼──────┐   │
│  │              LocaleManager                      │      │   │
│  │              (ChangeNotifier)                   │      │   │
│  │                                                 │      │   │
│  │  - Locale _locale                               │      │   │
│  │  + setLocale(Locale)  ─────────────────────────┤      │   │
│  │  + supportedLocales                             │      │   │
│  │  + getLocaleName(Locale)                        │      │   │
│  │                                                 │      │   │
│  │  Persistence:                                   │      │   │
│  │  - _loadLocale()  ←─── SharedPreferences        │      │   │
│  │  - _saveLocale()  ───→ SharedPreferences        │      │   │
│  └─────────────────────────────────────────────────┘      │   │
│                                                           │   │
│  ┌─────────────────────────────────────────────────────┐ │   │
│  │          Language Settings UI                       │ │   │
│  │                                                     │ │   │
│  │  ┌──────────────────────────────┐                  │ │   │
│  │  │  ○ English                   │                  │ │   │
│  │  │  ● 简体中文         ✓        │  ────────────────┘ │   │
│  │  └──────────────────────────────┘                    │   │
│  │                                                      │   │
│  │  User taps → setLocale(Locale('zh'))                │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

### 1. App Startup Flow

```
App Launch
    │
    ├─→ WidgetsFlutterBinding.ensureInitialized()
    │
    ├─→ runApp(MyApp())
    │
    ├─→ MultiProvider creates LocaleManager()
    │       │
    │       └─→ LocaleManager constructor
    │               │
    │               └─→ _loadLocale()
    │                       │
    │                       └─→ SharedPreferences.getString('selected_locale')
    │                               │
    │                               ├─→ If found: _locale = Locale(code)
    │                               │                  │
    │                               │                  └─→ notifyListeners()
    │                               │
    │                               └─→ If not found: use default (en)
    │
    └─→ CupertinoApp builds with locale from LocaleManager
            │
            └─→ UI displays in selected language
```

### 2. Language Change Flow

```
User Action: Settings → Language → Select "简体中文"
    │
    ├─→ onTap() called
    │
    ├─→ localeManager.setLocale(Locale('zh'))
    │       │
    │       ├─→ Check if different from current
    │       │
    │       ├─→ _locale = Locale('zh')
    │       │
    │       ├─→ notifyListeners()
    │       │       │
    │       │       └─→ All listening widgets rebuild
    │       │               │
    │       │               └─→ UI updates to Chinese
    │       │
    │       └─→ SharedPreferences.setString('selected_locale', 'zh')
    │               │
    │               └─→ Language choice persisted to disk
    │
    └─→ Language Settings page shows checkmark on "简体中文"
```

### 3. Localized String Access

```
Widget needs localized string
    │
    ├─→ Option 1: Direct AppStrings
    │       │
    │       └─→ AppStrings.appName
    │               │
    │               └─→ Returns "NekoSurf" (hardcoded)
    │
    ├─→ Option 2: Context extension (future)
    │       │
    │       └─→ context.l10n.appName
    │               │
    │               └─→ AppLocalizations.of(context)
    │                       │
    │                       └─→ Returns localized string based on locale
    │                           │
    │                           ├─→ en: "NekoSurf"
    │                           └─→ zh: "猫浪"
    │
    └─→ String displayed in widget
```

## File Relationships

```
┌──────────────────────────────────────────────────────────────┐
│                    String Resources                          │
│                                                              │
│  Android (Native)              Flutter (ARB)                 │
│  ┌────────────────┐           ┌────────────────┐            │
│  │ values/        │           │ lib/l10n/      │            │
│  │   strings.xml  │           │   app_en.arb   │            │
│  │                │           │   app_zh.arb   │            │
│  │ values-zh-rCN/ │           │                │            │
│  │   strings.xml  │           └────────────────┘            │
│  └────────────────┘                    │                    │
│         │                              │                    │
│         │                              ▼                    │
│         │                    flutter gen-l10n               │
│         │                              │                    │
│         │                              ▼                    │
│         │                   .dart_tool/flutter_gen/         │
│         │                     gen_l10n/                     │
│         │                       app_localizations.dart      │
│         │                       app_localizations_en.dart   │
│         │                       app_localizations_zh.dart   │
│         │                              │                    │
│         └──────────────────────────────┼────────────────────┘
│                                        │
│                                        ▼
│                              ┌─────────────────┐
│                              │  Application    │
│                              │  Uses Strings   │
│                              └─────────────────┘
└──────────────────────────────────────────────────────────────┘
```

## State Management

```
┌─────────────────────────────────────────────────────────┐
│                    Provider Tree                        │
│                                                         │
│  MultiProvider                                          │
│    ├─ ThemeChanger (Dark/Light mode)                   │
│    ├─ LocaleManager (Language) ◄─── USER SELECTS       │
│    ├─ BookmarksProvider                                │
│    ├─ FavoriteProvider                                 │
│    ├─ SettingsProvider                                 │
│    └─ ...                                              │
│                                                         │
│  When LocaleManager.setLocale() is called:             │
│    1. Update internal state                            │
│    2. Save to SharedPreferences                        │
│    3. notifyListeners()                                │
│         │                                              │
│         └─→ All widgets using                          │
│             Provider.of<LocaleManager>(context)         │
│             rebuild with new locale                     │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## Persistence Layer

```
┌────────────────────────────────────────────────────────┐
│                  SharedPreferences                     │
│                                                        │
│  Key: "selected_locale"                                │
│  Value: "en" | "zh" | ...                              │
│                                                        │
│  Storage Location:                                     │
│  ┌──────────────────────────────────────────────┐     │
│  │ Android:                                     │     │
│  │ /data/data/com.wrngwrld.chanyan/            │     │
│  │   shared_prefs/FlutterSharedPreferences.xml  │     │
│  │                                              │     │
│  │ iOS:                                         │     │
│  │ NSUserDefaults                               │     │
│  └──────────────────────────────────────────────┘     │
│                                                        │
│  Operations:                                           │
│  - Read: SharedPreferences.getString(key)              │
│  - Write: SharedPreferences.setString(key, value)      │
│                                                        │
│  Lifecycle:                                            │
│  ✓ Survives app restart                               │
│  ✓ Survives device restart                            │
│  ✗ Cleared on app uninstall                           │
│                                                        │
└────────────────────────────────────────────────────────┘
```

## UI Navigation

```
┌────────────────────────────────────────────────────────┐
│                    App Navigation                      │
│                                                        │
│  BoardList (Home)                                      │
│    ├─ Settings                                         │
│    │   ├─ Threads Settings                             │
│    │   ├─ Language Settings ◄─── NEW                   │
│    │   │   └─ Select Language                          │
│    │   │       ├─ English                              │
│    │   │       └─ 简体中文                              │
│    │   ├─ Privacy Settings                             │
│    │   └─ Data Settings                                │
│    │                                                    │
│    └─ Other sections...                                │
│                                                        │
└────────────────────────────────────────────────────────┘
```

## Component Interaction

```
┌──────────────────┐
│  User taps       │
│  Language        │
│  in Settings     │
└────────┬─────────┘
         │
         ▼
┌────────────────────────────┐
│  LanguageSettings Widget   │
│  - Lists supported locales │
│  - Shows current selection │
└────────┬───────────────────┘
         │
         │ User selects "简体中文"
         │
         ▼
┌────────────────────────────┐
│  LocaleManager             │
│  .setLocale(Locale('zh'))  │
└────────┬───────────────────┘
         │
         ├─────────────────────┐
         │                     │
         ▼                     ▼
┌─────────────────┐   ┌──────────────────┐
│ Update State    │   │ Save to Storage  │
│ _locale = zh    │   │ SharedPref.set() │
└────────┬────────┘   └──────────────────┘
         │
         ▼
┌────────────────────┐
│ notifyListeners()  │
└────────┬───────────┘
         │
         ▼
┌──────────────────────────────┐
│  All dependent widgets       │
│  rebuild with new locale     │
│  - Settings page             │
│  - Board list                │
│  - Thread view               │
│  - etc.                      │
└──────────────────────────────┘
```

## Timeline of Events

```
T0: App Installed (First Launch)
    └─→ LocaleManager: No saved locale → Default to 'en'
    └─→ SharedPreferences: empty
    └─→ UI: English

T1: User opens Settings → Language
    └─→ Shows: ● English ✓
    └─→ Shows: ○ 简体中文

T2: User taps "简体中文"
    └─→ setLocale(Locale('zh'))
    └─→ Save 'zh' to SharedPreferences
    └─→ notifyListeners()
    └─→ UI updates to Chinese

T3: User closes app
    └─→ SharedPreferences persisted to disk
    └─→ App in background

T4: User force closes app
    └─→ SharedPreferences still on disk

T5: User reopens app (Next Day)
    └─→ LocaleManager constructor
    └─→ _loadLocale() reads 'zh' from SharedPreferences
    └─→ _locale = Locale('zh')
    └─→ UI loads in Chinese

T6: User uninstalls app
    └─→ SharedPreferences deleted
    └─→ App data removed

T7: User reinstalls app
    └─→ Fresh install, back to T0
    └─→ Default to English
```

## Key Classes

```
LocaleManager
├── Properties
│   └── Locale _locale
│
├── Methods
│   ├── setLocale(Locale)
│   ├── _loadLocale()
│   └── _saveLocale()
│
├── Static Methods
│   ├── supportedLocales
│   ├── isSupported(Locale)
│   └── getLocaleName(Locale)
│
└── Extends
    └── ChangeNotifier (from Provider package)
```

## Integration Points

```
┌─────────────────────────────────────────────────────────┐
│  Where LocaleManager is Used                            │
│                                                         │
│  1. main.dart                                           │
│     └─→ MultiProvider (creates instance)                │
│     └─→ CupertinoApp (reads locale)                     │
│                                                         │
│  2. language_settings.dart                              │
│     └─→ Displays languages                              │
│     └─→ Handles user selection                          │
│                                                         │
│  3. Future: All widgets using localized strings         │
│     └─→ AppLocalizations.of(context)                    │
│         └─→ Uses locale from LocaleManager              │
│                                                         │
└─────────────────────────────────────────────────────────┘
```
