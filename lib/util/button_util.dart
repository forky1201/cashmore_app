import 'package:flutter/material.dart';
import 'package:cashmore_app/app/config/app_colors.dart';
import 'package:cashmore_app/app/config/app_text_styles.dart';

class ButtonUtil {
  static Widget mainBottomBar(BuildContext context, String content, Function() onPressed) {
    return ElevatedButton(
      onPressed: () async {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        elevation: 3,
        backgroundColor: AppColors.primaryColor50,
        minimumSize: Size(MediaQuery.sizeOf(context).width, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      child: Text(
        content,
        style: AppTextStyles.subTitle3.withColor(Colors.white),
      ),
    );
  }
}