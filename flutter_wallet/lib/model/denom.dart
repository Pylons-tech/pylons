import 'package:equatable/equatable.dart';

class Denom extends Equatable {
  const Denom(
      this.text,
      );

  final String text;

  @override
  List<Object> get props => [
    text,
  ];

  @override
  String toString() => text;
}
