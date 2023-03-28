abstract class PermissionHandler {
  void addPermission(String operatingSystem);
  Future<void> requestPermission();
  bool hasPermission();
}
