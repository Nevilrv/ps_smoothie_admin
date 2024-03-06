import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final double? radius, elevation;
  final Color? buttonColor;

  const CommonButton({
    Key? key,
    required this.onPressed,
    this.child,
    this.radius = 3,
    this.buttonColor,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: elevation,
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius!),
        ),
      ),
      onPressed: onPressed!,
      child: child,
    );
  }
}

class CommonOutlineButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final double? height, width, buttonRadius;
  const CommonOutlineButton(
      {Key? key,
      this.onPressed,
      this.child,
      this.height,
      this.width,
      this.buttonRadius = 3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(buttonRadius!),
      onTap: onPressed!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(buttonRadius!),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
