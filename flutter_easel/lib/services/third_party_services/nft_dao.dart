import 'package:easel_flutter/models/nft.dart';
import 'package:floor/floor.dart';

@dao
abstract class NftDao {
  @Query('SELECT * FROM nft ORDER BY dateTime DESC')
  Future<List<NFT>> findAllNft();

  @Query('SELECT * FROM nft WHERE id = :id')
  Future<NFT?> findNftById(int id);

  @insert
  Future<int> insertNft(NFT nft);

  @Query('DELETE FROM nft WHERE id = :id')
  Future<void> delete(int id);

  @Query(
      'UPDATE nft SET name = :nftName, description= :nftDescription, creator = :creatorName, step = :step,hashtags = :hashtags, dateTime = :dateTime WHERE id = :id')
  Future<void> updateNFTFromDescription(
      int id,
      String nftName,
      String nftDescription,
      String creatorName,
      String step,
      String hashtags,
      int dateTime);

  @Query('UPDATE nft SET isDialogShown = true WHERE id = :id')
  Future<void> updateNFTDialogShown(int id);

  @Query(
      'UPDATE nft SET tradePercentage = :tradePercentage, price= :price, quantity = :quantity, denom =:denom, step = :step, isFreeDrop = :isFreeDrop, dateTime = :dateTime WHERE id = :id')
  Future<void> updateNFTFromPrice(
      int id,
      String tradePercentage,
      String price,
      String quantity,
      String step,
      String denom,
      bool isFreeDrop,
      int dateTime);
}
