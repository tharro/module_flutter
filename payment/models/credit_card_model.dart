import 'package:equatable/equatable.dart';

class ListCreditCardModel extends Equatable {
  final int? count;
  final String? next;
  final String? previous;
  final List<CreditCardModel>? results;

  const ListCreditCardModel(
      {this.count, this.next, this.previous, this.results});
  factory ListCreditCardModel.fromJson(Map<String, dynamic> json) {
    return ListCreditCardModel(
        count: json['count'],
        next: json['next'],
        previous: json['previous'],
        results: (json['results'] as List)
            .map((e) => CreditCardModel.fromJson(e))
            .toList());
  }

  ListCreditCardModel copyWith(
      {int? count,
      String? next,
      String? previous,
      List<CreditCardModel>? results}) {
    return ListCreditCardModel(
      count: count ?? this.count,
      next: next ?? this.next,
      previous: previous ?? this.previous,
      results: results ?? this.results,
    );
  }

  @override
  List<Object?> get props => [count, next, previous, results];
}

class CreditCardModel extends Equatable {
  final String? number;
  final String? holderName;

  CreditCardModel({this.number, this.holderName});

  factory CreditCardModel.fromJson(dynamic json) =>
      CreditCardModel(holderName: json['holder_name'], number: json['number']);

  @override
  List<Object?> get props => [number, holderName];
}
