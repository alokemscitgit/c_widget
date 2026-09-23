
import 'package:flutter/material.dart';

class CHoverIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final double hoverSize;
  final Color iconColor;
  final Color iconHoverColor;

  const CHoverIcon({
    Key? key,
    required this.icon,
    required this.size,
    required this.iconColor,
    required this.iconHoverColor,
    required this.hoverSize,
  }) : super(key: key);

  @override
  State<CHoverIcon> createState() => _CHoverIconState();
}

class _CHoverIconState extends State<CHoverIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          widget.icon,
          color: _isHovered ? widget.iconHoverColor : widget.iconColor,
          size: _isHovered ? widget.hoverSize : widget.size,
        ),
      ),
    );
  }
}