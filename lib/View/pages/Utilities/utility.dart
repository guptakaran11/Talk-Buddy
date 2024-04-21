//* Packages
import 'package:flutter/material.dart';

// Animate dialog box
void showAnimatedDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String actionText,
  required Function(bool) onActionPressed,
}) async {
  showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: AlertDialog(
              title: Text(
                style: const TextStyle(color: Colors.white),
                title,
                textAlign: TextAlign.center,
              ),
              content: Text(
                style: const TextStyle(color: Colors.white70),
                content,
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    onActionPressed(false);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                const SizedBox(
                  width: 110,
                ),
                TextButton(
                  onPressed: () {
                    onActionPressed(true);
                    Navigator.of(context).pop();
                  },
                  child: Text(actionText),
                ),
              ],
            ),
          ),
        );
      });
}
