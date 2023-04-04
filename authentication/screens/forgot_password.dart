import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';

import '../../widgets/button_custom.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../configs/app_constrains.dart';
import '../../index.dart';
import '../../screens/auth/get_started.dart';
import '../../widgets/loading_custom.dart';
import '../../widgets/overlay_loading_custom.dart';
import '../../widgets/pin_put_custom.dart';
import '../../widgets/text_field_custom.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isValidNewPassword = false,
      _isValidConfirmPassword = false,
      _isValidCode = false;
  String? _errorConfirmPassword;

  bool get _enableButton {
    return _isValidNewPassword &&
        _isValidConfirmPassword &&
        _errorConfirmPassword == null &&
        _isValidCode;
  }

  _submit() {
    BlocProvider.of<AuthBloc>(context).add(AuthResetPassword(
        code: _codeController.text,
        password: _newPasswordController.text,
        onSuccess: () {
          //TODO: go to home
        },
        userName: BlocProvider.of<AuthBloc>(context)
            .state
            .getStartedModel!
            .username!));
  }

  _resendCode({bool isPopup = false}) {
    BlocProvider.of<AuthBloc>(context).add(AuthForgotPassword(
        userName:
            BlocProvider.of<AuthBloc>(context).state.getStartedModel!.username!,
        onSuccess: () {
          if (isPopup) {
            Helper.showToastBottom(
                message: 'key_resend_code_success'.tr(),
                type: ToastType.success);
          }
        }));
  }

  _checkMatchPassword() {
    if (_newPasswordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      return;
    }
    if (_newPasswordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      setState(() {
        _errorConfirmPassword = 'key_password_not_match'.tr();
      });
      return;
    }
    setState(() {
      _errorConfirmPassword = null;
    });
  }

  @override
  void initState() {
    _resendCode(isPopup: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayLoadingCustom(
        loadingWidget: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return LoadingCustom(
                isOverlay: true, isLoading: state.resetPasswordLoading!);
          },
        ),
        child: Scaffold(
            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppConstrains.paddingVertical,
                        horizontal: AppConstrains.paddingHorizontal),
                    child: Column(
                      children: [
                        PinPutCustom(
                          controller: _codeController,
                          onChange: (val) {
                            bool isValid = val.length == 6;
                            setState(() {
                              _isValidCode = isValid;
                            });
                          },
                          onCompleted: (code) {},
                        ),
                        10.h,
                        TextFieldCustom(
                          validType: ValidType.password,
                          label: 'key_new_password'.tr(),
                          passwordValidType: PasswordValidType.notEmpty,
                          controller: _newPasswordController,
                          onListenController: () {
                            _checkMatchPassword();
                          },
                          onValid: (valid) {
                            setState(() {
                              _isValidNewPassword = valid;
                            });
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        16.h,
                        TextFieldCustom(
                          validType: ValidType.password,
                          label: 'key_confirm_password'.tr(),
                          controller: _confirmPasswordController,
                          passwordValidType: PasswordValidType.notEmpty,
                          onListenController: () {
                            _checkMatchPassword();
                          },
                          textError: _errorConfirmPassword,
                          onValid: (valid) {
                            setState(() {
                              _isValidConfirmPassword = valid;
                            });
                          },
                        ),
                        GestureDetector(
                            onTap: () {
                              replace(const GetStarted());
                            },
                            child: Text('key_use_another_account'.tr())),
                        GestureDetector(
                            onTap: () {
                              _resendCode();
                            },
                            child: Text('key_resend_code'.tr())),
                        16.h,
                        ButtonCustom(
                          onPressed: _submit,
                          enabled: _enableButton,
                          title: 'key_continue'.tr(),
                        )
                      ],
                    )))));
  }
}
