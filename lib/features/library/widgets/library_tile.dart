import 'package:flutter/material.dart';

class LibraryTile extends StatelessWidget {
  const LibraryTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.leadingIcon,
    this.trailing,
    this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? leadingIcon;
  final Widget? trailing;
  final void Function()? onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainer,
        shadowColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.only(
            topLeft: Radius.circular(isFirst ? 20 : 4),
            topRight: Radius.circular(isFirst ? 20 : 4),
            bottomLeft: Radius.circular(isLast ? 20 : 4),
            bottomRight: Radius.circular(isLast ? 20 : 4),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isFirst ? 20 : 4),
            topRight: Radius.circular(isFirst ? 20 : 4),
            bottomLeft: Radius.circular(isLast ? 20 : 4),
            bottomRight: Radius.circular(isLast ? 20 : 4),
          ),
          onTap: onTap == null ? null : () => onTap!(),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                if (leading == null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withAlpha(150),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: leadingIcon ?? const Icon(Icons.queue_music_rounded, size: 30),
                  )
                else
                  leading!,
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      if (subtitle != null)
                        Text(subtitle!, maxLines: 1, style: Theme.of(context).textTheme.labelLarge),
                    ],
                  ),
                ),
                if (trailing != null) const SizedBox(width: 8),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ListTile(
//           onTap: onTap,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadiusGeometry.only(
          //     topLeft: Radius.circular(isFirst ? 20 : 4),
          //     topRight: Radius.circular(isFirst ? 20 : 4),
          //     bottomLeft: Radius.circular(isLast ? 20 : 4),
          //     bottomRight: Radius.circular(isLast ? 20 : 4),
          //   ),
          // ),
//           tileColor: Theme.of(context).colorScheme.surfaceContainer,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          // title: Text(
          //   title,
          //   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          //     fontSize: 16,
          //     fontWeight: FontWeight.w600,
          //     color: Theme.of(context).colorScheme.primary,
          //   ),
          // ),
//           leading: leading == null
//               ? null
//               : Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.primaryContainer.withAlpha(150),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: leading,
//                 ),
          // subtitle: subtitle != null
          //     ? Text(subtitle!, style: Theme.of(context).textTheme.labelLarge)
          //     : null,
//           trailing: trailing,
//         ),