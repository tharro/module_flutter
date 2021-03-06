import '../../configs/app_constrains.dart';
import '../../widgets/text_field_custom.dart';
import '../../widgets/button_custom.dart';
import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';
import '../../index.dart';

class CreditCardCustom extends StatefulWidget {
  final Function(CreditCardModel) onSubmit;
  const CreditCardCustom({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<CreditCardCustom> createState() => _CreditCardCustomState();
}

class _CreditCardCustomState extends State<CreditCardCustom> {
  late final CreditCardModel _card = CreditCardModel('', '', '', '', false);
  final FocusNode _cardNumberNode = FocusNode();
  final FocusNode _cardHolderNode = FocusNode();
  final FocusNode _expiredNode = FocusNode();
  final FocusNode _cVVNode = FocusNode();
  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _cardHolderController = TextEditingController();
  final MaskedTextController _expiredController =
      MaskedTextController(mask: '00/00');
  final MaskedTextController _cVVController =
      MaskedTextController(mask: '0000');
  late bool _validCardHolder = false,
      _validCardNumber = false,
      _validExpired = false,
      _validCvv = false;

  @override
  void initState() {
    _cardHolderController.addListener(() {
      _card.cardHolder = _cardHolderController.text;
    });
    _cardNumberController.addListener(() {
      _card.cardNumber = _cardNumberController.text;
    });
    _expiredController.addListener(() {
      _card.expiryDate = _expiredController.text;
    });
    _cVVController.addListener(() {
      _card.cvvCode = _cVVController.text;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextFieldCustom(
        focusNode: _cardHolderNode,
        controller: _cardHolderController,
        validType: ValidType.notEmpty,
        label: 'key_card_name'.tr(),
        onValid: (bool valid) {
          _validCardHolder = valid;
        },
        textInputAction: TextInputAction.next,
      ),
      const SizedBox(height: AppConstrains.paddingHorizontal),
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
      const SizedBox(height: AppConstrains.paddingHorizontal),
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
          const SizedBox(width: AppConstrains.paddingHorizontal),
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
          onPressed: () {
            if (!_validCardHolder ||
                !_validCardNumber ||
                !_validExpired ||
                !_validCvv) {
              return;
            }
            widget.onSubmit(_card);
          })
    ]);
  }
}
