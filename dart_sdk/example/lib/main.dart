import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pylons_sdk/pylons_sdk.dart';
import 'package:fixnum/fixnum.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  PylonsWallet.setup(mode: PylonsMode.prod, host: 'example');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    PylonsWallet.instance.exists().then((value) {
      log('WALLET Existence $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String cookBookId = "cookbook_cry_305";
  String recipeId = "recipe_1";
  String ownerId = "pylo1v97v5qj2kvph2d02fzxxlh44wzpfmuc63vpphj";
  String itemId = "8MrbcX2hkmm";
  String executionId = "exec1213";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {
                goToInstall();
              },
              child: const Text('Go to install Pylons'),
            ),
            ElevatedButton(
              onPressed: () async {
                goToLogin();
              },
              child: const Text('Go to log in Pylons'),
            ),
            ElevatedButton(
              onPressed: () async {
                createCookBook();
              },
              child: const Text('Cookbook'),
            ),
            ElevatedButton(
              onPressed: () async {
                updateCookBook();
              },
              child: const Text('Update Cookbook'),
            ),
            ElevatedButton(
              onPressed: () async {
                getCookbook();
              },
              child: const Text('Get Cookbook'),
            ),
            ElevatedButton(
              onPressed: () async {
                createRecipe();
              },
              child: const Text('Recipe'),
            ),
            ElevatedButton(
              onPressed: () async {
                executeRecipe();
              },
              child: const Text('Execute Recipe'),
            ),
            ElevatedButton(
              onPressed: () async {
                updateRecipe();
              },
              child: const Text('Update Recipe'),
            ),
            ElevatedButton(
              onPressed: () async {
                getProfile();
              },
              child: const Text('Get Profile'),
            ),
            ElevatedButton(
              onPressed: () async {
                getRecipes();
              },
              child: const Text('Get All recipes'),
            ),
            ElevatedButton(
              onPressed: () async {
                getRecipe();
              },
              child: const Text('Get recipe'),
            ),
            ElevatedButton(
              onPressed: () async {
                getExecutionListByRecipe();
              },
              child: const Text('Get execution list by recipe'),
            ),
            ElevatedButton(
              onPressed: () async {
                getItemListByOwner();
              },
              child: const Text('Get Items list by owner'),
            ),
            ElevatedButton(
              onPressed: () async {
                getItemById();
              },
              child: const Text('Get Item By Id'),
            ),
            ElevatedButton(
              onPressed: () async {
                getExecutionById();
              },
              child: const Text('Get Execution By Id'),
            ),
            ElevatedButton(
              onPressed: () async {
                getTrades();
              },
              child: const Text('Get Trades'),
            ),
            ElevatedButton(
              onPressed: () async {
                placeForSale();
              },
              child: const Text('Place for sale'),
            ),
            ElevatedButton(
              onPressed: () async {
                showStripe();
              },
              child: const Text('Show Stripe'),
            ),
          ],
        ),
      ),
    );
  }

  void createCookBook() async {
    var cookBook1 = Cookbook(
        creator: "pylo1v97v5qj2kvph2d02fzxxlh44wzpfmuc63vpphj",
        id: cookBookId,
        name: "Cry Cookbook for Test",
        description: "Cookbook for running pylons recreation of LOUD",
        developer: "Pylons Inc",
        version: "v0.0.1",
        supportEmail: "corey.williams@pylons.tech",
        enabled: true);

    var response = await PylonsWallet.instance.txCreateCookbook(cookBook1);

    log('From App $response', name: 'pylons_sdk');

    if (response.success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Cookbook created")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cookbook error : ${response.error}")));
    }
  }

  void createRecipe() async {
    var recipe = Recipe(
        cookbookId: cookBookId,
        id: recipeId,
        nodeVersion: Int64(1),
        name: "LOUD's Wooden sword lv1 buy recipe",
        description: "this recipe is used to buy wooden sword lv1.",
        version: "v0.1.3",
        coinInputs: [],
        itemInputs: [],
        costPerBlock: Coin(denom: "upylon", amount: "1000000"),
        entries: EntriesList(coinOutputs: [], itemOutputs: [
          ItemOutput(
            id: "copper_sword_lv1",
            doubles: [],
            longs: [],
            strings: [],
            mutableStrings: [],
            transferFee: [],
            tradePercentage: DecString.decStringFromDouble(0.1),
            tradeable: true,
          ),
        ], itemModifyOutputs: []),
        outputs: [
          WeightedOutputs(entryIds: ["copper_sword_lv1"], weight: Int64(1))
        ],
        blockInterval: Int64(0),
        enabled: false,
        extraInfo: "extraInfo");

    var response = await PylonsWallet.instance.txCreateRecipe(recipe);

    log('From App $response', name: 'pylons_sdk');

    if (response.success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Recipe created")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Recipe error : ${response.error}")));
    }
  }

  void executeRecipe() async {
    var response = await PylonsWallet.instance.txExecuteRecipe(
        cookbookId: cookBookId,
        recipeName: recipeId,
        coinInputIndex: 0,
        itemIds: [],
        paymentInfo: []);

    log('From App $response', name: 'pylons_sdk');

    if (response.success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Recipe  executed")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Recipe  error : ${response.error}")));
    }
  }

  void updateRecipe() async {
    var recipe = Recipe(
        cookbookId: cookBookId,
        id: recipeId,
        nodeVersion: Int64(2),
        name: "LOUD's Wooden sword lv1 buy recipe",
        description: "this recipe is used to buy wooden sword lv1.",
        version: "v1.0.5",
        coinInputs: [],
        itemInputs: [],
        costPerBlock: Coin(denom: "upylon", amount: "1000000"),
        entries: EntriesList(coinOutputs: [], itemOutputs: [
          ItemOutput(
            id: "copper_sword_lv1",
            doubles: [],
            longs: [],
            strings: [],
            mutableStrings: [],
            transferFee: [],
            tradePercentage: DecString.decStringFromDouble(0.2),
            tradeable: true,
          ),
        ], itemModifyOutputs: []),
        outputs: [
          WeightedOutputs(entryIds: ["copper_sword_lv1"], weight: Int64(1))
        ],
        blockInterval: Int64(0),
        enabled: true,
        extraInfo: "extraInfo");

    var response = await PylonsWallet.instance.txUpdateRecipe(recipe);

    log('From App $response', name: 'pylons_sdk');

    if (response.success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Recipe updated")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Recipe update error : ${response.error}")));
    }
  }

  void updateCookBook() async {
    var cookBook1 = Cookbook(
        creator: "",
        id: cookBookId,
        name: "Legend of the Undead Dianasour",
        description: "Cookbook for running pylons recreation of LOUD",
        developer: "Pylons Inc",
        version: "v0.0.2",
        supportEmail: "alex@shmeeload.xyz",
        enabled: true);

    var response = await PylonsWallet.instance.txUpdateCookbook(cookBook1);

    log('From App $response', name: 'pylons_sdk');

    if (response.success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Cookbook updated")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cookbook update error: ${response.error}")));
    }
  }

  void getProfile() async {
    var sdkResponse = await PylonsWallet.instance.getProfile();

    log(sdkResponse.toString(), name: 'pylons_sdk');
  }

  Future getRecipes() async {
    var sdkResponse = await PylonsWallet.instance.getRecipes(cookBookId);
    log(sdkResponse.toString(), name: 'pylons_sdk');
  }

  void getCookbook() async {
    var sdkResponse = await PylonsWallet.instance.getCookbook(cookBookId);
    log(sdkResponse.toString(), name: 'pylons_sdk');
  }

  void getRecipe() async {
    var sdkResponse =
        await PylonsWallet.instance.getRecipe(cookBookId, recipeId);
    log(sdkResponse.toString(), name: 'pylons_sdk');
  }

  void getExecutionListByRecipe() async {
    var sdkResponse = await PylonsWallet.instance
        .getExecutionBasedOnRecipe(cookbookId: cookBookId, recipeId: recipeId);
    log(sdkResponse.toString(), name: 'pylons_sdk');
  }

  void getItemListByOwner() async {
    var sdkResponse =
        await PylonsWallet.instance.getItemListByOwner(owner: ownerId);
    log(sdkResponse.toString(), name: 'pylons_sdk');
  }

  void getItemById() async {
    var sdkResponse = await PylonsWallet.instance
        .getItemById(cookbookId: cookBookId, itemId: itemId);
    log(sdkResponse.toString(), name: 'pylons_sdk');
  }

  void getExecutionById() async {
    var sdkResponse =
        await PylonsWallet.instance.getExecutionBasedOnId(id: executionId);
    log(sdkResponse.toString(), name: 'pylons_sdk');
  }

  Future getTrades() async {
    var sdkResponse = await PylonsWallet.instance.getTrades(ownerId);
    log(sdkResponse.toString(), name: 'pylons_sdk');
  }

  void placeForSale() async {
    var item = ItemRef(
      cookbookId: cookBookId,
      itemId: itemId,
    );
    var sdkResponse = await PylonsWallet.instance.txPlaceForSale(item, 100);
    log(sdkResponse.toString(), name: 'pylons_sdk');
  }

  void goToInstall() async {
    final isAlreadyInstalled = await PylonsWallet.instance.exists();
    if (isAlreadyInstalled) {
      log("Pylons Wallet already installed.", name: 'pylons_sdk');
    } else {
      PylonsWallet.instance.goToInstall();
    }
  }

  void goToLogin() async {
    PylonsWallet.instance.goToPylons();
  }

  void showStripe() {
    PylonsWallet.instance.showStripe();
  }
}
