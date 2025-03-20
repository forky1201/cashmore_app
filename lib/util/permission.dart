import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:get/get.dart';

Future<void> showPermissionDialog(String title, String content) async {
  await Get.dialog(
    AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // 다이얼로그 닫기
          },
          child: Text("확인"),
        ),
      ],
    ),
  );
}

Future<void> requestGalleryPermission() async {
  final permission = await PhotoManager.requestPermissionExtend();

  if (permission == PermissionState.authorized) {
    // 권한이 허용된 경우
    await showPermissionDialog("권한 허용됨", "사진 저장이 가능합니다.");
  } else if (permission == PermissionState.limited) {
    // 제한적 권한 (Android 11 이상)
    await showPermissionDialog("권한 제한됨", "일부 사진만 접근이 가능합니다. 설정에서 권한을 수정해주세요.");
  } else {
    // 권한이 거부된 경우
    await showPermissionDialog("권한 거부됨", "사진 저장을 위해 갤러리 접근 권한이 필요합니다.");
    PhotoManager.openSetting(); // 설정 화면 열기
  }
}
