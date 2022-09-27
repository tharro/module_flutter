import '../blocs/payment/credit_card/credit_card_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../models/payment/card_model.dart';
import '../../configs/app_constrains.dart';
import '../../widgets/text_field_custom.dart';
import '../../widgets/button_custom.dart';
import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';
import '../../index.dart';

class CreditCardCustom extends StatefulWidget {
  final Function() onSubmit;
  const CreditCardCustom({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<CreditCardCustom> createState() => _CreditCardCustomState();
}

class _CreditCardCustomState extends State<CreditCardCustom> {
  late final CardModel _card = CardModel('', '', '', false);
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

  @override
  void initState() {
    _cardNumberController.addListener(() {
      _card.cardNumber = _cardNumberController.text;
    });
    _expiredController.addListener(() {
      _card.expiryDate = _expiredController.text;
    });
    _cVVController.addListener(() {
      _card.cvvCode = _cVVController.text;
    });
    Stripe.publishableKey = MyPluginAppEnvironment().stripePublicKey!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextFieldCustom(
        focusNode: _cardNumberNode,
        controller: _cardNumberController,
        validType: ValidType.cardNumber,
        label: 'key_card_number'.tr(),
        onValid: (bool valid) {
          _validCardNumber = valid;
        },
        textInputAction: TextInputAction.next,
      ),
      8.h,
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFieldCustom(
              focusNode: _expiredNode,
              controller: _expiredController,
              validType: ValidType.expired,
              label: 'key_expired'.tr(),
              onValid: (bool valid) {
                _validExpired = valid;
              },
              textInputAction: TextInputAction.next,
            ),
          ),
          8.w,
          Expanded(
              child: TextFieldCustom(
            focusNode: _cVVNode,
            controller: _cVVController,
            validType: ValidType.cvv,
            label: 'key_cvv'.tr(),
            onValid: (bool valid) {
              _validCvv = valid;
            },
          )),
        ],
      ),
      const SizedBox(height: AppConstrains.paddingHorizontal),
      ButtonCustom(
          title: 'key_add_card'.tr(),
          onPressed: () async {
            if (!_validCardNumber || !_validExpired || !_validCvv) {
              return;
            }
            final CardDetails payment = CardDetails(
              cvc: _card.cvvCode,
              expirationMonth: int.parse(_card.expiryDate.split('/')[0]),
              expirationYear: int.parse(_card.expiryDate.split('/')[1]),
              number: _card.cardNumber,
            );
            await Stripe.instance.dangerouslyUpdateCardDetails(payment);
            final paymentMethod = await Stripe.instance
                .createPaymentMethod(const PaymentMethodParams.card(
              paymentMethodData: PaymentMethodData(billingDetails: null),
            ));

            Map<String, dynamic> body = {
              'pm_id': paymentMethod.id,
            };

            BlocProvider.of<CreditCardBloc>(context).add(AddCreditCard(
                onSuccess: () {},
                onError: (message) {
                  showToastBottom(message: message);
                },
                body: body));
          })
    ]);
  }
}
