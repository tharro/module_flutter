import '../../blocs/auth/auth_bloc.dart';
import '../../configs/app_constrains.dart';
import '../../screens/auth/forgot_password.dart';
import '../../screens/auth/get_started.dart';
import '../../utils/helper.dart';
import '../../widgets/button_custom.dart';
import '../../widgets/overlay_loading_custom.dart';
import '../../widgets/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plugin_helper/plugin_navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../widgets/bottom_appbar_custom.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.phone}) : super(key: key);
  final String phone;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  _submit() {
    BlocProvider.of<AuthBloc>(context).add(AuthLogin(
        onError: (code, message) {
          Helper.showErrorDialog(
              context: context,
              code: code,
              message: message,
              onPressPrimaryButton: () {
                Navigator.pop(context);
              });
        },
        userName:
            BlocProvider.of<AuthBloc>(context).state.getStartedModel!.username!,
        password: _passwordController.text,
        onSuccess: () {
          //TODO: go to home
        }));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return OverlayLoadingCustom(
          isLoading: state.loginLoading!,
          child: Scaffold(
              bottomNavigationBar: BottomAppBarCustom(
                child: ButtonCustom(
                  onPressed: () {
                    _submit();
                  },
                  title: 'key_login'.tr(),
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
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            hintText: widget.phone,
                            enabled: false,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFieldCustom(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            validType: ValidType.password,
                            hintText: 'key_password'.tr(),
                            showError: false,
                            onFieldSubmitted: (text) {
                              _submit();
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                              onTap: () {
                                MyPluginNavigation.instance
                                    .replace(const GetStarted());
                              },
                              child: Text('key_use_another_account'.tr())),
                          GestureDetector(
                              onTap: () {
                                BlocProvider.of<AuthBloc>(context).add(
                                    AuthForgotPassword(
                                        userName:
                                            BlocProvider.of<AuthBloc>(context)
                                                .state
                                                .getStartedModel!
                                                .name!,
                                        onError: (code, message) {
                                          Helper.showErrorDialog(
                                              code: code,
                                              context: context,
                                              message: message,
                                              onPressPrimaryButton: () {
                                                Navigator.pop(context);
                                              });
                                        },
                                        onSuccess: () {
                                          MyPluginNavigation.instance
                                              .replace(const ForgotPassword());
                                        }));
                              },
                              child: Text('key_forgot_password'.tr())),
                        ],
                      )))));
    });
  }
}
