import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSvgFile extends StatefulWidget {
  final String assetLocation;
  final double svgWidth;
  final double svgHeight;
  final Color overlayColor;

  const CustomSvgFile({
    super.key,
    required this.assetLocation,
    required this.svgWidth,
    required this.svgHeight,
    this.overlayColor = Colors.white,
  });

  @override
  CustomSvgState createState() => CustomSvgState();
}

class CustomSvgState extends State<CustomSvgFile> {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      widget.assetLocation,
      width: widget.svgWidth,
      height: widget.svgHeight,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(widget.overlayColor, BlendMode.srcIn),
    );
  }
}
