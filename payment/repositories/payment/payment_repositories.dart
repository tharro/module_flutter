import '../../api/apiUrl.dart';
import '../../api/api.dart';

class PaymentRepositories extends Api {
  Future<void> addOrUpdateBank({required Map<String, dynamic> body}) async {
    final url = ''; // APIUrl.addOrUpdateBankAccount;
    final response = await request(url, Method.post, body: body);
    print(response.data);
  }

  Future<void> addCard({required Map<String, dynamic> body}) async {
    final url = ''; // APIUrl.addCard;
    final response = await request(url, Method.post, body: body);
    print(response.data);
  }
}
