part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class GetListPayment extends PaymentEvent {
  /// When user pull to refresh
  final bool isFreshing;

  /// When user scroll to end the list
  final bool isLoadingMore;
  const GetListPayment({this.isFreshing = false, this.isLoadingMore = false});
}

class SubmitAddPaymentMethod extends PaymentEvent {
  final String paymentId;
  const SubmitAddPaymentMethod({required this.paymentId});
}

class SubmitDeletePaymentMethod extends PaymentEvent {
  final String paymentId;
  const SubmitDeletePaymentMethod({required this.paymentId});
}

class SetDefaultPayment extends PaymentEvent {
  final String paymentId;
  const SetDefaultPayment({required this.paymentId});
}
