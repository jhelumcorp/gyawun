import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.leading,
    this.trailing,
    this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });
  final String title;
  final String? subtitle;
  final Widget leading;
  final Widget? trailing;
  final void Function()? onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withAlpha(150),
              borderRadius: BorderRadius.circular(12),
            ),
            child: leading,
          ),
          subtitle: subtitle != null
              ? Text(subtitle!, style: Theme.of(context).textTheme.labelLarge)
              : null,
          trailing: trailing,
        ),
      ),
    );
  }
}

class SettingSwitchTile extends StatelessWidget {
  const SettingSwitchTile({
    super.key,
    required this.value,
    required this.title,
    required this.leading,
    this.onChanged,
    this.isFirst = false,
    this.isLast = false,
    this.subtitle,
  });
  final bool value;
  final String title;
  final Widget leading;
  final String? subtitle;

  final ValueChanged<bool>? onChanged;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        child: SwitchListTile(
          value: value,
          onChanged: onChanged,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.only(
              topLeft: Radius.circular(isFirst ? 20 : 4),
              topRight: Radius.circular(isFirst ? 20 : 4),
              bottomLeft: Radius.circular(isLast ? 20 : 4),
              bottomRight: Radius.circular(isLast ? 20 : 4),
            ),
          ),
          tileColor: Theme.of(context).colorScheme.surfaceContainer,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          subtitle: subtitle != null
              ? Text(subtitle!, style: Theme.of(context).textTheme.labelLarge)
              : null,

          secondary: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withAlpha(150),
              borderRadius: BorderRadius.circular(12),
            ),
            child: leading,
          ),
        ),
      ),
    );
  }
}
