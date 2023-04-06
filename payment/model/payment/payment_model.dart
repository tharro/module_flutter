import 'package:plugin_helper/index.dart';

CardType convertCardType(String brand) {
  if (brand == 'visa') {
    return CardType.visa;
  }
  if (brand == 'mastercard') {
    return CardType.mastercard;
  }
  if (brand == 'american_express') {
    return CardType.americanExpress;
  }
  if (brand == 'discover') {
    return CardType.discover;
  }
  return CardType.otherBrand;
}

class PaymentModel extends Equatable {
  const PaymentModel({
    this.id,
    this.name,
    this.brand,
    this.expMonth,
    this.expYear,
    this.last4,
    this.isDefault,
  });

  final String? id;
  final String? name;
  final CardType? brand;
  final int? expMonth;
  final int? expYear;
  final String? last4;
  final bool? isDefault;

  PaymentModel copyWith({
    String? id,
    String? name,
    CardType? brand,
    int? expMonth,
    int? expYear,
    String? last4,
    String? first4,
    bool? isDefault,
  }) =>
      PaymentModel(
        id: id ?? this.id,
        name: name ?? this.name,
        brand: brand ?? this.brand,
        expMonth: expMonth ?? this.expMonth,
        expYear: expYear ?? this.expYear,
        last4: last4 ?? this.last4,
        isDefault: isDefault ?? this.isDefault,
      );

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        id: json["id"],
        name: json["name"],
        brand: convertCardType(json["brand"]),
        expMonth: json["exp_month"],
        expYear: json["exp_year"],
        last4: json["last4"],
        isDefault: json["is_default"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "brand": brand,
        "exp_month": expMonth,
        "exp_year": expYear,
        "last4": last4,
        "is_default": isDefault,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        brand,
        expMonth,
        expYear,
        last4,
        isDefault,
      ];
}
