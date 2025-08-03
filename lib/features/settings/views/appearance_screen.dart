import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gyawun_music/core/extensions/context_extensions.dart';
import 'package:yaru/widgets.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: context.isDesktop
          ? YaruWindowTitleBar(
              leading: Navigator.of(context).canPop() ? YaruBackButton() : null,
              title: Text("Appearance"),
            )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 100,
              pinned: true,
              leading: context.isDesktop ? SizedBox.shrink() : BackButton(),
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  if (context.isDesktop) {
                    return Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Positioned(
                          left: 16,
                          bottom: 16,
                          child: Text(
                            'Settings',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ],
                    );
                  }
                  final double maxExtent = 100;
                  final double minExtent = kToolbarHeight;
                  final double currentExtent = constraints.biggest.height;

                  final double t =
                      ((currentExtent - minExtent) / (maxExtent - minExtent))
                          .clamp(0.0, 1.0);

                  final double leftPadding = lerpDouble(
                    kToolbarHeight,
                    16.0,
                    t,
                  )!;
                  final double bottomPadding = lerpDouble(16.0, 0.0, t)!;

                  return Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Positioned(
                        left: leftPadding,
                        bottom: bottomPadding,
                        child: Text(
                          'Settings',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ];
        },
        body: CustomScrollView(),
      ),
    );
  }
}
