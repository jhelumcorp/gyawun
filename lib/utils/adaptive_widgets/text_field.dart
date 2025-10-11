import 'package:flutter/material.dart';

class AdaptiveTextField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final bool readOnly;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputType? keyboardType;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final bool autofocus;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final BorderRadius borderRadius;
  final double borderWidth;
  const AdaptiveTextField({
    super.key,
    this.controller,
    this.onTap,
    this.contentPadding,
    this.fillColor,
    this.focusNode,
    this.hintText,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.prefix,
    this.suffix,
    this.textInputAction,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.borderWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: key,
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      focusNode: focusNode,
      readOnly: readOnly,
      keyboardType: keyboardType,
      autofocus: autofocus,
      maxLines: maxLines,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        fillColor: fillColor,
        filled: fillColor != null,
        contentPadding: contentPadding,
        hintText: hintText,
        prefixIcon: prefix,
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderSide: borderWidth > 0
              ? BorderSide(width: borderWidth)
              : BorderSide.none,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
