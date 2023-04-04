part of 'search_address_bloc.dart';

class SearchAddressState extends Equatable {
  final bool? searchAddressLoading;
  final bool? getAddressDetailsLoading;

  const SearchAddressState(
      {this.searchAddressLoading, this.getAddressDetailsLoading});

  factory SearchAddressState.empty() {
    return const SearchAddressState(
      searchAddressLoading: false,
      getAddressDetailsLoading: false,
    );
  }

  SearchAddressState copyWith(
      {bool? searchAddressLoading, getAddressDetailsLoading}) {
    return SearchAddressState(
      searchAddressLoading: searchAddressLoading ?? this.searchAddressLoading,
      getAddressDetailsLoading:
          getAddressDetailsLoading ?? this.getAddressDetailsLoading,
    );
  }

  @override
  List<Object?> get props => [searchAddressLoading, getAddressDetailsLoading];
}
