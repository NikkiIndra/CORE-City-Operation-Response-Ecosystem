import 'package:flutter/material.dart';

class TextRichWidget extends StatelessWidget {
  final List<InlineSpan> children;
  final TextAlign textAlign;
  final TextStyle? defaultStyle;

  const TextRichWidget({
    Key? key,
    required this.children,
    this.textAlign = TextAlign.start,
    this.defaultStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: defaultStyle,
        children: children,
      ),
      textAlign: textAlign,
    );
  }
}
