import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_signing_gateway/model/account_public_info.dart';
import 'package:transaction_signing_gateway/model/account_public_info_serializer.dart';

void main() {
  late AccountPublicInfo publicInfo;

  setUp(() {
    publicInfo = const AccountPublicInfo(
      name: 'a name',
      publicAddress: 'cosmos1wze8mn5nsgl9qrgazc6f92fve7m5e6psjcx2du',
      accountId: 'fc74d409-3945-4f53-ba76-a03b3cee7865',
      chainId: 'cosmoshub',
      additionalData: 'additional data',
    );
  });

  test('serializes account info', () async {
    final map = AccountPublicInfoSerializer.toMap(publicInfo);
    final info = AccountPublicInfoSerializer.fromMap(map);
    expect(map['name'], publicInfo.name);
    expect(map['chain_id'], publicInfo.chainId);
    expect(map['public_address'], publicInfo.publicAddress);
    expect(map['account_Id'], publicInfo.accountId);
    expect(map['additional_data'], publicInfo.additionalData);
    expect(info, publicInfo);
  });

  test('serializes account info', () async {
    final infoWithoutAdditionalData = AccountPublicInfo(
      name: publicInfo.name,
      publicAddress: publicInfo.publicAddress,
      accountId: publicInfo.accountId,
      chainId: publicInfo.chainId,
    );
    final map = AccountPublicInfoSerializer.toMap(infoWithoutAdditionalData);
    final info = AccountPublicInfoSerializer.fromMap(map);
    expect(map['additional_data'], null);
    expect(info.additionalData, null);
  });
}
