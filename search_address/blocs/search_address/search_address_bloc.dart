import 'package:plugin_helper/index.dart';

import '../../index.dart';
import '../../models/address/address_detail_model.dart';
import '../../models/address/address_model.dart';
import '../../repositories/address/address_repository.dart';

part 'search_address_event.dart';
part 'search_address_state.dart';

class SearchAddressBloc extends Bloc<SearchAddressEvent, SearchAddressState> {
  AddressRepository addressRepository = AddressRepository();
  SearchAddressBloc() : super(SearchAddressState.empty()) {
    on<SearchAddressOSM>(_searchAddressOSM);
    on<GetAddressOSMDetails>(_getAddressOSMDetails);
  }

  _searchAddressOSM(
      SearchAddressOSM event, Emitter<SearchAddressState> emit) async {
    try {
      emit(state.copyWith(searchAddressLoading: true));
      List<Prediction> addresses =
          await addressRepository.searchAddress(address: event.address);
      event.onSuccess(addresses);
    } catch (e) {
      emit(state.copyWith(errorSearchAddress: e.parseError.message));
    } finally {
      emit(state.copyWith(searchAddressLoading: false));
    }
  }

  _getAddressOSMDetails(
      GetAddressOSMDetails event, Emitter<SearchAddressState> emit) async {
    try {
      emit(state.copyWith(getAddressDetailsLoading: true));
      AddressDetailModel address = await addressRepository.searchAddressDetail(
          placeId: event.prediction.placeId!);
      event.onSuccess(address.mapToAddress(event.prediction));
    } catch (e) {
      Helper.showToastBottom(message: e.parseError.message);
    } finally {
      emit(state.copyWith(getAddressDetailsLoading: false));
    }
  }
}
