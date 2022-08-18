import 'dart:convert';
import 'dart:io';

import '../blocs/payment/bank/bank_bloc.dart';
import 'button_custom.dart';
import 'text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';
import '../index.dart';

class BankCustom extends StatefulWidget {
  const BankCustom({Key? key}) : super(key: key);

  @override
  State<BankCustom> createState() => _BankCustomState();
}

class _BankCustomState extends State<BankCustom> {
  final TextEditingController _accountHolderController =
      TextEditingController();

  final TextEditingController _routingController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final FocusNode _accountHolderFocusNode = FocusNode();
  final FocusNode _routingFocusNode = FocusNode();
  final FocusNode _accountNumberFocusNode = FocusNode();
  bool _isValidAccountHolder = false, _isValidAccountNumber = false;
  List<dynamic> listCountriesWithCurrency = [];
  String _countryCode = '', _currency = '';
  @override
  void initState() {
    getCountryCode();
    super.initState();
  }

  getCountryCode() async {
    String localeName = Platform.localeName;
    _countryCode = localeName.split('_').last;
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/countries.json");
    final result = jsonDecode(data);
    listCountriesWithCurrency = result['countries']['country'];
    _currency = listCountriesWithCurrency.firstWhere(
        (element) => element['countryCode'] == _countryCode)['currencyCode'];
  }

  _submit() async {
    if (!_isValidAccountHolder || !_isValidAccountNumber) {
      return;
    }
    Map<String, dynamic> body = {
      'country_code': _countryCode,
      'currency': _currency,
      'account_number': _accountNumberController.text,
      'routing_number': _routingController.text,
      'account_holder_name': _accountHolderController.text,
      'account_holder_type': 'Individual'
    };
    BlocProvider.of<BankBloc>(context).add(AddBank(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          TextFieldCustom(
            controller: _accountHolderController,
            focusNode: _accountHolderFocusNode,
            validType: ValidType.notEmpty,
            hintText: 'key_account_holder_name'.tr(),
            onValid: (bool val) {
              _isValidAccountHolder = val;
            },
            textInputAction: TextInputAction.next,
          ),
          10.h,
          TextFieldCustom(
            controller: _accountNumberController,
            focusNode: _accountNumberFocusNode,
            validType: ValidType.notEmpty,
            keyboardType: TextInputType.number,
            hintText: 'key_account_number'.tr(),
            onValid: (bool val) {
              _isValidAccountNumber = val;
            },
            textInputAction: TextInputAction.next,
          ),
          10.h,
          TextFieldCustom(
            controller: _routingController,
            focusNode: _routingFocusNode,
            validType: ValidType.none,
            keyboardType: TextInputType.number,
            hintText: 'key_routing'.tr(),
            showError: false,
            onFieldSubmitted: (text) {
              _submit();
            },
          ),
          10.h,
          ButtonCustom(title: 'key_add_bank'.tr(), onPressed: _submit)
        ],
      ),
    ));
  }
}
