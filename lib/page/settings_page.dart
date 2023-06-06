import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:go_router/go_router.dart';
import 'package:lister_app/generated/l10n.dart';
import 'package:lister_app/util/extensions.dart';
import 'package:lister_app/util/language_util.dart';
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
          title: Text(Translations.of(context).settings),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(title: Text(Translations.of(context).settings_language), tiles: [
              SettingsTile(
                title: Text(Translations.of(context).language),
                value: ListTile(
                  leading: currentLanguage?.let((it) => LanguageUtil.getFlagForLocale(it)?.let((flag) => Text(flag))),
                  title: Text(
                      currentLanguage?.let((it) => LocaleNamesLocalizationsDelegate.nativeLocaleNames[it.languageCode]) ??
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
                                    Text(LanguageUtil.getFlagForLocale(availableLanguages[idx])!),
                                title: Text(LocaleNamesLocalizationsDelegate
                                    .nativeLocaleNames[availableLanguages[idx].languageCode]!),
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
              title: Text(Translations.of(context).voice_assistant),
              tiles: <SettingsTile>[
                SettingsTile.switchTile(
                  onToggle: (value) {},
                  initialValue: true,
                  leading: const Icon(Icons.settings_voice_outlined),
                  title: Text(Translations.of(context).voice_assistant_enable),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
