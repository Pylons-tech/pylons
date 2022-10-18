import 'package:flutter/material.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

import 'config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static Config? _config;

  static int _getNumFilters () {
    if (_config == null) {
      return 0;
    } else {
      return _config!.doubleFilters.length + _config!.longFilters.length + _config!.stringFilters.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          children: [
            //InventoryPane(items: [
            //   Item.create()..id = "item1"..cookbookId = "cb1"..recipeId = "rcp1",
            //   Item.create()..id = "item1"..cookbookId = "cb1"..recipeId = "rcp1",
            //   Item.create()..id = "item1"..cookbookId = "cb1"..recipeId = "rcp1",
            //   Item.create()..id = "item1"..cookbookId = "cb1"..recipeId = "rcp1",
            //   Item.create()..id = "item1"..cookbookId = "cb1"..recipeId = "rcp1",
            // ]),
            // RecipeInputPane(recipe: Recipe.create(), items: const []),
            // RecipeOutputPane(recipe: Recipe.create(), items: const []),
            // RecipeSelectPane(recipes: const [])
          ],
        )
      )
    );
  }
}

class ItemDetailPane extends StatelessWidget {
  final Item item;

  const ItemDetailPane({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class InventoryItemPane extends StatelessWidget {
  final Item item;

  const InventoryItemPane({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text(item.id, style: const TextStyle(color: Colors.white),),
          // Text("${item.cookbookId}:${item.recipeId}", style: const TextStyle(color: Colors.white))
        ]
      ),
    );
  }
}

class InventoryPane extends StatelessWidget {
  final List<Item> items;
  const InventoryPane({required this.items, Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    var numTabs = _MyHomePageState._getNumFilters();
    final anyFilters = numTabs != 0;
    if (!anyFilters) numTabs = 1; // there has to be at least one tab, even if it's a placeholder

    final List<Widget> tabs = [];

    // generate tabs

    if (anyFilters) {
      _MyHomePageState._config?.doubleFilters.forEach((key, value) {
        tabs.add(Tab(text: "$key:$value"));
      });
      _MyHomePageState._config?.longFilters.forEach((key, value) {
        tabs.add(Tab(text: "$key:$value"));
      });
      _MyHomePageState._config?.stringFilters.forEach((key, value) {
        tabs.add(Tab(text: "$key:$value"));
      });
    } else {
      tabs.add(
        const Tab(text: "Items")
      );
    }
    
    final List<Widget> itemPanes = [];
    
    for (var element in items) {
      itemPanes.add(InventoryItemPane(item: element));
    }

    return DefaultTabController(length: numTabs, child: Scaffold(
      appBar: TabBar(
        indicatorColor: Colors.orange,
        tabs: tabs,
      ),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
        children: itemPanes,
      ),
    ));
  }

}

class RecipeInputPane extends StatelessWidget {
  final Recipe? recipe;
  final List<Item> items;
  const RecipeInputPane({required this.recipe, required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}

class RecipeOutputPane extends StatelessWidget {
  final Recipe? recipe;
  final List<Item> items;
  const RecipeOutputPane({required this.recipe, required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}

class RecipeSelectPane extends StatelessWidget {
  final List<Recipe> recipes;
  const RecipeSelectPane({required this.recipes, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}

class RecipeSelectRecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeSelectRecipeCard({required this.recipe, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}