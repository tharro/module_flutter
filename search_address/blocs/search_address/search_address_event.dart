part of 'search_address_bloc.dart';

@immutable
abstract class SearchAddressEvent extends Equatable {
  const SearchAddressEvent();

  @override
  List<Object> get props => [];
}

class SearchAddressOSM extends SearchAddressEvent {
  final String address;
  final Function(List<Prediction>) onSuccess;
  const SearchAddressOSM({required this.address, required this.onSuccess});
}

class GetAddressOSMDetails extends SearchAddressEvent {
  final Prediction prediction;
  final Function(Address) onSuccess;
  const GetAddressOSMDetails(
      {required this.prediction, required this.onSuccess});
}
