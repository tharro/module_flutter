import '../../blocs/auth/auth_bloc.dart';
import '../../screens/auth/get_started.dart';
import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';
import '../../index.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({Key? key}) : super(key: key);

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  void initState() {
    messageRequire();
    BlocProvider.of<AuthBloc>(context)
        .add(AuthResumeSession(onError: (String code, message) {
      Helper.showErrorDialog(
          context: context,
          code: code,
          message: message,
          barrierDismissible: false,
          onPressPrimaryButton: () {
            MyPluginNavigation.instance.replace(const GetStarted());
          });
    }, onSuccess: (bool isResume) {
      if (isResume) {
        //TODO: navigate to home screen
      } else {
        MyPluginNavigation.instance.replace(const GetStarted());
      }
    }));
    super.initState();
  }

  void messageRequire() {
    MyPluginMessageRequire.messageRequire(
      messageCanNotLaunchURL: 'key_can_not_launch_url'.tr(),
      messageNoConnection: 'key_network_connect'.tr(),
      messageCompleteText: 'key_refresh_completed'.tr(),
      messageIdleText: 'key_pull_down_refresh'.tr(),
      messageRefreshingText: 'key_refreshing'.tr(),
      messageReleaseText: 'key_release_to_refresh'.tr(),
      messageEmptyData: 'key_empty_data'.tr(),
      messageReconnecting: 'key_reconnecting'.tr(),
      messageCanNotEmpty: 'key_can_not_empty'.tr(),
      messageInvalidEmail: 'key_invalid_email'.tr(),
      messageWeakPassword: 'key_weak_password'.tr(),
      messageCancel: 'key_cancel'.tr(),
      messageHour: 'key_hour'.tr(),
      messageDay: 'key_day'.tr(),
      messageMinute: 'key_minute'.tr(),
      messageSecond: 'key_second'.tr(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
