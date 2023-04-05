part of 'search_address_bloc.dart';

class SearchAddressState extends Equatable {
  final bool? searchAddressLoading;
  final String? errorSearchAddress;
  final bool? getAddressDetailsLoading;

  const SearchAddressState(
      {this.searchAddressLoading,
      this.errorSearchAddress,
      this.getAddressDetailsLoading});

  factory SearchAddressState.empty() {
    return const SearchAddressState(
      searchAddressLoading: false,
      getAddressDetailsLoading: false,
      errorSearchAddress: '',
    );
  }

  SearchAddressState copyWith(
      {bool? searchAddressLoading,
      getAddressDetailsLoading,
      String? errorSearchAddress}) {
    return SearchAddressState(
      searchAddressLoading: searchAddressLoading ?? this.searchAddressLoading,
      getAddressDetailsLoading:
          getAddressDetailsLoading ?? this.getAddressDetailsLoading,
      errorSearchAddress: errorSearchAddress ?? this.errorSearchAddress,
    );
  }

  @override
  List<Object?> get props =>
      [searchAddressLoading, errorSearchAddress, getAddressDetailsLoading];
}
