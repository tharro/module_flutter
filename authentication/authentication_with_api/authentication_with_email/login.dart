import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../configs/app_constrains.dart';
import '../../index.dart';
import '../../screens/auth/forgot_password.dart';
import '../../screens/auth/get_started.dart';
import '../../widgets/bottom_appbar_custom.dart';
import '../../widgets/button_custom.dart';
import '../../widgets/loading_custom.dart';
import '../../widgets/overlay_loading_custom.dart';
import '../../widgets/text_field_custom.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.email}) : super(key: key);
  final String email;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  late final AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);

  _submit() {
    _authBloc.add(AuthLogin(
        id: _authBloc.state.getStartedModel!.id!,
        password: _passwordController.text,
        onSuccess: () {
          //TODO: go to home
        }));
  }

  @override
  Widget build(BuildContext context) {
    return OverlayLoadingCustom(
      loadingWidget: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return LoadingCustom(isOverlay: true, isLoading: state.loginLoading!);
        },
      ),
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
            padding: const EdgeInsets.symmetric(
                vertical: AppConstrains.paddingVertical,
                horizontal: AppConstrains.paddingHorizontal),
            child: Column(
              children: [
                TextFieldCustom(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  validType: ValidType.email,
                  hintText: widget.email,
                  enabled: false,
                ),
                10.h,
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
                10.h,
                GestureDetector(
                    onTap: () {
                      replace(const GetStarted());
                    },
                    child: Text('key_use_another_account'.tr())),
                GestureDetector(
                    onTap: () {
                      push(const ForgotPassword());
                    },
                    child: Text('key_forgot_password'.tr())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
