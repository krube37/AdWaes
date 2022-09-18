import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? keyboardType;
  final GestureTapCallback? onTap;
  final MouseCursor? cursor;
  final bool enabled;

  const CustomTextField({
    Key? key,
    this.decoration,
    required this.focusNode,
    this.controller,
    this.onFieldSubmitted,
    this.keyboardType,
    this.onTap,
    this.cursor,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.focusNode.hasListeners) {
      widget.focusNode.addListener(() => setState(() {}));
    }
    return TextFormField(
      cursorWidth: widget.focusNode.hasFocus ? 1.5 : 0.0,
      cursorHeight: widget.focusNode.hasFocus ? 20.0 : 0.0,
      focusNode: widget.focusNode,
      decoration: widget.decoration,
      controller: widget.controller,
      onFieldSubmitted: widget.onFieldSubmitted,
      keyboardType: widget.keyboardType,
      onTap: widget.onTap,
      mouseCursor: widget.cursor,
      enabled: widget.enabled,
    );
  }
}
