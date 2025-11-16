import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialog_tile_data.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialogs.dart';
import 'package:gyawun_music/features/services/yt_music/home/yt_home_screen.dart';
import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/jio_saavn/home/js_home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  DataProvider provider = DataProvider.ytmusic;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        requestNotificationPermission();
      });
    }
  }

  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gyawun"),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
        actions: [
          IconButton.filled(
            isSelected: false,
            onPressed: _showProviderDialog,
            icon: SvgPicture.asset(
              'assets/svgs/${provider == DataProvider.ytmusic ? 'youtube_music' : 'jio_saavn'}.svg',
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurfaceVariant,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),

      body: (provider == DataProvider.ytmusic) ? const YTHomeScreen() : const JSHomeScreen(),
    );
  }

  Future<void> _showProviderDialog() async {
    final value = await AppDialogs.showOptionSelectionDialog(
      context,
      title: "Select Provider",
      children: [
        AppDialogTileData(
          title: 'YT Music',
          value: DataProvider.ytmusic,
          icon: SvgPicture.asset(
            'assets/svgs/youtube_music.svg',
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onSurfaceVariant,
              BlendMode.srcIn,
            ),
          ),
        ),
        AppDialogTileData(
          title: 'Jio Saavn',
          value: DataProvider.jiosavan,
          icon: SvgPicture.asset(
            'assets/svgs/jio_saavn.svg',
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onSurfaceVariant,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
    if (value != null) {
      setState(() {
        provider = value;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
