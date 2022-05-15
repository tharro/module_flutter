import '../../api/apiUrl.dart';
import '../../api/api.dart';
import '../../models/credit_card_model.dart';

class PaymentRepositories extends Api {
  Future<void> addBank({required Map<String, dynamic> body}) async {
    final url = APIUrl.addBank;
    final response = await request(url, Method.post, body: body);
    print(response.data);
  }

  Future<void> getBank() async {
    final url = APIUrl.bank;
    final response = await request(url, Method.get);
    print(response.data);
  }

  Future<void> addCard({required Map<String, dynamic> body}) async {
    final url = APIUrl.addCard;
    final response = await request(url, Method.post, body: body);
    print(response.data);
  }

  Future<ListCreditCardModel> getCard() async {
    final url = APIUrl.card;
    final response = await request(url, Method.get);
    return ListCreditCardModel.fromJson(response.data);
  }
}
