import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';

import '../../blocs/payment/payment_bloc.dart';
import '../../configs/app_constrains.dart';
import '../../index.dart';
import '../../screens/payment/add_credit_card.dart';
import '../../screens/payment/payment_method_item.dart';
import '../../widgets/add_widget.dart';
import '../../widgets/app_list_view_custom.dart';
import '../../widgets/header_custom.dart';
import '../../widgets/loading_custom.dart';
import '../../widgets/overlay_loading_custom.dart';

class ListPayment extends StatefulWidget {
  const ListPayment({super.key});

  @override
  State<ListPayment> createState() => _ListPaymentState();
}

class _ListPaymentState extends State<ListPayment> {
  final PaymentBloc _paymentBloc = PaymentBloc();
  _getData({bool isRefreshing = false, bool isLoadingMore = false}) {
    _paymentBloc.add(GetListPayment(
      isFreshing: isRefreshing,
      isLoadingMore: isLoadingMore,
    ));
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayLoadingCustom(
      loadingWidget: BlocBuilder<PaymentBloc, PaymentState>(
        bloc: _paymentBloc,
        builder: (context, state) {
          return LoadingCustom(
            isLoading: state.updatePaymentLoading,
            isOverlay: true,
          );
        },
      ),
      child: Scaffold(
          appBar: HeaderCustom(
            context: context,
            textTitle: 'key_payment_method'.tr(),
            actions: [
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(
                    right: AppConstrains.paddingHorizontal),
                child: AddIcon(onTap: () {
                  push(const AddCreditCard());
                }),
              ))
            ],
          ),
          body: BlocBuilder<PaymentBloc, PaymentState>(
            bloc: _paymentBloc,
            builder: (context, state) {
              var payments = state.payment.results ?? [];
              return AppListViewCustom(
                  onRefresh: () {
                    _getData(isRefreshing: true);
                  },
                  onLoadMore: () {
                    _getData(isLoadingMore: true);
                  },
                  data: state.payment,
                  renderItem: (int index) => PaymentMethodItem(
                      isSelected: payments[index].isDefault!,
                      onSelect: () {
                        if (payments[index].isDefault!) {
                          return;
                        }

                        _paymentBloc.add(
                            SetDefaultPayment(paymentId: payments[index].id!));
                      },
                      onDelete: () {
                        _paymentBloc.add(SubmitDeletePaymentMethod(
                            paymentId: payments[index].id!));
                      },
                      payment: payments[index]));
            },
          )),
    );
  }
}
