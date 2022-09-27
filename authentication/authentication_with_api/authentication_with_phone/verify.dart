import '../../blocs/auth/auth_bloc.dart';
import '../../configs/app_constrains.dart';
import '../../screens/auth/get_started.dart';
import '../../screens/auth/login.dart';
import '../../widgets/button_custom.dart';
import '../../widgets/overlay_loading_custom.dart';
import '../../widgets/pin_put_custom.dart';
import 'package:flutter/material.dart';
import 'package:plugin_helper/plugin_navigator.dart';
import '../../widgets/bottom_appbar_custom.dart';
import 'package:plugin_helper/index.dart';
import '../../index.dart';
import '../../widgets/loading_custom.dart';

class Verify extends StatefulWidget {
  const Verify(
      {Key? key, required this.isResend, this.password, required this.phone})
      : super(key: key);
  final bool isResend;
  final String? password;
  final String phone;
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
        type: 'phone',
        userName:
            BlocProvider.of<AuthBloc>(context).state.getStartedModel!.username!,
        onError: (message) {
          showToastBottom(message: message);
        },
        onSuccess: () {
          if (isShowPopup) {
            showToastBottom(
                message: 'key_resend_code_success'.tr(),
                type: ToastType.success);
          }
        }));
  }

  _submit() {
    if (_codeController.text.length == 6) {
      BlocProvider.of<AuthBloc>(context).add(AuthVerifyCode(
          type: 'phone',
          code: _codeController.text,
          password: widget.password,
          userName: BlocProvider.of<AuthBloc>(context)
              .state
              .getStartedModel!
              .username!,
          onError: (message) {
            _codeController.clear();
            showToastBottom(message: message);
          },
          onSuccess: () {
            if (widget.password != null) {
              //TODO: go to home
            } else {
              replace(Login(
                phone: BlocProvider.of<AuthBloc>(context)
                    .state
                    .getStartedModel!
                    .phone!,
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
                    padding: EdgeInsets.symmetric(
                        vertical: AppConstrains.paddingVertical,
                        horizontal: AppConstrains.paddingHorizontal),
                    child: Column(
                      children: [
                        Text(widget.phone),
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
                              MyPluginNavigation.instance
                                  .replace(const GetStarted());
                            },
                            child: Text('key_use_another_account'.tr())),
                      ],
                    )))));
  }
}
