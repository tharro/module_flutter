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
  late final AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);

  @override
  void initState() {
    if (widget.isResend) {
      _resendCode(false);
    }
    super.initState();
  }

  _resendCode(bool isShowPopup) {
    _authBloc.add(AuthResendCode(
        type: 'phone',
        id: _authBloc.state.getStartedModel!.id!,
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
      _authBloc.add(AuthVerifyCode(
        type: 'phone',
        code: _codeController.text,
        password: widget.password,
        id: _authBloc.state.getStartedModel!.id!,
        onError: (message) {
          _codeController.clear();
          Helper.showToastBottom(message: message);
        },
        onSuccess: () {
          if (widget.password != null) {
            //TODO: go to home
          } else {
            replace(Login(
              phone: _authBloc.state.getStartedModel!.phone!,
            ));
          }
        },
      ));
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
                      replace(const GetStarted());
                    },
                    child: Text('key_use_another_account'.tr())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
