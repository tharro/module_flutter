import '../../screens/auth/verify.dart';
import '../../widgets/button_custom.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../configs/app_constrains.dart';
import '../../screens/auth/get_started.dart';
import 'package:flutter/material.dart';
import 'package:plugin_helper/plugin_navigator.dart';
import 'package:plugin_helper/index.dart';
import '../../index.dart';

class OptionsVerify extends StatefulWidget {
  const OptionsVerify({Key? key}) : super(key: key);

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
                              if (!state.getStartedModel!.isVerifiedPhone!)
                                SizedBox(
                                    width: 100,
                                    child: ButtonCustom(
                                        title: 'verify'.tr(),
                                        onPressed: () async {
                                          MyPluginNavigation.instance
                                              .push(Verify(
                                            isFromSignUp: false,
                                            isResend: true,
                                            user: state.getStartedModel!.phone!,
                                            type: 'phone',
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
                                ? Colors.white
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
                                      if (state
                                          .getStartedModel!.isVerifiedPhone!) {
                                        MyPluginNavigation.instance.push(Verify(
                                          isFromSignUp: false,
                                          isResend: true,
                                          user: state.getStartedModel!.email!,
                                          type: 'email',
                                        ));
                                      }
                                    }))
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                          onTap: () {
                            MyPluginNavigation.instance
                                .replace(const GetStarted());
                          },
                          child: Text('key_use_another_account'.tr())),
                    ],
                  ))));
    });
  }
}
