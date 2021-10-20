import 'dart:convert';

void main(){



  const objectToEncode = """
  {
  "creator": "",
  "ID": "cookbookLOUD",
  "name": "Legend of the Undead Dragon",
  "nodeVersion": "v0.1.3",
  "description": "Cookbook for running pylons recreation of LOUD",
  "developer": "Pylons Inc",
  "version": "v0.0.1",
  "supportEmail": "alex@shmeeload.xyz",
  "costPerBlock": {"denom":  "upylon", "amount":  "1000000"},
  "enabled": true
}
""";



  var list = [
    'example', /// Your app name
    'txCreateCookbook' , /// Transaction name check [HandlerFactory]
    objectToEncode    /// Transaction params

  ];


  final encodedMessageWithComma = list.map((e) => base64Url.encode(utf8.encode(e))).join(',');
  print(base64Url.encode(utf8.encode(encodedMessageWithComma)));



}