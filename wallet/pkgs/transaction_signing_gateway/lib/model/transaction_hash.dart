import 'package:equatable/equatable.dart';

class TransactionHash extends Equatable {
  const TransactionHash({required this.hash});

  final String hash;

  @override
  List<Object?> get props {
    return [
      hash,
    ];
  }

  TransactionHash copyWith({
    String? hash,
  }) {
    return TransactionHash(
      hash: hash ?? this.hash,
    );
  }
}
