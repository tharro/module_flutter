import '../../screens/auth/verify.dart';
import '../../widgets/button_custom.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../configs/app_constrains.dart';
import '../../screens/auth/get_started.dart';
import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';
import '../../index.dart';

class OptionsVerify extends StatefulWidget {
  final String? password;
  const OptionsVerify({Key? key, this.password}) : super(key: key);

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
                  padding: EdgeInsets.symmetric(
                      vertical: AppConstrains.paddingVertical,
                      horizontal: AppConstrains.paddingHorizontal),
                  child: Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
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
                                  color:
                                      !state.getStartedModel!.isVerifiedPhone!
                                          ? Colors.white
                                          : Colors.green,
                                  child: ButtonCustom(
                                      title: 'verify'.tr(),
                                      onPressed: () async {
                                        push(Verify(
                                          isResend: true,
                                          user: state.getStartedModel!.phone!,
                                          type: 'phone',
                                          password: widget.password,
                                        ));
                                      }))
                            ],
                          )),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
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
                                        isResend: true,
                                        user: state.getStartedModel!.email!,
                                        type: 'email',
                                        password: widget.password,
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
                  ))));
    });
  }
}
