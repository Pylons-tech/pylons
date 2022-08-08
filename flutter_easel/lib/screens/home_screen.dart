import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/describe_screen.dart';
import 'package:easel_flutter/screens/price_screen.dart';
import 'package:easel_flutter/screens/publish_screen.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'choose_format_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late EaselProvider easelProvider;
  var repository = GetIt.I.get<Repository>();

  HomeViewModel get homeViewModel => GetIt.I.get();

  @override
  void initState() {
    easelProvider = Provider.of<EaselProvider>(context, listen: false);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<EaselProvider>().initStore();
    });

    homeViewModel.init(
      setTextField: () {
        easelProvider.setTextFieldValuesDescription(
            artName: homeViewModel.nft?.name,
            description: homeViewModel.nft?.description,
            hashtags: homeViewModel.nft?.hashtags);
        easelProvider.setTextFieldValuesPrice(
            royalties: homeViewModel.nft?.tradePercentage,
            price: homeViewModel.nft?.price,
            edition: homeViewModel.nft?.quantity.toString(),
            denom: homeViewModel.nft?.denom,
            freeDrop: homeViewModel.nft!.isFreeDrop);
      },
    );
  }

  @override
  void dispose() {
    homeViewModel.disposeControllers();
    super.dispose();
  }

  void onBackPressed() {
    easelProvider.videoLoadingError = '';
    easelProvider.isVideoLoading = true;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    homeViewModel.previousPage();
    if (homeViewModel.currentPage.value == 1) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onBackPressed();
        return false;
      },
      child: Container(
        color: EaselAppTheme.kWhite,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            body: ChangeNotifierProvider.value(
                value: homeViewModel, child: const HomeScreenContent()),
          ),
        ),
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();
    return PageView.builder(
      controller: homeViewModel.pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (int page) {
        homeViewModel.currentPage.value = page;
        final map = {0: 0, 1: 1, 2: 1, 3: 2};
        homeViewModel.currentStep.value = map[page]!;
      },
      itemBuilder: (BuildContext context, int index) {
        final map = {
          0: chooseFormatScreen,
          1: describeScreen,
          2: priceScreen,
          3: publishScreen
        };

        return map[index]?.call() ?? const SizedBox();
      },
    );
  }

  Widget chooseFormatScreen() {
    return const ChooseFormatScreen();
  }

  Widget describeScreen() {
    return const DescribeScreen();
  }

  Widget priceScreen() {
    return const PriceScreen();
  }

  Widget publishScreen() {
    return const PublishScreen();
  }
}
