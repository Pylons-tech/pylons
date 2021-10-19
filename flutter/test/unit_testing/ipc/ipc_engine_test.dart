import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/ipc/ipc_engine.dart';



void main() {
  test('test encoding', () {

    var sender = "pylo1t3xupuj9f72jpxddkfs2sps4lsj8ejznd9r4jj";
    var key = "txCreateCookbook";
    var json = """{
                      "creator": "pylo1mwky96p8qzckfvus0cpcdzv9c2983az65lp37t",
                      "ID": "v1",                      
                      "name": "Legend of the Undead Dragon",
                      "description": "Cookbook for running pylons recreation of LOUD",
                      "developer": "Pylons Inc",
                      "version": "v1.0.0",
                      "supportEmail": "pylons@pylons.tech",
                      "costPerBlock": {
                      "denom": "pylo",
                      "amount": "1000"
                      },
                      "enabled": true
              }""";
    final list = <String>[sender,key,json];
    var result = IPCEngine().encodeMessage(list);

    print(result);

  });
}

