import 'package:flutter/material.dart';
import 'package:cashmore_app/app/config/app_colors.dart';

void showChoiceDialog({
  required BuildContext context,
  required String title,
  required String message,
  required Widget body,
  required VoidCallback onConfirmed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16.0),
            Text(
              title,
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              style: const TextStyle(fontSize: 15.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            body,
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: onConfirmed,
                  child: const Text(
                    'done',
                    style: TextStyle(fontSize: 16.0, color: AppColors.primaryColor50),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'exit',
                    style: TextStyle(fontSize: 16.0, color: AppColors.primaryColor50),
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: AppColors.primaryColor95,
      );
    },
  );
}