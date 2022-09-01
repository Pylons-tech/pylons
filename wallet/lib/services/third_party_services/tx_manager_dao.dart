import 'package:floor/floor.dart';
import 'package:pylons_wallet/model/transaction_failure_model.dart';

@dao
abstract class TxManagerDao {
  @Query('SELECT * FROM TransactionManager ORDER BY dateTime DESC')
  Future<List<TransactionManager>> getAllFailuresEntries();

  @insert
  Future<int> insertTransactionFailure(TransactionManager txManager);

  @Query('DELETE FROM TransactionManager WHERE id = :id')
  Future<void> delete(int id);
}
