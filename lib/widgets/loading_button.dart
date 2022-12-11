

import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final String name;
  final Color color;
  final Color? textColor;
  final Function? onTap;
  final double? minWidth, height;
  final bool isLoading;

  const LoadingButton({
    Key? key,
    required this.name,
    required this.color,
    this.textColor,
    this.onTap,
    this.minWidth,
    this.height = 30.0,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3.0),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: minWidth != null ? minWidth! / 2.5 : 10,
        ),
        child: Center(
          child: isLoading
              ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            ),
          )
              : Text(
            name,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}