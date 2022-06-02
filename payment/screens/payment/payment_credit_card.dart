import '../../blocs/payment/credit_card/credit_card_bloc.dart';
import '../../widgets/credit_card_custom.dart';
import '../../widgets/overlay_loading_custom.dart';
import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';
import '../../index.dart';

class PaymentCreditCard extends StatefulWidget {
  const PaymentCreditCard({Key? key}) : super(key: key);

  @override
  State<PaymentCreditCard> createState() => _PaymentCreditCardState();
}

class _PaymentCreditCardState extends State<PaymentCreditCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    MyPluginPayment.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreditCardBloc, CreditCardState>(
      builder: (context, state) {
        return OverlayLoadingCustom(
            isLoading: _isLoading || state.addCardLoading!,
            child: Scaffold(body: SingleChildScrollView(child: CreditCardCustom(
              onSubmit: (CreditCardModel card) async {
                if (card.cardNumber != '') {
                  setState(() {
                    _isLoading = true;
                  });
                  String tokenId =
                      await MyPluginPayment.createTokenWidthCreditCard(
                          data: card);
                  setState(() {
                    _isLoading = false;
                  });
                  Map<String, dynamic> body = {
                    'pm_id': tokenId,
                  };
                  BlocProvider.of<CreditCardBloc>(context).add(AddCreditCard(
                      onSuccess: () {},
                      onError: (code, message) {
                        Helper.showErrorDialog(
                            context: context,
                            message: message,
                            code: code,
                            onPressPrimaryButton: () {
                              Navigator.pop(context);
                            });
                      },
                      body: body));
                }
              },
            ))));
      },
    );
  }
}
