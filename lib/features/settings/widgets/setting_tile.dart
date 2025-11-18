import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final void Function()? onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
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
          leading: leading == null
              ? null
              : Container(
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
    this.leading,
    this.onChanged,
    this.isFirst = false,
    this.isLast = false,
    this.subtitle,
    this.disabled = false,
    this.dense,
  });
  final bool value;
  final String title;
  final Widget? leading;
  final String? subtitle;
  final bool disabled;

  final ValueChanged<bool>? onChanged;
  final bool isFirst;
  final bool isLast;
  final bool? dense;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: Colors.transparent,
        child: SwitchListTile(
          dense: dense,
          value: value,
          onChanged: disabled ? null : onChanged,
          enableFeedback: true,
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

          secondary: leading == null
              ? null
              : Container(
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

class SettingExpansionTile extends StatefulWidget {
  const SettingExpansionTile({
    super.key,
    required this.title,
    required this.leading,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.isFirst = false,
    this.isLast = false,
    this.children = const [],
  });
  final String title;
  final Widget leading;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isFirst;
  final bool isLast;
  final List<Widget> children;

  @override
  State<SettingExpansionTile> createState() => _SettingExpansionTileState();
}

class _SettingExpansionTileState extends State<SettingExpansionTile> {
  late ExpansibleController controller;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    controller = ExpansibleController()..addListener(listener);
  }

  void listener() {
    setState(() {
      isExpanded = controller.isExpanded;
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(listener);
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      controller: controller,

      enableFeedback: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.only(
          topLeft: Radius.circular(widget.isFirst ? 20 : 4),
          topRight: Radius.circular(widget.isFirst ? 20 : 4),
          bottomLeft: Radius.circular(widget.isLast ? 20 : 4),
          bottomRight: Radius.circular(widget.isLast ? 20 : 4),
        ),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.only(
          topLeft: Radius.circular(widget.isFirst ? 20 : 4),
          topRight: Radius.circular(widget.isFirst ? 20 : 4),
          bottomLeft: Radius.circular(widget.isLast ? 20 : 4),
          bottomRight: Radius.circular(widget.isLast ? 20 : 4),
        ),
      ),

      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      collapsedBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),

      title: Text(
        widget.title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      subtitle: widget.subtitle != null
          ? Text(widget.subtitle!, style: Theme.of(context).textTheme.labelLarge)
          : null,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withAlpha(150),
          borderRadius: BorderRadius.circular(12),
        ),
        child: widget.leading,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isExpanded ? FluentIcons.chevron_down_24_filled : FluentIcons.chevron_right_24_filled,
          ),
          Switch(value: widget.value, onChanged: widget.onChanged),
        ],
      ),
      children: widget.children,
    );
  }
}

class SliverSettingTile extends StatelessWidget {
  const SliverSettingTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.leading,
    this.trailing,
    this.onTap,
    this.isFirst = false,
    this.isLast = false,
    this.margin = const EdgeInsetsGeometry.symmetric(horizontal: 16),
  });

  final String title;
  final String? subtitle;
  final Widget leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isFirst;
  final bool isLast;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: margin,
      sliver: SliverToBoxAdapter(
        child: SettingTile(
          title: title,
          subtitle: subtitle,
          leading: leading,
          trailing: trailing,
          onTap: onTap,
          isFirst: isFirst,
          isLast: isLast,
        ),
      ),
    );
  }
}
