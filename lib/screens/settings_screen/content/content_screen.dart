import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../themes/text_styles.dart';
import '../color_icon.dart';
import 'content_screen_data.dart';

class ContentScreen extends StatelessWidget {
  const ContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Content', style: mediumTextStyle(context, bold: false)),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ...contentScreenData(context).map((e) {
            return ListTile(
              title: Text(
                e.title,
                style: textStyle(context, bold: false).copyWith(fontSize: 16),
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
                      ? const Icon(
                          CupertinoIcons.chevron_right,
                          size: 30,
                        )
                      : null),
              onTap: () {
                if (e.hasNavigation && e.location != null) {
                  context.go(e.location!);
                } else if (e.onTap != null) {
                  e.onTap!(context);
                }
              },
              subtitle: e.subtitle != null ? e.subtitle!(context) : null,
            );
          }),
        ],
      ),
    );
  }
}
