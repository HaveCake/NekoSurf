import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chan/blocs/locale_manager.dart';
import 'package:flutter_chan/blocs/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Settings page for language/locale selection
class LanguageSettings extends StatelessWidget {
  const LanguageSettings({Key? key}) : super(key: key);

  Future<void> _changeLanguage(BuildContext context, Locale locale) async {
    final localeManager = Provider.of<LocaleManager>(context, listen: false);
    
    // Don't do anything if same language
    if (localeManager.locale == locale) return;

    // Show confirmation dialog
    final bool? confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context)!.changeLanguage),
          content: Text(
            '${AppLocalizations.of(context)!.changeLanguageMessage}\n\n'
            '${LocaleManager.getLocaleName(locale)}',
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(AppLocalizations.of(context)!.change),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Change the locale
      await localeManager.setLocale(locale);
      
      // Pop back to settings
      if (context.mounted) {
        Navigator.of(context).pop();
        
        // The app will automatically rebuild with the new locale via Provider
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    final localeManager = Provider.of<LocaleManager>(context);

    return CupertinoPageScaffold(
      backgroundColor: theme.getTheme() == ThemeData.light()
          ? CupertinoColors.systemGroupedBackground
          : CupertinoColors.black,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: theme.getTheme() == ThemeData.light()
            ? CupertinoColors.systemBackground
            : const Color.fromARGB(255, 20, 20, 20),
        middle: const Text('Language / 语言'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListSection.insetGrouped(
              header: const Text('SELECT LANGUAGE'),
              children: LocaleManager.supportedLocales.map((locale) {
                final isSelected = localeManager.locale == locale;
                return CupertinoListTile(
                  title: Text(LocaleManager.getLocaleName(locale)),
                  subtitle: Text(locale.languageCode.toUpperCase()),
                  trailing: isSelected
                      ? const Icon(
                          CupertinoIcons.check_mark,
                          color: CupertinoColors.activeBlue,
                        )
                      : null,
                  onTap: () => _changeLanguage(context, locale),
                );
              }).toList(),
            ),
            CupertinoListSection.insetGrouped(
              header: const Text('INFORMATION'),
              children: [
                CupertinoListTile(
                  title: const Text('Current Language'),
                  subtitle: Text(
                    LocaleManager.getLocaleName(localeManager.locale),
                  ),
                ),
                const CupertinoListTile(
                  title: Text('Language Persistence'),
                  subtitle: Text(
                    'Your language selection is saved and will persist across app restarts.',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
