# String Externalization Guide

This document describes the string externalization implemented in the NekoSurf project and provides examples of how hardcoded strings were replaced with centralized constants.

## Overview

All user-facing strings have been extracted from the codebase and centralized in two locations:

1. **Android**: `android/app/src/main/res/values/strings.xml` - For Android-specific resources
2. **Flutter/Dart**: `lib/constants/app_strings.dart` - For all Dart code

## Files Created

### 1. `android/app/src/main/res/values/strings.xml`

This file contains Android string resources, including the app name which is now referenced in `AndroidManifest.xml`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">NekoSurf</string>
    <!-- ... other strings ... -->
</resources>
```

### 2. `lib/constants/app_strings.dart`

This file contains all user-facing strings as static constants in the `AppStrings` class.

```dart
class AppStrings {
  static const String appName = "NekoSurf";
  static const String add = "Add";
  static const String cancel = "Cancel";
  // ... other strings ...
}
```

## Replacement Examples

### Example 1: Simple Text Widget

**Before:**
```dart
Text('Cancel')
```

**After:**
```dart
import 'package:flutter_chan/constants/app_strings.dart';

Text(AppStrings.cancel)
```

### Example 2: Const Text Widget

**Before:**
```dart
const Text('Delete')
```

**After:**
```dart
import 'package:flutter_chan/constants/app_strings.dart';

const Text(AppStrings.delete)
```

### Example 3: Label Property

**Before:**
```dart
SlidableAction(
  label: 'Remove',
  // ...
)
```

**After:**
```dart
import 'package:flutter_chan/constants/app_strings.dart';

SlidableAction(
  label: AppStrings.remove,
  // ...
)
```

### Example 4: SnackBar Message

**Before:**
```dart
showCupertinoSnackbar(
  const Duration(milliseconds: 1800),
  true,
  context,
  'File downloaded!',
)
```

**After:**
```dart
import 'package:flutter_chan/constants/app_strings.dart';

showCupertinoSnackbar(
  const Duration(milliseconds: 1800),
  true,
  context,
  AppStrings.fileDownloaded,
)
```

### Example 5: Android Manifest

**Before:**
```xml
<application android:label="NekoSurf" ...>
```

**After:**
```xml
<application android:label="@string/app_name" ...>
```

## Complete List of Externalized Strings

### App Metadata
- `appName`: "NekoSurf"

### Common Actions
- `add`: "Add"
- `cancel`: "Cancel"
- `delete`: "Delete"
- `download`: "Download"
- `remove`: "Remove"
- `share`: "Share"

### Settings
- `settingsThreads`: "Threads"
- `settingsPrivacy`: "Privacy"
- `settingsData`: "Data"

### Data Settings
- `cacheSize`: "Cache Size"
- `deleteCache`: "Delete Cache"
- `watchedMediaRetentionPeriod`: "Watched Media Retention Period"
- `selectRetentionPeriod`: "Select retention period"
- `clearWatchedMediaHistory`: "Clear Watched Media History"

### Bookmarks
- `sortNewest`: "Newest"
- `sortOldest`: "Oldest"
- `clearBookmarks`: "Clear bookmarks"
- `removeBookmark`: "Remove bookmark"
- `setBookmark`: "Set bookmark"

### Media
- `deleteAttachmentTitle`: "Delete Attachment?"
- `openInBrowser`: "Open in Browser"

### Boards
- `openLink`: "Open Link"

### Threads
- `replies`: "Replies"

### Permissions
- `permissionDeniedTitle`: "Permission denied!"
- `permissionDeniedMessage`: "To use this feature, you need to grant the app permission to access your storage."
- `permissionDeniedInstruction`: "Go to your device settings and enable the Full Access permission to the Photos for this app."
- `openSystemSettings`: "Open System Settings"

### File Operations
- `fileSaved`: "File saved!"
- `fileDownloaded`: "File downloaded!"
- `downloading`: "Downloading..."
- `fileConverting`: "File converting..."
- `downloadFailed`: "Download failed :("

## Files Modified

The following files were modified to use the centralized strings:

1. `android/app/src/main/AndroidManifest.xml`
2. `lib/API/save_videos.dart`
3. `lib/pages/board/board_page.dart`
4. `lib/pages/board/grid_post.dart`
5. `lib/pages/board/list_post.dart`
6. `lib/pages/boards/board_list.dart`
7. `lib/pages/boards/board_tile.dart`
8. `lib/pages/bookmarks/bookmarks.dart`
9. `lib/pages/bookmarks/bookmarks_post.dart`
10. `lib/pages/media_page.dart`
11. `lib/pages/savedAttachments/permission_denied.dart`
12. `lib/pages/savedAttachments/saved_attachments.dart`
13. `lib/pages/settings/setting_pages/data_settings.dart`
14. `lib/pages/settings/settings.dart`
15. `lib/pages/thread/thread_page.dart`
16. `lib/pages/thread/thread_replied_to.dart`
17. `lib/pages/thread/thread_replies.dart`

## Benefits

1. **Centralized Management**: All user-facing strings are in one place, making them easy to find and update
2. **Consistency**: Reduces duplication and ensures consistent wording across the app
3. **Localization Ready**: Makes it easier to add support for multiple languages in the future
4. **Maintainability**: Changes to text only need to be made in one location
5. **Type Safety**: Using const strings provides compile-time checking

## Future Enhancements

To add full localization support, consider:

1. Using the `intl` package (already in dependencies)
2. Creating ARB (Application Resource Bundle) files
3. Implementing `LocalizationsDelegate` for runtime locale switching
4. Using Flutter's `l10n` generation tools

## Testing

To verify the changes:

1. Build the app: `flutter build apk` or `flutter build ios`
2. Run the app: `flutter run`
3. Navigate through all screens to verify strings display correctly
4. Test all interactive elements (buttons, dialogs, snackbars)

## Adding New Strings

When adding new user-facing strings:

1. Add the string to `lib/constants/app_strings.dart`:
   ```dart
   static const String myNewString = "My New String";
   ```

2. Add to `android/app/src/main/res/values/strings.xml` if needed for Android:
   ```xml
   <string name="my_new_string">My New String</string>
   ```

3. Import and use in your code:
   ```dart
   import 'package:flutter_chan/constants/app_strings.dart';
   
   Text(AppStrings.myNewString)
   ```

## Notes

- All string constants use camelCase naming convention in Dart
- Android XML strings use snake_case naming convention
- The `const` keyword is used where possible for compile-time constants
- Strings with special characters are properly escaped
