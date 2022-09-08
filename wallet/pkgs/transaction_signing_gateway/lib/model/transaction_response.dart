import 'package:alan/alan.dart';
import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:transaction_signing_gateway/model/transaction_hash.dart';
import 'package:transaction_signing_gateway/model/transaction_log.dart';

class TransactionResponse extends Equatable {
  const TransactionResponse({
    required this.hash,
    required this.data,
    required this.logs,
    required this.info,
    required this.codespace,
    required this.rawLog,
    required this.gasUsed,
    required this.gasWanted,
    required this.timestamp,
  });

  final TransactionHash hash;
  final String data;
  final String rawLog;
  final String codespace;
  final String info;
  final List<TransactionLog> logs;
  final Decimal gasUsed;
  final Decimal gasWanted;
  final DateTime timestamp;

  @override
  List<Object?> get props {
    return [
      hash,
      data,
      rawLog,
      codespace,
      info,
      logs,
      gasUsed,
      gasWanted,
      timestamp,
    ];
  }

  TransactionResponse copyWith({
    TransactionHash? hash,
    String? data,
    String? rawLog,
    String? codespace,
    String? info,
    List<TransactionLog>? logs,
    Decimal? gasUsed,
    Decimal? gasWanted,
    DateTime? timestamp,
  }) {
    return TransactionResponse(
      hash: hash ?? this.hash,
      data: data ?? this.data,
      rawLog: rawLog ?? this.rawLog,
      codespace: codespace ?? this.codespace,
      info: info ?? this.info,
      logs: logs ?? this.logs,
      gasUsed: gasUsed ?? this.gasUsed,
      gasWanted: gasWanted ?? this.gasWanted,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

extension TxResponseTranslator on TxResponse {
  TransactionResponse toTransactionResponse() => TransactionResponse(
        info: info,
        data: data,
        rawLog: rawLog,
        codespace: codespace,
        hash: TransactionHash(hash: txhash),
        logs: List<TransactionLog>.from(
          logs.map(
            (log) => TransactionLog(
              log: log.log,
              msgIndex: log.msgIndex,
              events: List.from(
                log.events.map(
                  (e) => e.toProto3Json(),
                ),
              ),
            ),
          ),
        ),
        gasUsed: Decimal.parse('$gasUsed'),
        gasWanted: Decimal.parse('$gasWanted'),
        timestamp: DateTime.fromMillisecondsSinceEpoch(int.tryParse(timestamp) ?? 0),
      );
}
