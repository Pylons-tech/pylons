import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/generated/Pylonstech.pylons.pylons/module/client/pylons/tx.pbgrpc.dart';


var MOCK_COOKBOOK = '''{
  "creator": "pylo1akzpu26f36pgxr636uch8evdtdjepu93v5y9s2",
  "ID": "cookbookLOUD",
  "name": "Legend of the Undead Dragon",
  "nodeVersion": "v0.1.3",
  "description": "Cookbook for running pylons recreation of LOUD",
  "developer": "Pylons Inc",
  "version": "v0.0.1",
  "supportEmail": "alex@shmeeload.xyz",
  "costPerBlock": {"denom":  "upylon", "amount":  "1000000"},
  "enabled": true
}''';





void main(){


  test('test cookbook making', (){
    MsgClient().createCookbook(request);
    var mockCookBook = MsgCreateCookbookResponse.fromJson(MOCK_COOKBOOK);


  });




}