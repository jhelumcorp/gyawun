import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/extensions/context_extensions.dart';
import 'package:readmore/readmore.dart';
import 'package:ytmusic/models/browse_page.dart';

class ArtistPageHeader extends StatelessWidget {
  final YTPageHeader header;
  const ArtistPageHeader({super.key, required this.header});

  List<Widget>_drawItems(BuildContext context) {
    return [
      if (header.thumbnails.lastOrNull?.url != null && context.isWideViewport)
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: header.thumbnails.lastOrNull!.url,
            height: 300,
            width: 300,
          ),
        ),
      if (context.isWideScreen) SizedBox(width: 16),
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
        if (header.title.isNotEmpty && context.isWideViewport)
          Text(header.title, style: Theme.of(context).textTheme.headlineMedium),

        if (header.subtitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              header.subtitle,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        if (header.secondSubtitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              header.secondSubtitle,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        if (header.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: ReadMoreText(
              header.description,
              trimMode: TrimMode.Length,
              style: Theme.of(context).textTheme.bodyLarge,
              trimLines: 3,
            ),
          ),
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
