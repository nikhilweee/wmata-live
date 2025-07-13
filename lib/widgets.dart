import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const Label(
    this.text, {
    super.key,
    this.style,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    this.borderRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        text.toUpperCase(),
        style: style ?? Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
