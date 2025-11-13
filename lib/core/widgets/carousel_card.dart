import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/utils/item_click_handler.dart';
import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/utils/pretty_print.dart';

class CarouselCard extends StatelessWidget {
  const CarouselCard({super.key, required this.item});
  final SectionItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            CachedNetworkImage(
              imageUrl:
                  (item.thumbnails.length >= 2 ? item.thumbnails[1] : item.thumbnails.last).url,
              width: (item.thumbnails.length >= 2 ? item.thumbnails[1] : item.thumbnails.last).width
                  .toDouble(),
              height: (item.thumbnails.length >= 2 ? item.thumbnails[1] : item.thumbnails.last)
                  .height
                  .toDouble(),
              fit: BoxFit.cover,
              errorWidget: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                );
              },
            ),
            // Dark gradient overlay for better text readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            // Text Content
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  pprint(item.type);
                  onSectionItemTap(context, item);
                },
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                          shadows: [
                            Shadow(color: Colors.black45, offset: Offset(2, 2), blurRadius: 4),
                          ],
                        ),
                      ),
                      if (item.subtitle != null) const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarouselItem {
  const CarouselItem({required this.title, required this.subtitle, required this.imageUrl});
  final String title;
  final String subtitle;
  final String imageUrl;
}
