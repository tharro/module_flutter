import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';
import 'package:plugin_helper/widgets/phone_number/intl_phone_number_input.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../configs/app_constrains.dart';
import '../../index.dart';
import '../../screens/auth/get_started.dart';
import '../../screens/auth/options_verify.dart';
import '../../widgets/bottom_appbar_custom.dart';
import '../../widgets/button_custom.dart';
import '../../widgets/loading_custom.dart';
import '../../widgets/overlay_loading_custom.dart';
import '../../widgets/phone_number_custom.dart';
import '../../widgets/text_field_custom.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key, required this.emailOrPhone}) : super(key: key);
  final String emailOrPhone;
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
      _isValidLastName = false,
      _isValidPhone = false,
      _isValidEmail = false;
  String _phoneNumber = '';
  PhoneNumber _initPhone = PhoneNumber(dialCode: '+61', isoCode: 'AU');

  _submit() {
    if (!_isValidPassword ||
        !_isValidFirstName ||
        !_isValidLastName ||
        !_isValidPhone ||
        !_isValidEmail) {
      return;
    }
    BlocProvider.of<AuthBloc>(context).add(AuthSignUp(
        body: {
          'username': BlocProvider.of<AuthBloc>(context)
              .state
              .getStartedModel!
              .username!,
          'email': _emailController.text.trim(),
          'phone': _phoneNumber,
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'password': _passwordController.text.trim(),
        },
        onSuccess: () {
          replace(OptionsVerify(emailOrPhone: widget.emailOrPhone));
        }));
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    if (widget.emailOrPhone.isPhoneNumber) {
      _phoneNumber = widget.emailOrPhone;
      _isValidPhone = true;
      _initPhone =
          await PhoneNumber.getRegionInfoFromPhoneNumber(widget.emailOrPhone);
      _phoneController.text = _initPhone.phoneNumber!;
    } else {
      _emailController.text = widget.emailOrPhone;
      _isValidEmail = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return OverlayLoadingCustom(
        loadingWidget: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return LoadingCustom(
                isOverlay: true, isLoading: state.signUpLoading!);
          },
        ),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: AppConstrains.paddingVertical,
                        horizontal: AppConstrains.paddingHorizontal),
                    child: Column(
                      children: [
                        TextFieldCustom(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          validType: ValidType.email,
                          hintText: !widget.emailOrPhone.isPhoneNumber
                              ? widget.emailOrPhone
                              : 'key_email'.tr(),
                          onValid: (bool val) {
                            _isValidEmail = val;
                          },
                          enabled: widget.emailOrPhone.isPhoneNumber,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (text) {
                            _passwordFocusNode.requestFocus();
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (!widget.emailOrPhone.isPhoneNumber)
                          PhoneNumberCustom(
                              initialValue: _initPhone,
                              autoFocus: true,
                              onInputValidated: (bool val) {
                                setState(() {
                                  _isValidPhone = val;
                                });
                              },
                              hasError: _isValidPhone,
                              onInputChanged: (PhoneNumber number) {
                                _phoneNumber = number.phoneNumber!;
                              },
                              controller: _phoneController,
                              focusNode: _phoneFocusNode)
                        else
                          TextFieldCustom(
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            hintText: _phoneNumber,
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
  }
}
