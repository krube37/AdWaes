import 'package:flutter/material.dart';

class UnderLinedTextClicker extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Function? onTap;

  const UnderLinedTextClicker({
    Key? key,
    required this.text,
    this.onTap,
    this.style,
  }) : super(key: key);

  @override
  State<UnderLinedTextClicker> createState() => _UnderLinedTextClickerState();
}

class _UnderLinedTextClickerState extends State<UnderLinedTextClicker> {
  bool isHovering = false;
  late TextStyle style;

  @override
  void initState() {
    style = widget.style ?? const TextStyle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (_) => setState(() => isHovering = _),
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () => widget.onTap?.call(),
      child: Text(
        widget.text,
        style: style.copyWith(
          decoration: isHovering ? TextDecoration.underline : null,
        ),
      ),
    );
  }
}
