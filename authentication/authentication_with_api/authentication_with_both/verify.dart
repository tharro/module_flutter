import '../../blocs/auth/auth_bloc.dart';
import '../../configs/app_constrains.dart';
import '../../screens/auth/get_started.dart';
import '../../screens/auth/login.dart';
import '../../widgets/button_custom.dart';
import '../../widgets/overlay_loading_custom.dart';
import '../../widgets/pin_put_custom.dart';
import 'package:flutter/material.dart';
import '../../widgets/bottom_appbar_custom.dart';
import 'package:plugin_helper/index.dart';
import '../../index.dart';

class Verify extends StatefulWidget {
  const Verify({
    Key? key,
    this.password,
    required this.receiver,
    required this.type,
    this.isVerifyEmail = false,
    this.isVerifyPhone = false,
    required this.emailOrPhone,
  }) : super(key: key);
  final String? password;
  final String receiver, emailOrPhone;
  final String type;
  final bool isVerifyEmail, isVerifyPhone;
  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    _resendCode(false);
    super.initState();
  }

  _resendCode(bool isShowPopup) {
    BlocProvider.of<AuthBloc>(context).add(AuthResendCode(
        type: widget.type,
        userName:
            BlocProvider.of<AuthBloc>(context).state.getStartedModel!.username!,
        onError: (code, message) {
          Helper.showErrorDialog(
              context: context,
              code: code,
              message: message,
              onPressPrimaryButton: () {
                Navigator.pop(context);
              });
        },
        onSuccess: () {
          if (isShowPopup) {
            Helper.showSuccessDialog(
                context: context,
                message: 'key_resend_code_success'.tr(),
                onPressPrimaryButton: () {
                  Navigator.pop(context);
                });
          }
        }));
  }

  _submit({String? code}) {
    if ((code ?? _codeController.text).length == 6) {
      BlocProvider.of<AuthBloc>(context).add(AuthVerifyCode(
          type: widget.type,
          password: widget.password,
          code: code ?? _codeController.text,
          userName: BlocProvider.of<AuthBloc>(context)
              .state
              .getStartedModel!
              .username!,
          onError: (code, message) {
            _codeController.clear();
            Helper.showErrorDialog(
                context: context,
                message: message,
                code: code,
                onPressPrimaryButton: () {
                  Navigator.pop(context);
                });
          },
          onSuccess: () {
            if ((widget.type == 'email' && widget.isVerifyPhone) ||
                (widget.type == 'phone' && widget.isVerifyEmail)) {
              if (widget.password != null) {
                //TODO: home
              } else {
                popUtil(Login(
                  emailOrPhone: widget.emailOrPhone,
                ));
              }
            } else {
              Navigator.pop(context);
            }
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return OverlayLoadingCustom(
          isLoading: state.verifyCodeLoading!,
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
                          Text(widget.receiver),
                          PinPutCustom(
                            controller: _codeController,
                            onChange: (val) {},
                            onCompleted: (code) {
                              _submit(code: code);
                            },
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
    });
  }
}
