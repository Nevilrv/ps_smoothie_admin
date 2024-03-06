import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

class CommonSnackBar {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      {required BuildContext context, required String title}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
      ),
    );
  }

  static successBar({String? title, BuildContext? context}) {
    return AnimatedSnackBar.rectangle(
      'Success',
      '${title}',
      type: AnimatedSnackBarType.success,
      brightness: Brightness.dark,
      duration: Duration(seconds: 2),
      desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
    ).show(
      context!,
    );
  }

  static warningBar({String? title, BuildContext? context}) {
    return AnimatedSnackBar.rectangle(
      'Warning',
      '${title}',
      type: AnimatedSnackBarType.warning,
      brightness: Brightness.dark,
      duration: Duration(seconds: 2),
      desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
    ).show(
      context!,
    );
  }

  static errorBar({String? title, BuildContext? context}) {
    return AnimatedSnackBar.rectangle(
      'Error',
      '${title}',
      type: AnimatedSnackBarType.error,
      brightness: Brightness.dark,
      duration: Duration(seconds: 2),
      desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
    ).show(
      context!,
    );
  }
}
