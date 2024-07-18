import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/l10n.dart';
import '../../../themes/text_styles.dart';
import '../../../utils/adaptive_widgets/adaptive_widgets.dart';
import '../color_icon.dart';
import 'audio_and_playback_screen_data.dart';

class AudioAndPlaybackScreen extends StatelessWidget {
  const AudioAndPlaybackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: Text(S.of(context).Audio_And_Playback,
            style: mediumTextStyle(context, bold: false)),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              ...audioandplaybackScreenData(context).map((e) {
                return AdaptiveListTile(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  title: Text(
                    e.title,
                    style:
                        textStyle(context, bold: false).copyWith(fontSize: 16),
                  ),
                  leading: (e.icon != null)
                      ? ColorIcon(
                          color: e.color,
                          icon: e.icon!,
                        )
                      : null,
                  trailing: e.trailing != null
                      ? e.trailing!(context)
                      : (e.hasNavigation
                          ? Icon(
                              AdaptiveIcons.chevron_right,
                              size: 30,
                            )
                          : null),
                  onTap:
                      (e.hasNavigation && e.location != null) || e.onTap != null
                          ? () {
                              if (e.hasNavigation && e.location != null) {
                                context.go(e.location!);
                              } else if (e.onTap != null) {
                                e.onTap!(context);
                              }
                            }
                          : null,
                  subtitle: e.subtitle != null ? e.subtitle!(context) : null,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
