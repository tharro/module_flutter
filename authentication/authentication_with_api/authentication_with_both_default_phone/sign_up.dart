import '../../blocs/auth/auth_bloc.dart';
import '../../configs/app_constrains.dart';
import '../../screens/auth/get_started.dart';
import '../../screens/auth/verify.dart';
import '../../utils/helper.dart';
import '../../widgets/button_custom.dart';
import '../../widgets/overlay_loading_custom.dart';
import '../../widgets/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plugin_helper/plugin_navigator.dart';
import 'package:plugin_helper/widgets/widget_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../widgets/bottom_appbar_custom.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key, required this.phone}) : super(key: key);
  final String phone;
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final FocusNode _firstNameFocusNode = FocusNode();
  final TextEditingController _lastNameController = TextEditingController();
  final FocusNode _lastNameFocusNode = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  bool _isValidPassword = false,
      _isValidFirstName = false,
      _isValidLastName = false;
  String phoneNumber = '';

  _submit() {
    if (!_isValidPassword || !_isValidFirstName || !_isValidLastName) {
      return;
    }
    BlocProvider.of<AuthBloc>(context).add(AuthSignUp(
        onError: (code, message) {
          Helper.showErrorDialog(
              code: code,
              context: context,
              message: message,
              onPressPrimaryButton: () {
                Navigator.pop(context);
              });
        },
        body: {
          'username': BlocProvider.of<AuthBloc>(context)
              .state
              .getStartedModel!
              .username!,
          'email': _emailController.text.trim(),
          'phone': widget.phone,
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'password': _passwordController.text,
        },
        onSuccess: () {
          MyPluginNavigation.instance.replace(Verify(
            isFromSignUp: true,
            isResend: false,
            password: _passwordController.text,
            user: widget.phone,
            type: 'phone',
          ));
        }));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return OverlayLoadingCustom(
          isLoading: state.signUpLoading!,
          child: Scaffold(
              bottomNavigationBar: BottomAppBarCustom(
                child: ButtonCustom(
                  onPressed: () {
                    _submit();
                  },
                  title: 'key_sign_up'.tr(),
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
                            validType: ValidType.none,
                            hintText: widget.phone,
                            enabled: false,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFieldCustom(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            validType: ValidType.email,
                            hintText: 'key_email'.tr(),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFieldCustom(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            validType: ValidType.password,
                            hintText: 'key_password'.tr(),
                            onValid: (bool val) {
                              _isValidPassword = val;
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFieldCustom(
                            controller: _firstNameController,
                            focusNode: _firstNameFocusNode,
                            validType: ValidType.notEmpty,
                            hintText: 'key_first_name'.tr(),
                            onValid: (bool val) {
                              _isValidFirstName = val;
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFieldCustom(
                            controller: _lastNameController,
                            focusNode: _lastNameFocusNode,
                            validType: ValidType.notEmpty,
                            hintText: 'key_last_name'.tr(),
                            onValid: (bool val) {
                              _isValidLastName = val;
                            },
                            onFieldSubmitted: (text) {
                              _submit();
                            },
                          ),
                          GestureDetector(
                              onTap: () {
                                MyPluginNavigation.instance
                                    .replace(const GetStarted());
                              },
                              child: Text('key_use_another_account'.tr())),
                        ],
                      )))));
    });
  }
}
