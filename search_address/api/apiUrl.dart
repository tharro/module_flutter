
  /// Address
  static String searchAddress(String input) =>
      '${baseUrl}general/get-list-address/?address=$input';
  static String searchAddressDetails(String placeId) =>
      '${baseUrl}general/get-detail-address/?place_id=$placeId';