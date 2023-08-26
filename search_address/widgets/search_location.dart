import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';

import '../blocs/search_address/search_address_bloc.dart';
import '../configs/app_constrains.dart';
import '../configs/app_text_styles.dart';
import '../index.dart';
import '../models/address/address_detail_model.dart';
import '../models/address/address_model.dart';
import '../widgets/button_custom.dart';
import '../widgets/error_custom.dart';
import '../widgets/header_custom.dart';
import '../widgets/loading_custom.dart';
import '../widgets/overlay_loading_custom.dart';
import '../widgets/text_field_custom.dart';

class SearchLocation extends StatefulWidget {
  final Prediction? address;
  const SearchLocation({super.key, this.address});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  final SearchAddressBloc _searchAddressBloc = SearchAddressBloc();
  List<Prediction> _addresses = [];
  bool _isValidAddress = false,
      _isValidCity = false,
      _isValidState = false,
      _isValidPostcode = false,
      _isValidCountry = false;
  final TextEditingController _addressController = TextEditingController(),
      _cityController = TextEditingController(),
      _stateController = TextEditingController(),
      _countryController = TextEditingController(),
      _postcodeController = TextEditingController();
  double? _lat = 0, _lng = 0;

  _getData({required String text}) {
    _searchAddressBloc.add(SearchAddressOSM(
        address: text,
        onSuccess: (predictions) {
          if (!mounted) return;
          setState(() {
            _addresses = predictions;
          });
        }));
  }

  _onGetAddressDetails(Prediction prediction) {
    _searchAddressBloc.add(GetAddressOSMDetails(
        prediction: prediction,
        onSuccess: (address) {
          _addressController.text = address.address;
          _cityController.text = address.city;
          _stateController.text = address.state;
          _countryController.text = address.country;
          _postcodeController.text = address.postcode;
          setState(() {
            _isValidAddress = _addressController.text.trim().isNotEmpty;
            _isValidCity = _cityController.text.trim().isNotEmpty;
            _isValidState = _stateController.text.trim().isNotEmpty;
            _isValidCountry = _countryController.text.trim().isNotEmpty;
            _isValidPostcode = _postcodeController.text.trim().isNotEmpty;
            _lat = address.lat;
            _lng = address.lng;
          });
        }));
  }

  @override
  void initState() {
    if (widget.address != null) {
      _onGetAddressDetails(widget.address!);
    }
    super.initState();
  }

  Widget get _titleBuilder {
    if (_addressController.text.trim().isNotEmpty || widget.address != null) {
      return Text(
        'key_address'.tr(),
        style: AppTextStyles.textSize12(),
      );
    }

    return SearchTextField(
        autofocus: true,
        padding: const EdgeInsets.only(right: AppConstrains.paddingHorizontal),
        onChange: (text) {
          if (text.isEmpty) {
            setState(() {
              _addresses = [];
            });
            return;
          }

          _getData(text: text);
        });
  }

  @override
  Widget build(BuildContext context) {
    return OverlayLoadingCustom(
      loadingWidget: BlocBuilder<SearchAddressBloc, SearchAddressState>(
        bloc: _searchAddressBloc,
        builder: (context, state) {
          return LoadingCustom(
            isOverlay: true,
            isLoading: state.getAddressDetailsLoading!,
          );
        },
      ),
      child: Scaffold(
        appBar: HeaderCustom(widgetTitle: _titleBuilder),
        body: BlocBuilder<SearchAddressBloc, SearchAddressState>(
          bloc: _searchAddressBloc,
          builder: (context, state) {
            if (state.searchAddressLoading!) {
              return const Center(child: LoadingCustom());
            }

            if (state.errorSearchAddress!.isNotEmpty) {
              return Center(
                  child: ErrorCustom(error: state.errorSearchAddress!));
            }

            if (_addressController.text.trim().isNotEmpty) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstrains.paddingHorizontal),
                  child: Column(
                    children: [
                      16.h,
                      TextFieldCustom(
                        controller: _addressController,
                        validType: ValidType.notEmpty,
                        label: 'key_address'.tr(),
                        hintText: 'key_required'.tr(),
                        onValid: (valid) {
                          setState(() {
                            _isValidAddress = valid;
                          });
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      16.h,
                      TextFieldCustom(
                        label: 'key_city'.tr(),
                        hintText: 'key_required'.tr(),
                        controller: _cityController,
                        validType: ValidType.notEmpty,
                        onValid: (valid) {
                          setState(() {
                            _isValidCity = valid;
                          });
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      16.h,
                      TextFieldCustom(
                        label: 'key_state'.tr(),
                        hintText: 'key_required'.tr(),
                        controller: _stateController,
                        validType: ValidType.notEmpty,
                        onValid: (valid) {
                          setState(() {
                            _isValidState = valid;
                          });
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      16.h,
                      TextFieldCustom(
                        label: 'key_country'.tr(),
                        hintText: 'key_required'.tr(),
                        controller: _countryController,
                        onValid: (valid) {
                          setState(() {
                            _isValidCountry = valid;
                          });
                        },
                        validType: ValidType.notEmpty,
                        textInputAction: TextInputAction.next,
                      ),
                      16.h,
                      TextFieldCustom(
                        label: 'key_postcode'.tr(),
                        hintText: 'key_required'.tr(),
                        controller: _postcodeController,
                        validType: ValidType.notEmpty,
                        onValid: (valid) {
                          setState(() {
                            _isValidPostcode = valid;
                          });
                        },
                      ),
                      16.h,
                      Row(
                        children: [
                          Expanded(
                              child: ButtonCustom(
                                  enabled: _isValidAddress &&
                                      _isValidCity &&
                                      _isValidState &&
                                      _isValidPostcode &&
                                      _isValidCountry,
                                  title: 'key_continue'.tr(),
                                  onPressed: () {
                                    goBack(
                                        context: context,
                                        callback: Address(
                                          address: _addressController.text,
                                          city: _cityController.text,
                                          state: _stateController.text,
                                          country: _countryController.text,
                                          postcode: _postcodeController.text,
                                          lat: _lat ?? 0.0,
                                          lng: _lng ?? 0.0,
                                        ));
                                  })),
                          16.w,
                          Expanded(
                            child: ButtonCustom(
                                title: 'key_cancel'.tr(),
                                isSecondary: true,
                                onPressed: () {
                                  if (widget.address != null) {
                                    goBack();
                                    return;
                                  }

                                  _addressController.clear();
                                  _cityController.clear();
                                  _stateController.clear();
                                  _countryController.clear();
                                  _postcodeController.clear();
                                  setState(() {});
                                }),
                          ),
                        ],
                      ),
                      SizedBox(height: context.safeViewBottom)
                    ],
                  ),
                ),
              );
            }

            return SingleChildScrollView(
                child: Column(
              children: _addresses.map((address) {
                return InkWell(
                    onTap: () {
                      _onGetAddressDetails(address);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppConstrains.paddingHorizontal),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: _addresses.length - 1 ==
                                            _addresses.indexOf(address)
                                        ? Colors.transparent
                                        : Colors.grey.shade300))),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Colors.grey[400],
                            ),
                            8.w,
                            Expanded(
                                child: Text(
                              address.description!,
                              style: AppTextStyles.textSize14(),
                            )),
                          ],
                        ),
                      ),
                    ));
              }).toList(),
            ));
          },
        ),
      ),
    );
  }
}
