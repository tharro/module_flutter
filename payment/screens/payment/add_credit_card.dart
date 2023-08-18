import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:plugin_helper/index.dart';

import '../../../blocs/payment/payment_bloc.dart';
import '../../../configs/app_constrains.dart';
import '../../../configs/app_text_styles.dart';
import '../../../index.dart';
import '../../../widgets/button_custom.dart';
import '../../../widgets/loading_custom.dart';
import '../../../widgets/overlay_loading_custom.dart';
import '../../../widgets/text_field_custom.dart';

class AddCreditCard extends StatefulWidget {
  const AddCreditCard({Key? key}) : super(key: key);

  @override
  State<AddCreditCard> createState() => _AddCreditCardState();
}

class _AddCreditCardState extends State<AddCreditCard> {
  final FocusNode _cardNumberNode = FocusNode();
  final FocusNode _expiredNode = FocusNode();
  final FocusNode _cVVNode = FocusNode();
  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final MaskedTextController _expiredController =
      MaskedTextController(mask: '00/00');
  final MaskedTextController _cVVController =
      MaskedTextController(mask: '0000');
  late bool _validCardNumber = false, _validExpired = false, _validCvv = false;
  bool _isLoading = false;
  String _logo = MyPluginAppAssets().visa;
  final PaymentBloc _paymentBloc = PaymentBloc();

  @override
  void initState() {
    Stripe.publishableKey = MyPluginAppEnvironment().stripePublicKey!;
    _cardNumberController.addListener(() {
      setState(() {
        _logo = _checkLogo;
      });
    });
    super.initState();
  }

  _submit() async {
    setState(() {
      _isLoading = true;
    });
    final CardDetails payment = CardDetails(
      cvc: _cVVController.text,
      expirationMonth: int.parse(_expiredController.text.split('/')[0]),
      expirationYear: int.parse(_expiredController.text.split('/')[1]),
      number: _cardNumberController.text,
    );
    await Stripe.instance.dangerouslyUpdateCardDetails(payment);
    final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: const PaymentMethodParams.card(
            paymentMethodData: PaymentMethodData()));

    setState(() {
      _isLoading = false;
    });
    _paymentBloc.add(SubmitAddPaymentMethod(paymentId: paymentMethod.id));
  }

  String get _checkLogo {
    CardType cardType = MyPluginHelper.detectCCType(_cardNumberController.text);
    switch (cardType) {
      case CardType.visa:
        return MyPluginAppAssets().visa;
      case CardType.americanExpress:
        return MyPluginAppAssets().amex;
      case CardType.discover:
        return MyPluginAppAssets().discovery;
      case CardType.mastercard:
        return MyPluginAppAssets().mastercard;
      default:
    }
    return MyPluginAppAssets().visa;
  }

  @override
  Widget build(BuildContext context) {
    return OverlayLoadingCustom(
      loadingWidget: BlocBuilder<PaymentBloc, PaymentState>(
        bloc: _paymentBloc,
        builder: (context, state) {
          return LoadingCustom(
            isLoading: _isLoading || state.addPaymentLoading,
            isOverlay: true,
          );
        },
      ),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstrains.paddingHorizontal),
            child: Column(children: [
              40.h,
              Text(
                'key_add_payment_method'.tr(),
                style: AppTextStyles.textSize22(fontWeight: FontWeight.w500),
              ),
              6.h,
              Text(
                'key_provide_your_credit_card_information'.tr(),
                style: AppTextStyles.textSize14(color: Colors.grey),
              ),
              32.h,
              TextFieldCustom(
                focusNode: _cardNumberNode,
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                validType: ValidType.cardNumber,
                label: 'key_card_number'.tr(),
                hintText: '0000 0000 0000 0000',
                prefixIcon: Container(
                  width: 30,
                  height: 20,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                            _logo,
                            package: 'plugin_helper',
                          ))),
                ),
                onValid: (bool valid) {
                  setState(() {
                    _validCardNumber = valid;
                  });
                },
                textInputAction: TextInputAction.next,
              ),
              16.h,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFieldCustom(
                      focusNode: _expiredNode,
                      controller: _expiredController,
                      keyboardType: TextInputType.number,
                      validType: ValidType.expired,
                      prefixIcon: Icon(
                        Icons.date_range_rounded,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                      label: 'key_expired'.tr(),
                      hintText: 'MM/YYYY',
                      onValid: (bool valid) {
                        setState(() {
                          _validExpired = valid;
                        });
                      },
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  8.w,
                  Expanded(
                      child: TextFieldCustom(
                    focusNode: _cVVNode,
                    controller: _cVVController,
                    keyboardType: TextInputType.number,
                    validType: ValidType.cvv,
                    label: 'key_cvv'.tr(),
                    hintText: '0000',
                    onValid: (bool valid) {
                      setState(() {
                        _validCvv = valid;
                      });
                    },
                  )),
                ],
              ),
              32.h,
              Row(
                children: [
                  Expanded(
                    child: ButtonCustom(
                        enabled: _validCardNumber && _validCvv && _validExpired,
                        title: 'key_add_card'.tr(),
                        onPressed: _submit),
                  ),
                  16.w,
                  ButtonCustom(
                      isSecondary: true,
                      width: 100,
                      padding: EdgeInsets.zero,
                      title: 'key_cancel'.tr(),
                      onPressed: () {
                        goBack();
                      })
                ],
              ),
              SizedBox(height: context.safeViewBottom)
            ]),
          )),
        ),
      ),
    );
  }
}
