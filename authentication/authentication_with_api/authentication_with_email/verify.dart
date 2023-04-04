import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../configs/app_constrains.dart';
import '../../index.dart';
import '../../screens/auth/get_started.dart';
import '../../screens/auth/login.dart';
import '../../widgets/bottom_appbar_custom.dart';
import '../../widgets/button_custom.dart';
import '../../widgets/loading_custom.dart';
import '../../widgets/overlay_loading_custom.dart';
import '../../widgets/pin_put_custom.dart';

class Verify extends StatefulWidget {
  const Verify(
      {Key? key, required this.isResend, this.password, required this.email})
      : super(key: key);
  final bool isResend;
  final String? password;
  final String email;
  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    if (widget.isResend) {
      _resendCode(false);
    }
    super.initState();
  }

  _resendCode(bool isShowPopup) {
    BlocProvider.of<AuthBloc>(context).add(AuthResendCode(
        type: 'email',
        userName:
            BlocProvider.of<AuthBloc>(context).state.getStartedModel!.username!,
        onSuccess: () {
          if (isShowPopup) {
            Helper.showToastBottom(
                message: 'key_resend_code_success'.tr(),
                type: ToastType.success);
          }
        }));
  }

  _submit() {
    if (_codeController.text.length == 6) {
      BlocProvider.of<AuthBloc>(context).add(AuthVerifyCode(
          type: 'email',
          password: widget.password,
          code: _codeController.text,
          userName: BlocProvider.of<AuthBloc>(context)
              .state
              .getStartedModel!
              .username!,
          onError: (message) {
            _codeController.clear();
            Helper.showToastBottom(message: message);
          },
          onSuccess: () {
            if (widget.password != null) {
              //TODO: go to home
            } else {
              replace(Login(
                email: BlocProvider.of<AuthBloc>(context)
                    .state
                    .getStartedModel!
                    .email!,
              ));
            }
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return OverlayLoadingCustom(
        loadingWidget: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return LoadingCustom(
                isOverlay: true, isLoading: state.verifyCodeLoading!);
          },
        ),
        child: Scaffold(
            bottomNavigationBar: BottomAppBarCustom(
              child: ButtonCustom(
                onPressed: () {
                  _submit();
                },
                title: 'key_verify'.tr(),
              ),
            ),
            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppConstrains.paddingVertical,
                        horizontal: AppConstrains.paddingHorizontal),
                    child: Column(
                      children: [
                        Text(widget.email),
                        PinPutCustom(
                          controller: _codeController,
                          onChange: (code) {},
                          onCompleted: (code) {},
                        ),
                        GestureDetector(
                            onTap: () {
                              _resendCode(true);
                            },
                            child: Text('key_resend_code'.tr())),
                        GestureDetector(
                            onTap: () {
                              replace(const GetStarted());
                            },
                            child: Text('key_use_another_account'.tr())),
                      ],
                    )))));
  }
}
