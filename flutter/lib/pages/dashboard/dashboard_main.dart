import 'package:flutter/material.dart';
import 'package:pylons_wallet/pages/dashboard/dashboard_assets.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);
  static const String _title = 'Pylons Home';
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: DashboardWidget(),
    );
  }
}

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              floating: true,
              stretch: true,
              expandedHeight: 160,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar (
                background: SingleChildScrollView(
                  child: DashboardAssets()
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Container(
                    color: index.isOdd ? Colors.white : Colors.black12,
                    height: 100.0,
                    child: Center(
                      child: Text('$index', textScaleFactor: 5),
                    ),
                  );
                },
                childCount: 20,
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: OverflowBar(
            overflowAlignment: OverflowBarAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget> [
                  Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const<Widget>[
                        Icon(
                          Icons.home_outlined,
                          color: Colors.indigo,
                        ),
                        Text("Home", style: TextStyle(fontSize: 12, color: Colors.indigo))
                      ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const<Widget>[
                      Icon(
                        Icons.search_outlined,
                        color: Colors.black12,
                      ),
                      Text("Home", style: TextStyle(fontSize: 12, color: Colors.indigo))
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const<Widget>[
                      Icon(
                        Icons.storefront_outlined,
                        color: Colors.black12,
                      ),
                      Text("Home", style: TextStyle(fontSize: 12, color: Colors.indigo))
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const<Widget>[
                      Icon(
                        Icons.collections_outlined,
                        color: Colors.black12,
                      ),
                      Text("Home", style: TextStyle(fontSize: 12, color: Colors.indigo))
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
