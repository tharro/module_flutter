import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plugin_helper/index.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../configs/app_text_styles.dart';

class MainTab extends StatefulWidget {
  const MainTab({Key? key}) : super(key: key);

  @override
  State<MainTab> createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  List<MyWidgetAppFlow>? _appFlows;
  GlobalKey<AdaptiveBottomNavigationScaffoldState>? _adapterKey;

  @override
  void initState() {
    _adapterKey = GlobalKey<AdaptiveBottomNavigationScaffoldState>();
    _appFlows = [
      MyWidgetAppFlow(
        title: 'Home',
        iconData: const Icon(
          Icons.camera,
          color: Colors.grey,
        ),
        activeIconData: const Icon(
          Icons.camera,
          color: Colors.red,
        ),
        navigatorKey: GlobalKey<NavigatorState>(),
        child: Container(
          color: Colors.red,
        ),
      ),
      MyWidgetAppFlow(
        title: 'Message',
        iconData: const Icon(
          Icons.message,
          color: Colors.grey,
        ),
        activeIconData: const Icon(
          Icons.message,
          color: Colors.red,
        ),
        navigatorKey: GlobalKey<NavigatorState>(),
        child: Container(
          color: Colors.yellow,
        ),
      ),
    ];
    MyPluginNotification.settingNotification(
        colorNotification: Colors.red,
        onMessage: (RemoteMessage remoteMessage) {},
        onOpenLocalMessage: (String message) {},
        onOpenFCMMessage: (RemoteMessage remote) {},
        onRegisterFCM: (Map<String, dynamic> data) {
          BlocProvider.of<AuthBloc>(context).add(AuthFCM(body: data));
        },
        iconNotification: 'icon_notification',
        chanelId: 'chanel',
        chanelName: 'app_channel',
        channelDescription: 'chanel description',
        onShowLocalNotification: (RemoteMessage message) => true);
    super.initState();
  }

  @override
  void dispose() {
    MyPluginNotification.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveBottomNavigationScaffold(
      key: _adapterKey,
      navigationBarItems: _appFlows!.map((flow) {
        return MyWidgetBottomNavigationTab(
          bottomNavigationBarItem: BottomNavigationBarItem(
            label: flow.title,
            icon: flow.iconData,
            activeIcon: flow.activeIconData,
            tooltip: '',
          ),
          navigatorKey: flow.navigatorKey,
          initialPageBuilder: (context) => flow.child,
        );
      }).toList(),
      selectedLabelStyle: AppTextStyles.textSize12(),
      unselectedLabelStyle: AppTextStyles.textSize12(),
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
    );
  }
}
