import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/l10n/generated/app_localizations.dart';
import 'package:gyawun_music/services/settings/settings_service.dart';
import 'package:ytmusic/yt_music_base.dart';

class SettingUpScreen extends StatefulWidget {
  const SettingUpScreen({super.key});

  @override
  State<SettingUpScreen> createState() => _SettingUpScreenState();
}

class _SettingUpScreenState extends State<SettingUpScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      init();
    });
  }

  Future<void> init() async {
    final c = sl<YTMusic>().config;
    if (c.visitorData.trim().isEmpty) {
      final config = await YTMusic.fetchConfig();
      if (config != null) {
        sl<YTMusic>().setConfig(config);

        sl<SettingsService>().youtubeMusic.setVisitorId(config.visitorData);
      }
    }
    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            Text(
              AppLocalizations.of(context)!.settingUp,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
