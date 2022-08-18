import 'package:equatable/equatable.dart';

class ItemCreditCardModel extends Equatable {
  final String? number;
  final String? holderName;

  const ItemCreditCardModel({this.number, this.holderName});

  factory ItemCreditCardModel.fromJson(dynamic json) => ItemCreditCardModel(
      holderName: json['holder_name'], number: json['number']);

  @override
  List<Object?> get props => [number, holderName];
}
