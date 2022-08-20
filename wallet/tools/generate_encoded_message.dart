import 'dart:developer';
import 'dart:io';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';

Future<void> main(List<String> args) async {
  final arg = args.isNotEmpty ? args[0] : 'createCookbook';

  if (arg == 'createCookbook') {
    final file = await getProjectFile("cookbook.json");
    final jsonContent = await file.readAsString();
    final sdkipcMessage = SdkIpcMessage(
        action: 'txCreateCookbook',
        json: jsonContent,
        sender: 'example',
        requestResponse: true);

    final msg = sdkipcMessage.createMessage();
    execute(msg);
  }
  if (arg == 'createRecipe') {
    final file = await getProjectFile("recipe.json");
    final jsonContent = await file.readAsString();
    final sdkipcMessage = SdkIpcMessage(
        action: 'txCreateRecipe',
        json: jsonContent,
        sender: 'example',
        requestResponse: true);
    execute(sdkipcMessage.createMessage());
  }

  if (arg == 'purchase_nft') {
    final cookbook_id = args.length > 3 ? args[1] : 'cookbook_for_test7';
    final recipe_id =
        args.length > 3 ? args[2] : 'cookbook_for_test_2021_10_22_09_13_593';

    final msg =
        "?action=purchase_nft&cookbook_id=$cookbook_id&recipe_id=$recipe_id&nft_amount=1";
    execute(msg);
  }

  if (arg == 'purchase_trade') {
    final trade_id = args.length > 2 ? args[1] : '123456';
    final msg = "?action=purchase_trade&trade_id=$trade_id";
    execute(msg);
  }
}

Future<void> execute(String msg) async {
  log("pylons://wallet/$msg");
  Process.run("adb", [
    'shell',
    'am',
    'start',
    '-W',
    '-a',
    'android.intent.action.VIEW',
    '-c',
    'android.intent.category.BROWSABLE',
    '-d',
    '"pylons://wallet/$msg"'
  ]);
}

/// Get a stable path to a test resource by scanning up to the project root.
Future<File> getProjectFile(String path) async {
  final dir = Directory.current.path;
  return File('$dir/tools/json/$path');
}
