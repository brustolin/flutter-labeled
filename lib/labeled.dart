library labeled;

import 'package:flutter/material.dart';

class LabeledStyle extends InheritedTheme {
  final LabeledFormat format;
  final TextStyle labelStyle;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const LabeledStyle(
      {Key key,
      this.labelStyle,
      this.format,
      this.spacing,
      this.mainAxisAlignment,
      this.crossAxisAlignment,
      @required Widget child})
      : super(key: key, child: child);

  const LabeledStyle.fallback({Key key})
      : format = LabeledFormat.above,
        spacing = 0,
        labelStyle = const TextStyle(fontSize: 10),
        crossAxisAlignment = CrossAxisAlignment.start,
        mainAxisAlignment = MainAxisAlignment.start,
        super(key: key, child: null);

  static LabeledStyle of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LabeledStyle>() ??
        const LabeledStyle.fallback();
  }

  @override
  bool updateShouldNotify(LabeledStyle oldWidget) =>
      format != oldWidget.format ||
      labelStyle != oldWidget.labelStyle ||
      spacing != oldWidget.spacing ||
      crossAxisAlignment != oldWidget.crossAxisAlignment ||
      mainAxisAlignment != oldWidget.mainAxisAlignment;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final LabeledStyle defaultTextStyle =
        context.findAncestorWidgetOfExactType<LabeledStyle>();
    return identical(this, defaultTextStyle)
        ? child
        : LabeledStyle(
            format: format,
            labelStyle: labelStyle,
            spacing: spacing,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisAlignment: mainAxisAlignment,
            child: child,
          );
  }
}

enum LabeledFormat { above, beside, across }

class Labeled extends StatelessWidget {
  final String label;
  final Widget child;
  final LabeledFormat format;
  final double spacing;
  final TextStyle labelStyle;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const Labeled(
      this.label,
      {Key key,
      this.child,
      this.format,
      this.labelStyle,
      this.spacing,
      this.crossAxisAlignment,
      this.mainAxisAlignment})
      : super(key: key);

  Widget _spacing(LabeledFormat format) => format == LabeledFormat.above
      ? SizedBox(height: spacing)
      : SizedBox(width: spacing);

  @override
  Widget build(BuildContext context) {
    var style = LabeledStyle.of(context);
    var format = this.format ?? style.format ?? LabeledFormat.above;
    var spacing = this.spacing ?? style.spacing ?? 0;

    List<Widget> content = [
      Text(label, style: this.labelStyle ?? style.labelStyle),
      if (format == LabeledFormat.across) Spacer(),
      if (format != LabeledFormat.across && spacing > 0) _spacing(format),
      child
    ];

    return Flex(
        direction:
            format == LabeledFormat.above ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: crossAxisAlignment ?? style.crossAxisAlignment ?? CrossAxisAlignment.start,
        mainAxisAlignment: mainAxisAlignment ?? style.mainAxisAlignment ?? MainAxisAlignment.start,
        children: content);
  }
}
