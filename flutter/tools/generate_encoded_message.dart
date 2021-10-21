import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  const createCookbook = false;
  const createRecipe = true;

  if (createCookbook) {
    final file = File("json/cookbook.json");
    final jsonContent = await file.readAsString();
    final msg = encodeMessage(["pylo1np6w3qwugamt8yzqyns5wr5e500239sf7gw6l5", "txCreateCookbook", jsonContent]);
    execute(msg);
  }
  if (createRecipe) {
    final file = File("json/recipe.json");
    final jsonContent = await file.readAsString();
    final msg = encodeMessage(["pylo1np6w3qwugamt8yzqyns5wr5e500239sf7gw6l5", "txCreateRecipe", jsonContent]);
    execute(msg);
  }
}
Future<void> execute(msg) async {
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
    'pylons://wallet/$msg']);
}

String encodeMessage(List<String> msg) {
  final encodedMessageWithComma = msg.map((e) => base64Url.encode(utf8.encode(e))).join(',');
  return base64Url.encode(utf8.encode(encodedMessageWithComma));
}