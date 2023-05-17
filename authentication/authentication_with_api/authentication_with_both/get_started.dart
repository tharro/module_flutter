import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';
import 'package:plugin_helper/widgets/phone_number/intl_phone_number_input.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../configs/app_constrains.dart';
import '../../index.dart';
import '../../screens/auth/login.dart';
import '../../screens/auth/options_verify.dart';
import '../../screens/auth/sign_up.dart';
import '../../widgets/bottom_appbar_custom.dart';
import '../../widgets/button_custom.dart';
import '../../widgets/loading_custom.dart';
import '../../widgets/overlay_loading_custom.dart';
import '../../widgets/text_field_custom.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isValid = false;

  _submit() async {
    if (!_isValid) {
      return;
    }
    var emailOrPhone = _controller.text.trim();
    if (emailOrPhone.isPhoneNumber) {
      try {
        await PhoneNumber.getRegionInfoFromPhoneNumber(emailOrPhone);
      } catch (e) {
        Helper.showToastBottom(message: 'key_invalid_phone'.tr());
        return;
      }
    }

    BlocProvider.of<AuthBloc>(
            MyPluginNavigation.instance.navigationKey!.currentContext!)
        .add(AuthGetStarted(
            onSuccess: (String value) {
              switch (value) {
                case MyPluginAppConstraints.signUp:
                  push(SignUp(
                    emailOrPhone: _controller.text.trim(),
                  ));
                  break;
                case MyPluginAppConstraints.login:
                  push(Login(emailOrPhone: _controller.text.trim()));
                  break;
                case MyPluginAppConstraints.verify:
                  push(OptionsVerify(
                    emailOrPhone: _controller.text.trim(),
                  ));
                  break;
                default:
              }
            },
            body: {
          'email_or_phone': emailOrPhone,
        }));
  }

  @override
  Widget build(BuildContext context) {
    return OverlayLoadingCustom(
      loadingWidget: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return LoadingCustom(
              isOverlay: true, isLoading: state.getStartedRequesting!);
        },
      ),
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
            padding: const EdgeInsets.symmetric(
                vertical: AppConstrains.paddingVertical,
                horizontal: AppConstrains.paddingHorizontal),
            child: Column(
              children: [
                TextFieldCustom(
                  controller: _controller,
                  focusNode: _focusNode,
                  validType: ValidType.notEmpty,
                  onValid: (valid) {
                    _isValid = valid;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
