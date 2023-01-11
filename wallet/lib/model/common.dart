import 'package:equatable/equatable.dart';

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

class Address extends Equatable {
  const Address(this.id);
  final String id;

  @override
  List<Object?> get props => [id];

  @override
  String toString() => id;
}
