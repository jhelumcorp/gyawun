import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;

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
    if (Platform.isWindows) {
      return fluent_ui.TextBox(
        key: key,
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        onTap: onTap,
        focusNode: focusNode,
        readOnly: readOnly,
        keyboardType: keyboardType,
        padding: contentPadding ?? const EdgeInsets.symmetric(),
        placeholder: hintText,
        prefix: prefix != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: prefix,
              )
            : null,
        suffix: suffix != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: suffix,
              )
            : null,
        autofocus: autofocus,
        maxLines: maxLines,
        textInputAction: textInputAction,
        decoration: WidgetStatePropertyAll(BoxDecoration(
          color: fillColor,
          borderRadius: borderRadius,
          border: borderWidth > 0 ? Border.all(width: borderWidth) : null,
        )),
      );
    }
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
