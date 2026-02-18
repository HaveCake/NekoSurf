import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chan/blocs/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PermissionDenied extends StatelessWidget {
  const PermissionDenied({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.permissionDeniedTitle,
              style: TextStyle(
                fontSize: 26,
                color: theme.getTheme() == ThemeData.dark()
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              AppLocalizations.of(context)!.permissionDeniedMessage,
              style: TextStyle(
                fontSize: 16,
                color: theme.getTheme() == ThemeData.dark()
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              AppLocalizations.of(context)!.permissionDeniedInstruction,
              style: TextStyle(
                fontSize: 16,
                color: theme.getTheme() == ThemeData.dark()
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CupertinoButton(
              color: theme.getTheme() == ThemeData.dark()
                  ? Colors.white
                  : Colors.black,
              child: Text(
                AppLocalizations.of(context)!.openSystemSettings,
                style: TextStyle(
                  color: theme.getTheme() == ThemeData.dark()
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              onPressed: () {
                AppSettings.openAppSettings(type: AppSettingsType.settings);
              },
            ),
          ],
        ),
      ),
    );
  }
}
