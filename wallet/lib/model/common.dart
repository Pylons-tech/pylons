import 'package:equatable/equatable.dart';
import 'package:fixnum/fixnum.dart';

class CookbookId extends Equatable {
  const CookbookId(this.id);
  final String id;

  @override
  List<Object?> get props => [id];

  @override
  String toString() => id;
}

class RecipeId extends Equatable {
  const RecipeId(this.id);
  final String id;

  @override
  List<Object?> get props => [id];

  @override
  String toString() => id;
}


class TradeId extends Equatable {
  const TradeId(this.id);
  final Int64 id;

  @override
  List<Object?> get props => [id];

  @override
  String toString() => id.toString();
}

class Address extends Equatable {
  const Address(this.id);
  final String id;

  @override
  List<Object?> get props => [id];

  @override
  String toString() => id;
}
