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
import '../../../utils/adaptive_widgets/adaptive_widgets.dart';
import '../../../utils/bottom_modals.dart';
import '../../../ytmusic/ytmusic.dart';
import '../setting_item.dart';

Box _box = Hive.box('SETTINGS');

List<SettingItem> contentScreenData(BuildContext context) => [
      SettingItem(
        title: S.of(context).Country,
        icon: CupertinoIcons.placemark,
        hasNavigation: false,
        trailing: (context) {
          return AdaptiveDropdownButton(
            value: context.watch<SettingsManager>().location,
            items: context
                .read<SettingsManager>()
                .locations
                .map(
                  (location) => AdaptiveDropdownMenuItem(
                    value: location,
                    child: Text(
                      textAlign: TextAlign.right,
                      location['name']!,
                      style: smallTextStyle(context),
                      maxLines: 2,
                    ),
                  ),
                )
                .toList(),
            onChanged: (location) {
              context.read<SettingsManager>().location = location!;
            },
          );
        },
      ),
      SettingItem(
        title: S.of(context).Language,
        icon: CupertinoIcons.globe,
        trailing: (context) {
          return AdaptiveDropdownButton(
            value: context.watch<SettingsManager>().language,
            items: context
                .read<SettingsManager>()
                .languages
                .map(
                  (language) => AdaptiveDropdownMenuItem(
                    value: language,
                    child: Text(
                      language['name']!,
                      style: smallTextStyle(context),
                      textAlign: TextAlign.end,
                    ),
                  ),
                )
                .toList(),
            onChanged: (language) {
              context.read<SettingsManager>().language = language!;
            },
          );
        },
      ),
      SettingItem(
        title: S.of(context).Personalised_Content,
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
              return AdaptiveSwitch(
                value: value.get('PERSONALISED_CONTENT', defaultValue: true),
                onChanged: (val) async {
                  Modals.showCenterLoadingModal(context);
                  await value.put('PERSONALISED_CONTENT', val);
                  await GetIt.I<YTMusic>().resetVisitorId();

                  if (context.mounted) {
                    context.pop();
                  }
                },
              );
            },
          );
        },
      ),
      SettingItem(
        title: S.of(context).Enter_Visitor_Id,
        icon: Icons.edit,
        onTap: (context) async {
          String? text = await Modals.showTextField(
            context,
            title: S.of(context).Enter_Visitor_Id,
            hintText: S.of(context).Visitor_Id,
          );
          if (text != null) {
            await _box.put('VISITOR_ID', text);
          }
          GetIt.I<YTMusic>().refreshHeaders();
        },
      ),
      SettingItem(
        title: S.of(context).Reset_Visitor_Id,
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
                      BottomMessage.showText(
                          context, S.of(context).Copied_To_Clipboard);
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
