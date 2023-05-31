import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:go_router/go_router.dart';
import 'package:lister_app/extensions.dart';
import 'package:lister_app/generated/l10n.dart';
import 'package:lister_app/language_util.dart';
import 'package:lister_app/voice_assist/commandable_mixin.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with Commandable {
  Locale? currentLanguage;
  late List<Locale> availableLanguages = [];

  @override
  void initState() {
    super.initState();

    LanguageUtil.getPreferredLanguages().then((value) => setState(() => availableLanguages = value));
    LanguageUtil.getCurrentLocale().then((value) => setState(() => currentLanguage = value));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).settings),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(title: const Text('Language & Text'), tiles: [
              SettingsTile(
                title: const Text('Language'),
                value: ListTile(
                  leading: currentLanguage?.let((it) => Flag.fromString(it.countryCode!, width: 30, height: 30 * 0.75)),
                  title: Text(
                      currentLanguage?.let((it) => LocaleNamesLocalizationsDelegate.nativeLocaleNames[it.toString()]) ??
                          '???'),
                ),
                onPressed: (context) {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (_, idx) => ListTile(
                                leading:
                                    Flag.fromString(availableLanguages[idx].countryCode!, width: 30, height: 30 * 0.75),
                                title: Text(LocaleNamesLocalizationsDelegate
                                    .nativeLocaleNames[availableLanguages[idx].toString()]!),
                                selected: currentLanguage == availableLanguages[idx],
                                onTap: () async {
                                  final success = await LanguageUtil.saveLanguage(availableLanguages[idx]);
                                  if (success) {
                                    setState(() {
                                      currentLanguage = availableLanguages[idx];
                                    });
                                  }
                                  if (mounted) context.pop();
                                },
                              ),
                          separatorBuilder: (_, __) => const Divider(),
                          itemCount: availableLanguages.length);
                    },
                    enableDrag: true,
                    isScrollControlled: true,
                  );
                },
              ),
            ]),
            SettingsSection(
              title: const Text('Voice Assistant'),
              tiles: <SettingsTile>[
                SettingsTile.switchTile(
                  onToggle: (value) {},
                  initialValue: true,
                  leading: const Icon(Icons.settings_voice_outlined),
                  title: const Text('Enable voice assistant'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
