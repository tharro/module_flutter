import 'package:plugin_helper/plugin_app_environment.dart';

final String baseUrl = MyPluginAppEnvironment().baseUrl!;

class APIUrl {
  static String getStarted = '${baseUrl}general/auth/get-started/';
  static String getProfile = '${baseUrl}general/auth/profile/';
  static String fcm = '${baseUrl}general/auth/fcm-device/';
  static String upload = '${baseUrl}general/auth/upload/';

  //NOTIFICATION
  static final listNotification = '$baseUrl$versionApi/user/notifications/';
  static final readAllNotifications =
      '$baseUrl$versionApi/user/notifications/read-all/';
  static final readANotification =
      '$baseUrl$versionApi/user/notifications/read/:notification_id/';
}
