import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';

import '../../configs/app_text_styles.dart';
import '../../index.dart';
import '../../models/payment/payment_model.dart';

class PaymentMethodItem extends StatelessWidget {
  final bool isSelected;
  final PaymentModel payment;
  final Function() onSelect;
  final Function()? onDelete;

  const PaymentMethodItem({
    Key? key,
    required this.isSelected,
    required this.onSelect,
    required this.payment,
    this.onDelete,
  }) : super(key: key);

  String get image {
    switch (payment.brand) {
      case CardType.visa:
        return MyPluginAppAssets().visa;
      case CardType.americanExpress:
        return MyPluginAppAssets().amex;
      case CardType.discover:
        return MyPluginAppAssets().discovery;
      case CardType.mastercard:
        return MyPluginAppAssets().mastercard;
      default:
        return '';
    }
  }

  _onDelete(BuildContext context) {
    Helper.showErrorDialog(
        message: 'key_ask_delete_card'.tr(),
        isShowSecondButton: true,
        onPressPrimaryButton: () {
          onDelete!();
        });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 1.0,
                            offset: const Offset(0.0, 1.0))
                      ]),
                  width: 48,
                  height: 30,
                  child: image.isEmpty
                      ? Container(color: Colors.grey[300])
                      : Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(image,
                                      package: 'plugin_helper'))),
                        )),
              12.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "**** **** **** ${payment.last4}",
                      style: AppTextStyles.textSize16(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    8.h,
                    Text(
                      "${"key_expired".tr()}: ${payment.expMonth.toString().padLeft(2, '0')}/${payment.expYear}",
                      style: AppTextStyles.textSize14(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              12.w,
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.green),
              if (onDelete != null)
                IconButton(
                    onPressed: () {
                      _onDelete(context);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.grey[300],
                    ))
            ],
          ),
        ),
      ),
    );
  }
}
