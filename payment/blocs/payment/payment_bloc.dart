import 'package:plugin_helper/index.dart';

import '../../api/apiUrl.dart';
import '../../index.dart';
import '../../models/payment/payment_model.dart';
import '../../repositories/Payment/Payment_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentRepository paymentRepositories = PaymentRepository();
  PaymentBloc() : super(PaymentState.empty()) {
    on<SubmitAddPaymentMethod>(_submitAddPaymentMethod);
    on<GetListPayment>(_getListPayment);
    on<SubmitDeletePaymentMethod>(_submitDeletePaymentMethod);
    on<SetDefaultPayment>(_setDefaultPayment);
  }

  void _getListPayment(GetListPayment event, Emitter<PaymentState> emit) async {
    if (event.isLoadingMore && (state.payment.next == null) ||
        (state.payment.isLoadingMore)) {
      return;
    }

    if (event.isFreshing && state.payment.isRefreshing) {
      return;
    }

    try {
      emit(state.copyWith(
          payment: state.payment.copyWith(
              isLoadingMore: event.isLoadingMore,
              isLoading: !event.isLoadingMore && !event.isFreshing,
              isRefreshing: !event.isLoadingMore && event.isFreshing)));
      ListModel<PaymentModel> newPayment =
          await paymentRepositories.getListPayment(
              url: event.isLoadingMore ? state.payment.next! : APIUrl.payment);
      emit(state.copyWith(
          payment: newPayment.copyWith(
              results: event.isLoadingMore
                  ? state.payment.results! + newPayment.results!
                  : newPayment.results)));
    } catch (e) {
      emit(state.copyWith(
          payment: state.payment.copyWith(
        errorMessage: event.isLoadingMore ? null : e.parseError.message,
        isRefreshing: false,
        isLoading: false,
        isLoadingMore: false,
      )));

      if (event.isLoadingMore) {
        Helper.showToastBottom(message: e.parseError.message);
      }
    }
  }

  void _submitAddPaymentMethod(
      SubmitAddPaymentMethod event, Emitter<PaymentState> emit) async {
    try {
      emit(state.copyWith(addPaymentLoading: true));
      await paymentRepositories.addPaymentMethod(paymentId: event.paymentId);
      emit(state.copyWith(addPaymentLoading: false));
      add(const GetListPayment(isFreshing: true));
      Helper.showToastBottom(
          message: 'key_add_payment_success'.tr(), type: ToastType.success);
      goBack();
    } catch (e) {
      emit(state.copyWith(addPaymentLoading: false));
      Helper.showToastBottom(message: e.parseError.message);
    }
  }

  void _submitDeletePaymentMethod(
      SubmitDeletePaymentMethod event, Emitter<PaymentState> emit) async {
    try {
      emit(state.copyWith(updatePaymentLoading: true));
      await paymentRepositories.updatePaymentMethod(
          paymentId: event.paymentId, action: PaymentAction.delete);
      state.payment.results!
          .removeWhere((payment) => payment.id == event.paymentId);
      bool isDefault =
          state.payment.results!.any((element) => element.isDefault!);
      if (!isDefault && state.payment.results!.isNotEmpty) {
        await paymentRepositories.updatePaymentMethod(
            paymentId: state.payment.results![0].id!,
            action: PaymentAction.setDefault);
        emit(state.copyWith(updatePaymentLoading: false));
      } else {
        emit(state.copyWith(updatePaymentLoading: false));
      }
      add(const GetListPayment(isFreshing: true));
    } catch (e) {
      emit(state.copyWith(updatePaymentLoading: false));
      Helper.showToastBottom(message: e.parseError.message);
    }
  }

  void _setDefaultPayment(
      SetDefaultPayment event, Emitter<PaymentState> emit) async {
    try {
      emit(state.copyWith(updatePaymentLoading: true));
      await paymentRepositories.updatePaymentMethod(
          paymentId: event.paymentId, action: PaymentAction.setDefault);
      List<PaymentModel>? listPayment = state.payment.results!.map((payment) {
        return payment.copyWith(isDefault: payment.id == event.paymentId);
      }).toList();
      emit(state.copyWith(
          updatePaymentLoading: false,
          payment: state.payment.copyWith(results: listPayment)));
    } catch (e) {
      emit(state.copyWith(updatePaymentLoading: false));
      Helper.showToastBottom(message: e.parseError.message);
    }
  }
}
