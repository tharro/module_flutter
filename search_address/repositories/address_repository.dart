import '../../../api/api.dart';
import '../../../api/apiUrl.dart';
import '../../models/address/address_detail_model.dart';
import '../../models/address/address_model.dart';

class AddressRepository extends Api {
  Future<List<Prediction>> searchAddress({required String address}) async {
    final response = await request(APIUrl.searchAddress(address), Method.get,
        useIDToken: false);
    return List<Prediction>.from(
        (response.data as List).map((e) => Prediction.fromMap(e)));
  }

  Future<AddressDetailModel> searchAddressDetail(
      {required String placeId}) async {
    final response = await request(
        APIUrl.searchAddressDetails(placeId), Method.get,
        useIDToken: false);
    return AddressDetailModel.fromJson(response.data);
  }
}
