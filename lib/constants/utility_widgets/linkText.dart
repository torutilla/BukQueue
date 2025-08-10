import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';

class TextLink extends StatefulWidget {
  final VoidCallback onPressed;
  final String linktext;
  final Color textColor;
  final double fontSize;
  final TextDecoration textDecoration;
  const TextLink({
    super.key,
    required this.onPressed,
    required this.linktext,
    this.textColor = accentColor,
    this.fontSize = 14,
    this.textDecoration = TextDecoration.none,
  });

  _HoveredLinkTextState createState() => _HoveredLinkTextState();
}

class _HoveredLinkTextState extends State<TextLink> {
  late Color hoveredColor;

  @override
  void initState() {
    super.initState();
    hoveredColor = widget.textColor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (details) {
        setState(() {
          hoveredColor = widget.textColor.withRed(255);
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.linktext,
          style: TextStyle(
            color: hoveredColor,
            fontWeight: FontWeight.w400,
            fontSize: widget.fontSize,
            decoration: widget.textDecoration,
            decorationColor: widget.textColor,
          ),
        ),
      ),
    );
  }
}
