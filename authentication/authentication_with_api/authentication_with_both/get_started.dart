import '../../widgets/text_field_custom.dart';
import '../../widgets/bottom_appbar_custom.dart';
import '../../screens/auth/options_verify.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../configs/app_constrains.dart';
import '../../screens/auth/login.dart';
import '../../screens/auth/sign_up.dart';
import '../../widgets/button_custom.dart';
import '../../widgets/overlay_loading_custom.dart';
import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';
import '../../index.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  _submit() {
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
              replace(SignUp(
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
          'email_or_phone': _controller.text.trim(),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: AppConstrains.paddingVertical,
                          horizontal: AppConstrains.paddingHorizontal),
                      child: Column(
                        children: [
                          TextFieldCustom(
                            controller: _controller,
                            focusNode: _focusNode,
                            validType: ValidType.none,
                          ),
                        ],
                      )))));
    });
  }
}
