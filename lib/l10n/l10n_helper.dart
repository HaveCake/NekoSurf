/// Extension methods to access localized strings
/// 
/// Usage:
/// - In widgets with BuildContext: context.l10n.appName

import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  /// Get the current app localizations
  AppLocalizations get l10n {
    return AppLocalizations.of(this)!;
  }
}
