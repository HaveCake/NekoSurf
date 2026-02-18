import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chan/blocs/locale_manager.dart';
import 'package:flutter_chan/blocs/theme.dart';
import 'package:provider/provider.dart';

/// Settings page for language/locale selection
class LanguageSettings extends StatelessWidget {
  const LanguageSettings({Key? key}) : super(key: key);

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
                  onTap: () {
                    localeManager.setLocale(locale);
                  },
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
