import '../../screens/auth/options_verify.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../configs/app_constrains.dart';
import '../../screens/auth/login.dart';
import '../../screens/auth/sign_up.dart';
import '../../utils/helper.dart';
import '../../widgets/button_custom.dart';
import '../../widgets/overlay_loading_custom.dart';
import '../../widgets/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:plugin_helper/plugin_authentication.dart';
import 'package:plugin_helper/plugin_navigator.dart';
import 'package:plugin_helper/widgets/widget_text_field.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isValidEmail = true;

  @override
  void initState() {
    super.initState();
  }

  _submit() {
    if (!_isValidEmail) {
      return;
    }
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
                email: _controller.text.trim(),
              ));
              break;
            case MyPluginAppConstraints.login:
              MyPluginNavigation.instance.push(Login(
                isVerify: true,
                email: _controller.text.trim(),
              ));
              break;
            case MyPluginAppConstraints.verify:
              if (BlocProvider.of<AuthBloc>(context)
                  .state
                  .getStartedModel!
                  .isVerifiedEmail!) {
                MyPluginNavigation.instance.push(Login(
                  isVerify: false,
                  email: BlocProvider.of<AuthBloc>(context)
                      .state
                      .getStartedModel!
                      .email!,
                ));
              } else {
                MyPluginNavigation.instance.push(const OptionsVerify());
              }

              break;
            default:
          }
        },
        body: {
          'username': _controller.text.trim(),
        }));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return OverlayLoadingCustom(
          isLoading: state.getStartedRequesting!,
          child: Scaffold(
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(
                    bottom: AppConstrains.paddingVertical,
                    left: AppConstrains.paddingHorizontal,
                    right: AppConstrains.paddingHorizontal,
                    top: 5),
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
                          TextFieldCustom(
                            controller: _controller,
                            focusNode: _focusNode,
                            validType: ValidType.email,
                            onValid: (bool val) {
                              _isValidEmail = val;
                            },
                            hintText: 'key_enter_a_email'.tr(),
                          ),
                        ],
                      )))));
    });
  }
}
