import 'package:flutter/material.dart';
import 'package:ytmusic/models/section.dart';

import '../browse/yt_browse_screen.dart';

class SectionHeader extends StatelessWidget {
  final YTSection section;
  const SectionHeader({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              section.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
          if (section.trailing != null)
            TextButton.icon(
              iconAlignment: IconAlignment.end,
              onPressed: () {
                if (section.trailing!.isPlayable == false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => YTBrowseScreen(
                        body: section.trailing!.endpoint.cast(),
                      ),
                    ),
                  );
                }
              },
              icon: Icon(
                section.trailing!.isPlayable
                    ? Icons.play_arrow
                    : Icons.arrow_forward,
              ),
              label: Text(section.trailing!.text),
            ),
        ],
      ),
    );
  }
}
