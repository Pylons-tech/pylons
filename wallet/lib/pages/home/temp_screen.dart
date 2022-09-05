import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TempScreen extends StatelessWidget {
  const TempScreen({Key? key}) : super(key: key);

  Future<String> autoGenerateCookbookId() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String cookbookId = "Easel_CookBook_auto_cookbook_${getFullDateTime()}";

    await sharedPreferences.setString(kCookbookId, cookbookId);

    return cookbookId;
  }

  Future<String> autoGenerateEaselId() async {
    final String easelId = "Easel_Recipe_auto_recipe_${getFullDateTime()}";

    return easelId;
  }

  String getFullDateTime() {
    return DateFormat('yyyy_MM_dd_HHmmss_SSS').format(DateTime.now());
  }

  Future<String> createMyCookbook() async {
    final cookbookId = await autoGenerateCookbookId();
    const cookbookName = "Easel Cookbook";
    const cookbookDesc = "Cookbook for Easel NFT";
    const kVersionCookbook = "v0.0.1";
    const supportedEmail = "support@pylons.tech";

    final cookBook1 = Cookbook(
      creator: "",
      id: cookbookId,
      name: cookbookName,
      description: cookbookDesc,
      developer: "NewDEV",
      version: kVersionCookbook,
      supportEmail: supportedEmail,
      enabled: true,
    );

    final walletStore = GetIt.I.get<WalletsStore>();

    final cookBookMap = cookBook1.toProto3Json()! as Map;

    final resp = await walletStore.createCookbook(cookBookMap);

    if (!resp.success) {
      log("Error while creating cookbook: ${resp.error}");
      return '';
    }

    return cookbookId;
  }

  // The first set of recipes is creating the ticket itself. There needs to be one for each ticket level
  // {inputs: price, outputs; {event_name: event, ticket_level: regular or VIP or whatever}
  // So for each ticket level there's a recipe, and the output has the same ticket name but a different level
  // Then for each sub-event you can attend you have a recipe like
  // {input_item: {event_name: event, ticket_level:[the set of ticket levels that are eligible], entry_stamp_sub_event: none}, modify_item: {entry_stamp_sub_event: code shown at door}}
  // And for each voucher you generate it's {event_name: event, ticket_level:, voucher_type_count}, modify: incrmement voucher count, output: voucher_type}
  // Does that make sense?

  Future<bool> createMyRecipeForSubEvents({required String cookbookId, required Item inputItem}) async {
    final loading = Loading()..showLoading();

    final stringsInputs = inputItem.strings.map((e) => StringInputParam(key: e.key, value: e.value));
    log("stringsInputs: $stringsInputs");
    final recipeId = await autoGenerateEaselId();
    const ticketName = "Fare-well Party";
    const ticketDesc = "This party is getting hot.";

    final recipe = Recipe(
        cookbookId: cookbookId,
        id: recipeId,
        nodeVersion: Int64(1),
        name: ticketName,
        description: ticketDesc,
        version: "v0.2.0",
        coinInputs: [CoinInput()],
        itemInputs: [
          ItemInput(
            id: "Regular",
            doubles: [],
            longs: [],
            strings: stringsInputs,
          ),
        ],
        costPerBlock: Coin(denom: kUpylon, amount: '0'),
        entries: EntriesList(coinOutputs: [], itemOutputs: [], itemModifyOutputs: []),
        outputs: [],
        blockInterval: Int64(),
        enabled: true,
        extraInfo: kExtraInfo);

    log("json: ${recipe.toProto3Json()}");

    final walletStore = GetIt.I.get<WalletsStore>();

    final recipeMap = recipe.toProto3Json()! as Map;

    recipeMap.remove('nodeVersion');

    final response = await walletStore.createRecipe(recipeMap);

    if (!response.success) {
      loading.dismiss();
      log("failed: ${response.error}");
      return false;
    }

    final jsonExecuteRecipe = {"creator": "newCreator", "cookbookId": cookbookId, "recipeId": recipeId, "coinInputsIndex": 0};

    log("jsonExecuteRecipe: $jsonExecuteRecipe");

    loading.dismiss();

    return true;
  }

  Future<bool> createMyRecipeForTicket() async {
    final loading = Loading()..showLoading();

    final cookbookId = await createMyCookbook();
    final recipeId = await autoGenerateEaselId();
    const ticketName = "Fare-well Party";
    const ticketDesc = "This party is getting hot.";
    const allowedGuests = 10;

    final recipe = Recipe(
        cookbookId: cookbookId,
        id: recipeId,
        nodeVersion: Int64(1),
        name: ticketName,
        description: ticketDesc,
        version: "v0.2.0",
        coinInputs: [CoinInput()],
        itemInputs: [],
        costPerBlock: Coin(denom: kUpylon, amount: '0'),
        entries: EntriesList(coinOutputs: [], itemOutputs: [
          ItemOutput(
            id: "Regular",
            doubles: [],
            longs: [],
            strings: [
              StringParam(key: "name", value: ticketName),
              StringParam(key: "ticket_level", value: "Regular"),
            ],
            mutableStrings: [],
            transferFee: [Coin(denom: kUpylon, amount: '1')],
            tradePercentage: '0',
            tradeable: true,
            amountMinted: Int64(),
            quantity: Int64(allowedGuests),
          ),
          ItemOutput(
            id: "VIP",
            doubles: [],
            longs: [],
            strings: [
              StringParam(key: "name", value: ticketName),
              StringParam(key: "ticket_level", value: "VIP"),
            ],
            mutableStrings: [],
            transferFee: [Coin(denom: kUpylon, amount: '1')],
            tradePercentage: '0',
            tradeable: true,
            amountMinted: Int64(),
            quantity: Int64(allowedGuests),
          ),
        ], itemModifyOutputs: []),
        outputs: [
          WeightedOutputs(entryIds: ["Regular", "VIP"], weight: Int64(1))
        ],
        blockInterval: Int64(),
        enabled: true,
        extraInfo: kExtraInfo);

    final walletStore = GetIt.I.get<WalletsStore>();
    final recipeMap = recipe.toProto3Json()! as Map;
    recipeMap.remove('nodeVersion');

    final response = await walletStore.createRecipe(recipeMap);

    if (!response.success) {
      loading.dismiss();
      log("failed: ${response.error}");
      return false;
    }

    final jsonExecuteRecipe = {"creator": "newCreator", "cookbookId": cookbookId, "recipeId": recipeId, "coinInputsIndex": 0};

    //TODO: PRINTING IT TO COPY AND PASTE WHEN YOU LOGIN FROM DIFFERENT WALLET TO EXECUTE RECIPE
    log("jsonExecuteRecipe: $jsonExecuteRecipe");

    loading.dismiss();

    return true;
  }

  Future<bool> executeMyRecipe() async {
    final loading = Loading()..showLoading();
    final walletStore = GetIt.I.get<WalletsStore>();

    //TODO: PASTE THE COOKBOOK AND RECIPE ID OF THE CREATED RECIPE HERE

    const cookBookId = "Easel_CookBook_auto_cookbook_2022_09_05_143014_526";
    const recipeId = "Easel_Recipe_auto_recipe_2022_09_05_143022_179";
    const creator = "newCreator";

    final jsonExecuteRecipe = {
      "creator": creator,
      "cookbookId": cookBookId,
      "recipeId": recipeId,
      "coinInputsIndex": "0",
    };

    log("jsonExecuteRecipe: $jsonExecuteRecipe");
    final extRecipe = await walletStore.executeRecipe(jsonExecuteRecipe);

    if (!extRecipe.success) {
      log("extRecipe Error: ${extRecipe.error}");
      loading.dismiss();

      return false;
    }

    final items = await walletStore.getItemsByOwner(walletStore.getWallets().value.last.publicAddress);

    loading.dismiss();
    return createMyRecipeForSubEvents(cookbookId: cookBookId, inputItem: items.first);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(kDarkRed)),
              onPressed: () => createMyRecipeForTicket(),
              child: const Text(" Create Recipe Please! "),
            ),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(kDarkRed)),
              onPressed: () => executeMyRecipe(),
              child: const Text("Execute Recipe Please!"),
            ),
          ],
        ),
      ),
    );
  }
}
