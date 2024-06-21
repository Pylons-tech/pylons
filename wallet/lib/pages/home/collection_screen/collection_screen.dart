import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/gen/assets.gen.dart';
import 'package:pylons_wallet/model/event.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/home/collection_screen/collection_view_model.dart';
import 'package:pylons_wallet/pages/home/collection_screen/widgets/creation_collection_sheet.dart';
import 'package:pylons_wallet/pages/home/collection_screen/widgets/show_recipe_json.dart';
import 'package:pylons_wallet/providers/items_provider.dart';
import 'package:pylons_wallet/providers/recipes_provider.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/route_util.dart';
import '../../../providers/collections_tab_provider.dart';
import 'widgets/purchase_collection_sheet.dart';
import 'widgets/trades_collection_sheet.dart';

typedef OnNFTSelected = void Function(NFT asset);

TextStyle kWalletTitle = TextStyle(
  fontSize: 15.sp,
  fontFamily: kUniversalFontFamily,
  color: Colors.black,
  fontWeight: FontWeight.w800,
);

class Collection {
  final String icon;
  final String title;
  final String type; // cookbook | app
  final String app_name;

  Collection({
    required this.icon,
    required this.title,
    required this.type,
    this.app_name = "",
  });
}

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    context.read<RecipesProvider>().getCookBooks();
    context.read<ItemsProvider>().getItems();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CollectionViewModel>();

    PurchasesCollection purchasesCollection() => PurchasesCollection(
          onNFTSelected: (NFT asset) {
            shouldShowOwnerViewOrPurchaseViewForNFT(asset);
          },
        );

    NONNftCreations nonNFTRecipeCollection() => NONNftCreations(
          onNFTSelected: (NFT asset) {},
        );

    CreationsCollection creationsCollection() => CreationsCollection(
          onNFTSelected: (NFT asset) {
            shouldShowOwnerViewOrPurchaseViewForNFT(asset);
          },
        );

    TradesCollection tradesCollection() => TradesCollection(
          onNFTSelected: (NFT asset) {
            shouldShowOwnerViewOrPurchaseViewForNFT(asset);
          },
        );

    final collections = <CollectionsType, Widget Function()>{
      CollectionsType.purchases: purchasesCollection,
      CollectionsType.creations: creationsCollection,
      if (viewModel.nonNFTRecipes.isNotEmpty) CollectionsType.non_nft_creations: nonNFTRecipeCollection,
      if (viewModel.trades.isNotEmpty) CollectionsType.trades: tradesCollection,
    };

    final nonSelectedWidgetsDictionary = collections.entries.where(
      (element) => element.key != viewModel.collectionsType,
    );

    final list = mapIndexed<Widget, MapEntry<CollectionsType, Widget Function()>>(
      nonSelectedWidgetsDictionary,
      (index, item) => Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        top: index * 50.h,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          child: item.value(),
        ),
      ),
    );

    return Stack(
      children: [
        ...list,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          top: (nonSelectedWidgetsDictionary.length) * 50.h,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            child: collections[viewModel.collectionsType]!(),
          ),
        ),
      ],
    );
  }

  void shouldShowOwnerViewOrPurchaseViewForNFT(NFT asset) {
    if (asset.type == NftType.TYPE_RECIPE) {
      onRecipeClicked(asset);
    } else {
      Navigator.of(context).pushNamed(Routes.ownerView.name, arguments: asset);
    }
  }

  Future<void> onRecipeClicked(NFT asset) async {
    final loader = Loading()..showLoading();

    await asset.getOwnerAddress();

    loader.dismiss();

    if (mounted) {
      Navigator.of(context).pushNamed(Routes.ownerView.name, arguments: asset);
    }
  }
}

class NONNftCreations extends StatelessWidget {
  final OnNFTSelected onNFTSelected;

  const NONNftCreations({super.key, required this.onNFTSelected});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CollectionViewModel>();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.kMainBG,
      ),
      child: Column(
        children: [
          const SheetHeading(
            leadingSVG: "assets/images/svg/code.svg",
            title: "Non nft creations",
            collectionType: CollectionsType.non_nft_creations,
          ),
          SizedBox(
            height: 15.h,
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  final recipe = viewModel.nonNFTRecipes[index];

                  if (recipe.cookbookId.contains(kEvently)) {
                    final events = Events.fromRecipe(recipe);
                    navigatorKey.currentState!.pushNamed(Routes.eventOwnerView.name, arguments: events);
                    return;
                  }

                  final showRecipeJsonDialog = ShowRecipeJsonDialog(
                    context: context,
                    recipe: recipe,
                  );
                  showRecipeJsonDialog.show();
                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Text(viewModel.nonNFTRecipes[index].name),
                ),
              ),
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: viewModel.nonNFTRecipes.length,
            ),
          )
        ],
      ),
    );
  }
}

List<QuiltedGridTile> _quiltedGridTile = [
  const QuiltedGridTile(4, 4),
  const QuiltedGridTile(2, 2),
  const QuiltedGridTile(2, 2),
];

SliverQuiltedGridDelegate gridDelegate = SliverQuiltedGridDelegate(
  crossAxisCount: 6,
  mainAxisSpacing: 8,
  crossAxisSpacing: 8,
  repeatPattern: QuiltedGridRepeatPattern.inverted,
  pattern: _quiltedGridTile,
);

class SheetHeading extends StatelessWidget {
  final String leadingSVG;
  final String title;
  final CollectionsType collectionType;
  const SheetHeading({
    super.key,
    required this.leadingSVG,
    required this.title,
    required this.collectionType,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CollectionViewModel>();
    final isSelected = viewModel.collectionsType == collectionType;
    return InkWell(
      onTap: () {
        context.read<CollectionsTabProvider>().setCollectionType(collectionType);
      },
      child: SizedBox(
        height: 40.h,
        child: Stack(
          children: [
            if (isSelected)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0.w,
                right: 0.w,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        spreadRadius: 3,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      BoxShadow(color: AppColors.kMainBG, offset: const Offset(0, 30)),
                    ],
                  ),
                ),
              ),
            if (isSelected)
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child: SvgPicture.asset(
                  Assets.images.svg.collectionsBackground,
                  fit: BoxFit.fill,
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SvgPicture.asset(
                      leadingSVG,
                      height: 20.h,
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Text(
                      title,
                      style: kWalletTitle,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Iterable<E> mapIndexed<E, T>(Iterable<T> items, E Function(int index, T item) f) sync* {
  var index = 0;

  for (final item in items) {
    yield f(index, item);
    index = index + 1;
  }
}
