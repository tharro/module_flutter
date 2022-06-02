import '../../../repositories/payment/payment_repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:plugin_helper/index.dart';
import '../../../index.dart';
part 'credit_card_event.dart';
part 'credit_card_state.dart';

class CreditCardBloc extends Bloc<CreditCardEvent, CreditCardState> {
  final PaymentRepositories paymentRepositories = PaymentRepositories();
  CreditCardBloc() : super(CreditCardState.empty()) {
    on<AddCreditCard>(_addCreditCard);
  }

  void _addCreditCard(
      AddCreditCard event, Emitter<CreditCardState> emit) async {
    try {
      emit(state.copyWith(addCardLoading: true));
      await paymentRepositories.addCard(body: event.body);
      emit(state.copyWith(addCardLoading: false));
      event.onSuccess();
    } catch (e) {
      emit(state.copyWith(addCardLoading: false));
      event.onError(e.parseError.code, e.parseError.message);
    }
  }
}
