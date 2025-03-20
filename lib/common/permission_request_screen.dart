import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("권한 요청")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "앱에서 사진 권한이 필요합니다.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                /*final status = await Permission.photos.request();
                if (status.isGranted) {
                  // 권한이 허용되면 이전 화면으로 돌아감
                  Navigator.of(context).pop();
                } else if (status.isPermanentlyDenied) {
                  // 권한이 영구적으로 거부된 경우 설정 화면으로 안내
                  await openAppSettings();
                }*/

                final permission = _requestPermission(Permission.photos);
                  debugPrint('permission : $permission');
              },
              child: Text("권한 요청하기"),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      return result == PermissionStatus.granted;
    }
  }
}
