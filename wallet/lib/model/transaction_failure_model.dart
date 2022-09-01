import 'dart:core';
import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@entity
class TransactionManager extends Equatable {
  @primaryKey
  final int? id;
  final String transactionType;
  final String transactionErrorCode;
  final String transactionData;
  final String transactionDescription;
  final int dateTime;

  const TransactionManager({
    this.id,
    required this.transactionType,
    required this.transactionErrorCode,
    required this.transactionData,
    required this.transactionDescription,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [
    transactionType,
    transactionErrorCode,
    transactionData,
    transactionDescription,
    dateTime,
  ];

  @override
  String toString() {
    return 'TransactionManager{id: $id, transactionType: $transactionType, transactionErrorCode: $transactionErrorCode, transactionData: $transactionData, transactionDescription: $transactionDescription, dateTime: $dateTime}';
  }
}
