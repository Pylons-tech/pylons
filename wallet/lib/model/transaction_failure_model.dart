import 'dart:core';
import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:pylons_wallet/utils/enums.dart';

@entity
class LocalTransactionModel extends Equatable {
  @primaryKey
  final int? id;
  final String transactionCurrency;
  final String transactionPrice;
  final String transactionType;
  final String transactionData;
  final String transactionDescription;
  final String status;
  final int dateTime;

  const LocalTransactionModel({
    this.id,
    required this.transactionCurrency,
    required this.transactionPrice,
    required this.transactionType,
    required this.transactionData,
    required this.transactionDescription,
    required this.dateTime,
    required this.status,
  });

  factory LocalTransactionModel.fromStatus({required TransactionStatus status, required LocalTransactionModel transactionModel}) {
    return LocalTransactionModel(
      transactionCurrency: transactionModel.transactionCurrency,
      transactionPrice: transactionModel.transactionPrice,
      transactionType: transactionModel.transactionType,
      transactionData: transactionModel.transactionData,
      transactionDescription: transactionModel.transactionDescription,
      dateTime: transactionModel.dateTime,
      status: status.name,
    );
  }

  @override
  List<Object?> get props => [
        transactionType,
        transactionData,
        transactionDescription,
        dateTime,
        status,
      ];

  @override
  String toString() {
    return 'TransactionManager{id: $id, transactionType: $transactionType, transactionData: $transactionData, transactionDescription: $transactionDescription, status: $status, dateTime: $dateTime}';
  }
}
