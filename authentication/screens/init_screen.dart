import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../index.dart';
import '../../screens/auth/get_started.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({Key? key}) : super(key: key);

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  void initState() {
    messageRequire();
    _checkUpdate();
    super.initState();
  }

  _checkUpdate() async {
    await Future.delayed(const Duration(milliseconds: 100));
    MyPluginHelper.checkUpdateApp(
      onError: () {
        _getData(isHideSplashScreen: true);
      },
      onUpdate: (status) {
        if (status.canUpdate) {
          MyPluginHelper.remove();
          Helper.showSuccessDialog(
              context: context,
              isShowSecondButton: true,
              message: 'key_update_version_detail'
                  .tr()
                  .replaceAll(':localVersion', status.localVersion)
                  .replaceAll(':storeVersion', status.storeVersion),
              title: 'key_update'.tr(),
              onPressSecondButton: () {
                goBack();
                _getData();
              },
              onPressPrimaryButton: () async {
                goBack();
                _getData();
                try {
                  if (await canLaunchUrl(Uri.parse(status.appStoreLink))) {
                    await launchUrl(Uri.parse(status.appStoreLink));
                  } else {
                    throw 'Could not launch appStoreLink';
                  }
                } catch (e) {}
              });
        } else {
          _getData(isHideSplashScreen: true);
        }
      },
      androidId: '',
      iOSId: '',
    );
  }

  _getData({bool isHideSplashScreen = false}) {
    BlocProvider.of<AuthBloc>(context)
        .add(AuthResumeSession(onError: (String message) async {
      bool isFirst = await MyPluginHelper.isFirstInstall();
      if (isHideSplashScreen) {
        MyPluginHelper.remove();
      }
      Helper.showToastBottom(message: message);
      if (isFirst) {
        FlutterSecureStorage storage = const FlutterSecureStorage();
        await storage.deleteAll();
        await MyPluginHelper.setFirstInstall();
      }
      replace(const GetStarted());
    }, onSuccess: (bool isResume) async {
      bool isFirst = await MyPluginHelper.isFirstInstall();
      if (isFirst) {
        FlutterSecureStorage storage = const FlutterSecureStorage();
        await storage.deleteAll();
        await MyPluginHelper.setFirstInstall();
        popUtil(const GetStarted());
      } else {
        if (isResume) {
          //TODO: go to home
        } else {
          popUtil(const GetStarted());
        }
      }
      if (isHideSplashScreen) {
        MyPluginHelper.remove();
      }
    }));
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
      messageHour: 'key_hour'.tr(),
      messageDay: 'key_day'.tr(),
      messageMinute: 'key_minute'.tr(),
      messageSecond: 'key_second'.tr(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: set background color
      body: Container(),
    );
  }
}
