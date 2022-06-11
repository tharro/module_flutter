import 'package:plugin_helper/index.dart';

final String baseUrl = MyPluginAppEnvironment().baseUrl!;

class APIUrl {
  static String getStarted = '${baseUrl}general/auth/get-started/';
  static String getProfile = '${baseUrl}general/auth/profile/';
  static String fcm = '${baseUrl}general/auth/fcm-device/';
  static String upload = '${baseUrl}general/auth/upload/';

  //NOTIFICATION
  static final listNotification = '${baseUrl}user/notification/';
  static final readAllNotifications =
      '${baseUrl}user/notification/make-as-read/';
  static final readANotification =
      '${baseUrl}user/notification/read/{notification_id}/';

  static String login = '${baseUrl}general/auth/login/';
  static String refreshToken = '${baseUrl}general/auth/refresh-token/';
  static String signUp = '${baseUrl}general/auth/complete-signup/';
  static String verify = '${baseUrl}general/auth/verify/';
  static String resendCode = '${baseUrl}general/auth/resend-code/';
  static String resendPassword = '${baseUrl}general/auth/resend-password/';
  static String resetPassword = '${baseUrl}general/auth/reset-password/';
  static String updatePassword = '${baseUrl}general/auth/update-password/';
}
