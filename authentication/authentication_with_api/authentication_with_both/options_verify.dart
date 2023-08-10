import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../configs/app_constrains.dart';
import '../../index.dart';
import '../../screens/auth/get_started.dart';
import '../../screens/auth/verify.dart';
import '../../widgets/button_custom.dart';

class OptionsVerify extends StatefulWidget {
  final String? password;
  final String emailOrPhone;
  const OptionsVerify({Key? key, this.password, required this.emailOrPhone})
      : super(key: key);

  @override
  State<OptionsVerify> createState() => _OptionsVerifyState();
}

class _OptionsVerifyState extends State<OptionsVerify> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: AppConstrains.paddingVertical,
                horizontal: AppConstrains.paddingHorizontal),
            child: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                        color: state.getStartedModel!.isVerifiedPhone!
                            ? Colors.green
                            : Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text('key_phone'.tr()),
                              const SizedBox(height: 3),
                              Text(state.getStartedModel!.phone!),
                            ],
                          ),
                        ),
                        Container(
                            width: 100,
                            color: !state.getStartedModel!.isVerifiedPhone!
                                ? Colors.white
                                : Colors.green,
                            child: ButtonCustom(
                                title: 'verify'.tr(),
                                onPressed: () async {
                                  push(Verify(
                                    receiver: state.getStartedModel!.phone!,
                                    type: 'phone',
                                    password: widget.password,
                                    isVerifyEmail:
                                        state.getStartedModel!.isVerifiedEmail!,
                                    emailOrPhone: widget.emailOrPhone,
                                  ));
                                }))
                      ],
                    )),
                20.h,
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                      color: state.getStartedModel!.isVerifiedPhone!
                          ? Colors.green
                          : Colors.grey,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text('key_email'.tr()),
                            const SizedBox(height: 3),
                            Text(state.getStartedModel!.email!),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: 100,
                          child: ButtonCustom(
                              title: 'verify'.tr(),
                              onPressed: () {
                                push(Verify(
                                  receiver: state.getStartedModel!.email!,
                                  emailOrPhone: widget.emailOrPhone,
                                  type: 'email',
                                  password: widget.password,
                                  isVerifyPhone:
                                      state.getStartedModel!.isVerifiedPhone!,
                                ));
                              }))
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                    onTap: () {
                      replace(const GetStarted());
                    },
                    child: Text('key_use_another_account'.tr())),
              ],
            ),
          ),
        ),
      );
    });
  }
}
