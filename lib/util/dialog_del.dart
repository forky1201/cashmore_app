import 'package:flutter/material.dart';
import 'package:cashmore_app/app/config/app_colors.dart';

void showCustomDialog({
  required BuildContext context,
  required IconData icon,
  required String title,
  required String message,
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
            Icon(icon, size: 48.0, color: Colors.grey),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              message,
              style: const TextStyle(fontSize: 16.0, color: AppColors.gray900),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: onConfirmed,
                  child: const Text(
                    'yn_y',
                    style: TextStyle(fontSize: 16.0, color: AppColors.primaryColor50),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'yn_n',
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