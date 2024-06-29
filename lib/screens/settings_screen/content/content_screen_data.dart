import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../services/bottom_message.dart';
import '../../../services/settings_manager.dart';
import '../../../themes/text_styles.dart';
import '../../../utils/bottom_modals.dart';
import '../../../ytmusic/ytmusic.dart';
import '../setting_item.dart';

Box _box = Hive.box('SETTINGS');

List<SettingItem> contentScreenData(BuildContext context) => [
      SettingItem(
        title: S.of(context).country,
        icon: CupertinoIcons.placemark,
        hasNavigation: false,
        trailing: (context) {
          return Text(
            context.watch<SettingsManager>().location['name']!,
            style: smallTextStyle(context),
          );
        },
        onTap: (context) {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return BottomModalLayout(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 600 ? 600 : null,
                  child: Column(
                    children: [
                      AppBar(
                        title: Text(
                          "Location",
                          style: textStyle(context).copyWith(fontSize: 18),
                        ),
                        centerTitle: true,
                        automaticallyImplyLeading: false,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(children: [
                            ...context
                                .read<SettingsManager>()
                                .locations
                                .map((location) {
                              return ListTile(
                                dense: true,
                                visualDensity: VisualDensity.compact,
                                title: Text(location['name']!),
                                onTap: () async {
                                  Navigator.pop(context);
                                  context.read<SettingsManager>().location =
                                      location;
                                },
                              );
                            }),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      SettingItem(
          title: S.of(context).language,
          icon: CupertinoIcons.globe,
          onTap: (context) {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return BottomModalLayout(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width > 600 ? 600 : null,
                    child: Column(
                      children: [
                        AppBar(
                          title: Text(
                            S.of(context).selectLanguage,
                            style: textStyle(context).copyWith(fontSize: 18),
                          ),
                          centerTitle: true,
                          automaticallyImplyLeading: false,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(children: [
                              ...context
                                  .read<SettingsManager>()
                                  .languages
                                  .map((language) {
                                return ListTile(
                                  dense: true,
                                  visualDensity: VisualDensity.compact,
                                  title: Text(language['name']!),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    context.read<SettingsManager>().language =
                                        language;
                                  },
                                );
                              }),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          trailing: (context) {
            return Text(
              context.watch<SettingsManager>().language['name']!,
              style: smallTextStyle(context),
            );
          }),
      SettingItem(
        title: 'Personalised Content',
        icon: Icons.recommend_outlined,
        onTap: (context) async {
          Modals.showCenterLoadingModal(context);
          bool isEnabled = _box.get('PERSONALISED_CONTENT', defaultValue: true);
          await _box.put('PERSONALISED_CONTENT', !isEnabled);
          await GetIt.I<YTMusic>().resetVisitorId();

          if (context.mounted) {
            context.pop();
          }
        },
        trailing: (context) {
          return ValueListenableBuilder(
            valueListenable: _box.listenable(keys: ['PERSONALISED_CONTENT']),
            builder: (context, value, child) {
              bool isEnabled =
                  value.get('PERSONALISED_CONTENT', defaultValue: true);
              return CupertinoSwitch(
                  value: isEnabled,
                  onChanged: (val) async {
                    Modals.showCenterLoadingModal(context);
                    await value.put('PERSONALISED_CONTENT', val);
                    await GetIt.I<YTMusic>().resetVisitorId();

                    if (context.mounted) {
                      context.pop();
                    }
                  });
            },
          );
        },
      ),
      SettingItem(
        title: 'Enter Visitor Id',
        icon: Icons.edit,
        onTap: (context) async {
          String? text = await Modals.showTextField(
            context,
            title: 'Enter Visitor id',
            hintText: 'Visitor id',
          );
          if (text != null) {
            await _box.put('VISITOR_ID', text);
          }
          GetIt.I<YTMusic>().refreshHeaders();
        },
      ),
      SettingItem(
        title: 'Reset Visitor Id',
        icon: CupertinoIcons.refresh_thick,
        onTap: (context) async {
          Modals.showCenterLoadingModal(context);
          await GetIt.I<YTMusic>().resetVisitorId();
          if (context.mounted) {
            context.pop();
          }
        },
        trailing: (_box.get('VISITOR_ID', defaultValue: '') ?? '').isEmpty
            ? null
            : (context) => IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                            text:
                                _box.get('VISITOR_ID', defaultValue: '') ?? ''))
                        .then((val) {
                      GetIt.I<YTMusic>().refreshHeaders();
                      BottomMessage.showText(context, 'Copied to clipboard');
                    });
                  },
                  icon: const Icon(Icons.copy),
                ),
        subtitle: (context) {
          return ValueListenableBuilder(
            valueListenable: _box.listenable(keys: ['VISITOR_ID']),
            builder: (context, value, child) {
              return Text(
                value.get('VISITOR_ID', defaultValue: '') ?? '',
                style: tinyTextStyle(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            },
          );
        },
      ),
    ];
