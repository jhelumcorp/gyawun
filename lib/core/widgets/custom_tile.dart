import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final Widget title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final void Function()? onTap;
  final bool isFirst;
  final bool isLast;
  const CustomTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.leading,
    this.trailing,
    this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.only(
            topLeft: Radius.circular(isFirst ? 20 : 4),
            topRight: Radius.circular(isFirst ? 20 : 4),
            bottomLeft: Radius.circular(isLast ? 20 : 4),
            bottomRight: Radius.circular(isLast ? 20 : 4),
          ),
        ),
        tileColor: Theme.of(context).colorScheme.surfaceContainer,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: title,
        // title: Text(
        //   title,
        //   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        //     fontSize: 16,
        //     fontWeight: FontWeight.w500,
        //   ),
        // ),
        leading: leading,
        subtitle: subtitle != null
            ? Text(subtitle!, style: Theme.of(context).textTheme.labelLarge)
            : null,
        trailing: trailing,
      ),
    );
  }
}
