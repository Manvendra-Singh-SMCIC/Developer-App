import 'package:permission_handler/permission_handler.dart';

class CheckPermission {
  Future<bool> isStoragePermission() async {
    var isStorage = await Permission.storage.status;
    var isAccessLc = await Permission.accessMediaLocation.status;
    var isMangeExt = await Permission.manageExternalStorage.status;
    if (!isStorage.isGranted || !isAccessLc.isGranted || isMangeExt.isGranted) {
      await Permission.storage.request();
      await Permission.accessMediaLocation.request();
      await Permission.manageExternalStorage.request();
      if (!isStorage.isGranted ||
          !isAccessLc.isGranted ||
          isMangeExt.isGranted) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }
}
