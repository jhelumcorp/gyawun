import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/extensions/context_extensions.dart';
import 'package:ytmusic/models/browse_page.dart';

class PageHeader extends StatelessWidget {
  final YTPageHeader header;
  const PageHeader({super.key, required this.header});

  _drawItems(BuildContext context) {
    return [
      if (header.thumbnails.lastOrNull?.url != null)
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: header.thumbnails.lastOrNull!.url,
            height: 300,
            width: 300,
          ),
        ),
      SizedBox(
        height: context.isWideViewport ? 0 : 16,
        width: context.isWideViewport ? 16 : 0,
      ),
      context.isWideViewport
          ? Expanded(child: _drawDescription(context))
          : _drawDescription(context),
    ];
  }

  Widget _drawDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: context.isWideViewport
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Text(header.title, style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: 8),
        Text(header.subtitle, style: Theme.of(context).textTheme.bodyLarge),
        SizedBox(height: 4),
        Text(
          header.secondSubtitle,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(height: 4),
        Text(header.description, style: Theme.of(context).textTheme.bodyLarge),
        SizedBox(height: 4),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            if (header.playEndpoint != null)
              FilledButton.icon(
                onPressed: () {},
                label: Text("Play"),
                icon: Icon(Icons.play_arrow_rounded),
              ),
            if (header.shuffleEndpoint != null)
              FilledButton.icon(
                onPressed: () {},
                label: Text("Shuffle"),
                icon: Icon(Icons.shuffle_rounded),
              ),
            if (header.radioEndpoint != null)
              FilledButton.icon(
                onPressed: () {},
                label: Text("Radio"),
                icon: Icon(Icons.radar_outlined),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return context.isWideViewport
        ? Row(children: _drawItems(context))
        : Column(children: _drawItems(context));
  }
}
