part of 'payment_bloc.dart';

class PaymentState extends Equatable {
  final bool addPaymentLoading;
  final bool updatePaymentLoading;
  final ListModel<PaymentModel> payment;
  const PaymentState({
    required this.addPaymentLoading,
    required this.payment,
    required this.updatePaymentLoading,
  });

  factory PaymentState.empty() {
    return const PaymentState(
        updatePaymentLoading: false,
        addPaymentLoading: false,
        payment: ListModel());
  }

  PaymentState copyWith(
      {bool? addPaymentLoading,
      bool? updatePaymentLoading,
      ListModel<PaymentModel>? payment}) {
    return PaymentState(
      addPaymentLoading: addPaymentLoading ?? this.addPaymentLoading,
      payment: payment ?? this.payment,
      updatePaymentLoading: updatePaymentLoading ?? this.updatePaymentLoading,
    );
  }

  @override
  List<Object?> get props => [
        addPaymentLoading,
        payment,
        updatePaymentLoading,
      ];
}
