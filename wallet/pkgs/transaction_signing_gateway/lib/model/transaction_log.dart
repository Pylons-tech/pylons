import 'package:equatable/equatable.dart';

class TransactionLog extends Equatable {
  const TransactionLog({
    required this.msgIndex,
    required this.log,
    this.events = const [],
  });

  final int msgIndex;
  final String log;
  final List<Object?> events;

  @override
  List<Object?> get props => [
        msgIndex,
        log,
        events,
      ];

  TransactionLog copyWith({
    int? msgIndex,
    String? log,
    List<Object?>? events,
  }) {
    return TransactionLog(
      msgIndex: msgIndex ?? this.msgIndex,
      log: log ?? this.log,
      events: events ?? this.events,
    );
  }
}
