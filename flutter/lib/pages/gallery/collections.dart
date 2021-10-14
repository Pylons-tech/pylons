import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/detail/detail_screen.dart';

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: CustomScrollView(slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            //3 image card
            Container(
                width: double.infinity,
                height: 370,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(kImage2),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        // Where the linear gradient begins and ends
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        // Add one stop for each color. Stops should increase from 0 to 1
                        stops: [0, 1.0],
                        colors: [
                          // Colors are easy thanks to Flutter's Colors class.
                          Colors.transparent,
                          Colors.black,
                        ],
                      ),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                      // VerticalSpace(108),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('photography'.tr(), textAlign: TextAlign.left, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                      // SizedBox(height: 28),
                      const Text('Description about the title Descritpion about the title Description about the title Description about the title',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white)),
                      // VerticalSpace(10),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        IconButton(icon: const Icon(Icons.add, color: Colors.white), onPressed: () {}),
                        IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () {})
                      ]),
                      /** Staggered View */
                    ]))),
          ]),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverStaggeredGrid.countBuilder(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              itemCount: 15,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DetailScreenWidget(isOwner: true)));
                    },
                    child: Container(
                        decoration: const BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          child: CachedNetworkImage(imageUrl: _getImage(index), fit: BoxFit.cover),
                        )));
              },
              staggeredTileBuilder: (index) {
                return StaggeredTile.count((index == 1 || index == 6) ? 2 : 1, (index == 1 || index == 6) ? 2 : 1);
              }),
        )
      ]),
    );
  }

  String _getImage(int index) {
    switch (index % 4) {
      case 1:
        return kImage2;

      case 2:
        return kImage3;

      case 3:
        return kImage1;

      default:
        return kImage;
    }
  }
}
