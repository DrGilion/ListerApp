import 'package:flutter/material.dart';
import 'package:lister_app/voice_assist/commandable_mixin.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>  with Commandable{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SettingsList(
          sections: [
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
