import 'package:permission_handler/permission_handler.dart';

Future<void> requestSongsPermission() async {
  try {
    final bool audioGranted = await Permission.audio.isGranted;

    if (!audioGranted) {
      final Map<Permission, PermissionStatus> statuses =
          await [Permission.audio].request();

      if (statuses[Permission.audio] == PermissionStatus.permanentlyDenied) {
        await openAppSettings();
      }
    }
  } catch (e) {
    print("There is Something Wrong with Permissions");
  }
}
