import '../../../repositories/payment/payment_repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:plugin_helper/index.dart';
import '../../../index.dart';
part 'bank_event.dart';
part 'bank_state.dart';

class BankBloc extends Bloc<BankEvent, BankState> {
  final PaymentRepositories paymentRepositories = PaymentRepositories();
  BankBloc() : super(BankState.empty()) {
    on<AddBank>(_addCreditCard);
  }

  void _addCreditCard(AddBank event, Emitter<BankState> emit) async {
    try {
      emit(state.copyWith(addBankLoading: true));
      await paymentRepositories.addBank(body: event.body);
      emit(state.copyWith(addBankLoading: false));
      event.onSuccess();
    } catch (e) {
      emit(state.copyWith(addBankLoading: false));
      event.onError(e.parseError.code, e.parseError.message);
    }
  }
}
