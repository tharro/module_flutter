import 'package:plugin_helper/index.dart';

import '../../../api/api.dart';
import '../../../api/apiUrl.dart';
import '../../models/payment/payment_model.dart';

enum PaymentAction { setDefault, delete }

class PaymentRepository extends Api {
  Future<ListModel<PaymentModel>> getListPayment({required String url}) async {
    final response = await request(url, Method.get);
    return ListModel.fromJson(
      response.data,
      (json) => PaymentModel.fromJson(json),
    );
  }

  Future<void> addPaymentMethod({required String paymentId}) async {
    await request(APIUrl.payment, Method.post, body: {
      'pm_id': paymentId,
    });
  }

  Future<void> updatePaymentMethod(
      {required String paymentId, required PaymentAction action}) async {
    await request('${APIUrl.payment}$paymentId/',
        action == PaymentAction.delete ? Method.delete : Method.put);
  }
}
