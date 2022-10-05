import 'package:floor/floor.dart';
import 'package:pylons_wallet/model/transaction_failure_model.dart';

@dao
abstract class TxManagerDao {
  @Query('SELECT * FROM LocalTransactionModel ORDER BY dateTime DESC')
  Future<List<LocalTransactionModel>> getAllFailuresEntries();

  @insert
  Future<int> insertTransactionFailure(LocalTransactionModel txManager);

  @Query('DELETE FROM LocalTransactionModel WHERE id = :id')
  Future<void> delete(int id);
}
