import '../../widgets/phone_number_custom.dart';
import 'package:plugin_helper/widgets/phone_number/intl_phone_number_input.dart';
import '../../screens/auth/options_verify.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../configs/app_constrains.dart';
import '../../screens/auth/login.dart';
import '../../screens/auth/sign_up.dart';
import '../../utils/helper.dart';
import '../../widgets/button_custom.dart';
import '../../widgets/overlay_loading_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:plugin_helper/plugin_authentication.dart';
import 'package:plugin_helper/plugin_navigator.dart';
import '../../widgets/bottom_appbar_custom.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isValidPhone = false;
  String phoneNumber = '';

  @override
  void initState() {
    super.initState();
  }

  _submit() {
    if (!_isValidPhone) {
      return;
    }
    print(phoneNumber);
    BlocProvider.of<AuthBloc>(context).add(AuthGetStarted(
        onError: (code, message) {
          Helper.showErrorDialog(
              code: code,
              context: context,
              message: message,
              onPressPrimaryButton: () {
                Navigator.pop(context);
              });
        },
        onSuccess: (String value) {
          switch (value) {
            case MyPluginAppConstraints.signUp:
              MyPluginNavigation.instance.replace(SignUp(
                phone: phoneNumber,
              ));
              break;
            case MyPluginAppConstraints.login:
              MyPluginNavigation.instance.push(Login(
                isVerify: true,
                phone: phoneNumber,
              ));
              break;
            case MyPluginAppConstraints.verify:
              if (BlocProvider.of<AuthBloc>(context)
                  .state
                  .getStartedModel!
                  .isVerifiedPhone!) {
                MyPluginNavigation.instance.push(Login(
                  isVerify: false,
                  phone: BlocProvider.of<AuthBloc>(context)
                      .state
                      .getStartedModel!
                      .phone!,
                ));
              } else {
                MyPluginNavigation.instance.push(const OptionsVerify());
              }
              break;
            default:
          }
        },
        body: {
          'phone': phoneNumber,
        }));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return OverlayLoadingCustom(
          isLoading: state.getStartedRequesting!,
          child: Scaffold(
              bottomNavigationBar: BottomAppBarCustom(
                child: ButtonCustom(
                  onPressed: () {
                    _submit();
                  },
                  title: 'key_continue'.tr(),
                ),
              ),
              body: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: AppConstrains.paddingVertical,
                          horizontal: AppConstrains.paddingHorizontal),
                      child: Column(
                        children: [
                          PhoneNumberCustom(
                              autoFocus: true,
                              onInputValidated: (bool val) {
                                setState(() {
                                  _isValidPhone = val;
                                });
                              },
                              hasError: _isValidPhone,
                              onInputChanged: (PhoneNumber number) {
                                phoneNumber = number.phoneNumber!;
                              },
                              controller: _controller,
                              focusNode: _focusNode)
                        ],
                      )))));
    });
  }
}
