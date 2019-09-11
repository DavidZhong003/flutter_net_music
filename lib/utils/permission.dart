import 'dart:async';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

List<PermissionGroup> _permissions = [
  PermissionGroup.contacts,
  PermissionGroup.storage
];

Future<Map<PermissionGroup, PermissionStatus>> requestPermission() async {
  return PermissionHandler().requestPermissions(_permissions);
}

Future<PermissionStatus> checkingPermission(PermissionGroup permission) async {
  return PermissionHandler().checkPermissionStatus(permission);
}

Future<ServiceStatus> checkingPermissionState(
    PermissionGroup permission) async {
  return PermissionHandler().checkServiceStatus(permission);
}

void requestPermissions() async {
 await PermissionHandler().requestPermissions(_permissions);
}
