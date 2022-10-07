import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/model/mnemonic.dart';
import 'package:pylons_wallet/pages/settings/screens/recovery_screen/screens/view_recovery_phrase.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

TextStyle kPracticeTestHeadlineText = TextStyle(fontSize: 28.sp, fontFamily: kUniversalFontFamily, color: Colors.black, fontWeight: FontWeight.w800);
TextStyle kPracticeTestSubtitleText = TextStyle(fontSize: 15.sp, fontFamily: kUniversalFontFamily, color: AppColors.kBlue, fontWeight: FontWeight.w800);

class PracticeTest extends StatefulWidget {
  const PracticeTest({Key? key}) : super(key: key);
  @override
  State<PracticeTest> createState() => _PracticeTestState();
}

class _PracticeTestState extends State<PracticeTest> {
  final _listViewKey = GlobalKey();

  final ScrollController _scroller = ScrollController();

  PracticeTestViewModel get viewModel => GetIt.I.get<PracticeTestViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.initializeData();
  }

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: viewModel,
      child: Scaffold(
        backgroundColor: AppColors.kBackgroundColor,
        body: SingleChildScrollView(
          key: _listViewKey,
          controller: _scroller,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 37.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.top + 20.h,
                ),
                SizedBox(
                  height: 33.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.kUserInputTextColor,
                      )),
                ),
                SizedBox(
                  height: 33.h,
                ),
                Text(
                  "practice_test".tr(),
                  style: kPracticeTestHeadlineText,
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  "place_your_recovery_phrase_in_correct_order".tr(),
                  style: kPracticeTestSubtitleText,
                ),
                SizedBox(
                  height: 30.h,
                ),
                ValueListenableBuilder<List<Mnemonic>>(
                    valueListenable: viewModel.givenListNotifier,
                    builder: (context, value, child) {
                      if (value.isEmpty) {
                        return const SizedBox();
                      }
                      return buildMnemonicDashedList();
                    }),
                SizedBox(
                  height: 10.h,
                ),
                ValueListenableBuilder<List<Mnemonic>>(
                    valueListenable: viewModel.givenListNotifier,
                    builder: (context, value, child) {
                      if (value.isEmpty) {
                        return const SizedBox();
                      }
                      return MnemonicList(
                        scroller: _scroller,
                        onAcceptF: (int fromIndex, int index) {
                          final givenList = viewModel.givenListNotifier.value.toList();
                          final Mnemonic mnemonic = viewModel.acceptedList[fromIndex];
                          viewModel.acceptedList[fromIndex] = Mnemonic(title: "", cardColor: Colors.grey, successDrop: false, sequenceNo: 0);
                          mnemonic.successDrop = false;
                          givenList[index] = mnemonic;
                          viewModel.givenListNotifier.value = givenList;
                        },
                      );
                    }),
                SizedBox(
                  height: 30.h,
                ),
                ValueListenableBuilder<List<Mnemonic>>(
                    valueListenable: viewModel.givenListNotifier,
                    builder: (context, value, child) {
                      final bool isAnyUnplacedItemExists = viewModel.acceptedList.where((element) => element.sequenceNo == 0).isNotEmpty;

                      return InkWell(
                        onTap: isAnyUnplacedItemExists ? null : () => onSubmit(),
                        child: button(enable: !isAnyUnplacedItemExists),
                      );
                    }),
                SizedBox(
                  height: 30.h,
                ),
                InkWell(
                  onTap: () {
                    viewModel.initializeData();
                  },
                  child: Text(
                    "reset".tr(),
                    style: kPracticeTestSubtitleText.copyWith(fontSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget button({required bool enable}) {
    return Container(
      alignment: Alignment.center,
      height: 45.h,
      width: 200.w,
      child: Stack(
        children: [
          SvgPicture.asset(
            SVGUtil.BUTTON_BACKGROUND,
            color: enable ? AppColors.kBlue : AppColors.kBlue.withOpacity(0.5),
          ),
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                  child: Text(
                "submit".tr(),
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
                textAlign: TextAlign.center,
              )))
        ],
      ),
    );
  }

  void onSubmit() {
    GetIt.I.get<Repository>().getMnemonic().then((value) {
      if (value.isRight()) {
        final String mnemonicString = value.getOrElse(() => '');
        final bool mnemonicsMatch = viewModel.acceptedList.map((e) => e.title).join(" ") == mnemonicString;
        if (!mnemonicsMatch) {
          "practice_test_submission_failed".tr().show();
          return;
        }
        "practice_test_submission_successful".tr().show();
      }
    });
  }

  Widget buildTarget(
    BuildContext context, {
    required int acceptNo,
    required Function onAcceptF,
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      return DragTarget<List>(
        builder: (context, candidateData, rejectedData) {
          if (viewModel.acceptedList[acceptNo].successDrop) {
            return _scroller.createListener(
                Draggable<List>(
                    data: [acceptNo, "accepted"],
                    childWhenDragging: DottedBorder(
                      dashPattern: const [6, 6],
                      color: Colors.grey,
                      strokeWidth: 2.h,
                      child: Container(),
                    ),
                    feedback: Material(
                        color: Colors.transparent,
                        child: SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: PracticeTestMnemonic(
                            mnemonic: viewModel.acceptedList[acceptNo],
                            index: acceptNo + 1,
                            showSequenceNo: true,
                          ),
                        )),
                    child: viewModel.acceptedList[acceptNo].successDrop
                        ? PracticeTestMnemonic(
                            index: acceptNo + 1,
                            mnemonic: viewModel.acceptedList[acceptNo],
                            showSequenceNo: true,
                          )
                        : Builder(
                            builder: (BuildContext context) {
                              return DottedBorder(
                                dashPattern: const [6, 6],
                                color: Colors.grey,
                                strokeWidth: 2.h,
                                child: Container(),
                              );
                            },
                          )),
                context);
          }
          return DottedBorder(
            dashPattern: const [6, 6],
            color: Colors.grey,
            strokeWidth: 2.h,
            child: Container(
              key: ValueKey("target_key_$acceptNo"),
            ),
          );
        },
        onWillAccept: (data) => true,
        onAccept: (List list) {
          final int fromIndex = list[0] as int;
          final String fromType = list[1] as String;
          if (viewModel.acceptedList[acceptNo].successDrop == false) {
            if (fromType != "accepted") {
              onAcceptF(fromIndex);
              return;
            }
            final newList = viewModel.givenListNotifier.value.toList();
            final Mnemonic mnemonic = viewModel.acceptedList[fromIndex];
            viewModel.acceptedList[acceptNo] = mnemonic;
            viewModel.acceptedList[fromIndex] = Mnemonic(title: "", cardColor: Colors.grey, successDrop: false, sequenceNo: 0);
            viewModel.givenListNotifier.value = newList;
          }
        },
      );
    });
  }

  Widget buildMnemonicDashedList() {
    return Column(
      children: [
        buildDashedContainerRow(leftSequenceNo: 1, rightSequenceNo: 7),
        buildDashedContainerRow(leftSequenceNo: 2, rightSequenceNo: 8),
        buildDashedContainerRow(leftSequenceNo: 3, rightSequenceNo: 9),
        buildDashedContainerRow(leftSequenceNo: 4, rightSequenceNo: 10),
        buildDashedContainerRow(leftSequenceNo: 5, rightSequenceNo: 11),
        buildDashedContainerRow(leftSequenceNo: 6, rightSequenceNo: 12),
      ],
    );
  }

  Widget buildDashedContainerRow({required int leftSequenceNo, required int rightSequenceNo}) {
    return Container(
      height: 40.h,
      margin: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Expanded(
            child: buildTarget(context, acceptNo: leftSequenceNo - 1, onAcceptF: (int fromIndex) {
              final givenList = viewModel.givenListNotifier.value.toList();
              final Mnemonic mnemonic = givenList[fromIndex];
              givenList[fromIndex] = Mnemonic(title: "", cardColor: Colors.grey, successDrop: true, sequenceNo: 0);
              mnemonic.successDrop = true;
              viewModel.acceptedList[leftSequenceNo - 1] = mnemonic;
              viewModel.givenListNotifier.value = givenList;
            }),
          ),
          SizedBox(
            width: 15.w,
          ),
          Expanded(
            child: buildTarget(context, acceptNo: rightSequenceNo - 1, onAcceptF: (int fromIndex) {
              final givenList = viewModel.givenListNotifier.value.toList();
              final Mnemonic mnemonic = givenList[fromIndex];
              givenList[fromIndex] = Mnemonic(title: "", cardColor: Colors.grey, successDrop: true, sequenceNo: 0);
              mnemonic.successDrop = true;
              viewModel.acceptedList[rightSequenceNo - 1] = mnemonic;
              viewModel.givenListNotifier.value = givenList;
            }),
          ),
        ],
      ),
    );
  }
}

class MnemonicList extends StatelessWidget {
  final Function onAcceptF;
  final ScrollController scroller;
  const MnemonicList({
    Key? key,
    required this.onAcceptF,
    required this.scroller,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<Mnemonic> givenListNotifier = context.read<PracticeTestViewModel>().givenListNotifier.value;
    final gridView = GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10.w, crossAxisSpacing: 5.w, childAspectRatio: 2.3),
        itemCount: givenListNotifier.length,
        itemBuilder: (BuildContext context, int index) {
          return LayoutBuilder(builder: (context, constraints) {
            return DragTarget<List>(
              builder: (context, candidateData, rejectedData) {
                if (givenListNotifier[index].title != "") {
                  return Draggable<List>(
                      data: [index, "given"],
                      childWhenDragging: DottedBorder(
                        dashPattern: const [1, 3],
                        color: Colors.grey,
                        strokeWidth: 1.h,
                        child: Container(),
                      ),
                      feedback: Material(
                          color: Colors.transparent,
                          child:
                              SizedBox(width: constraints.maxWidth, height: constraints.maxHeight, child: PracticeTestMnemonic(mnemonic: givenListNotifier[index], index: 0, showSequenceNo: false))),
                      child: givenListNotifier[index].successDrop == false
                          ? PracticeTestMnemonic(mnemonic: givenListNotifier[index], index: 0, showSequenceNo: false)
                          : DottedBorder(
                              dashPattern: const [1, 3],
                              color: Colors.grey,
                              strokeWidth: 1.h,
                              child: Container(),
                            ));
                }
                return DottedBorder(
                  dashPattern: const [1, 3],
                  color: Colors.grey,
                  child: Container(
                    key: ValueKey("given_key_$index"),
                  ),
                );
              },
              onWillAccept: (data) => true,
              onAccept: (List list) {
                final int fromIndex = list[0] as int;
                final String fromType = list[1] as String;

                if (fromType == "accepted") {
                  if (givenListNotifier[index].successDrop) {
                    onAcceptF(fromIndex, index);
                  }
                }
              },
            );
          });
        });
    return scroller.createListener(gridView, context);
  }
}

extension _CreateListenerWidget on ScrollController {
  Widget createListener(Widget child, BuildContext context) {
    return Listener(
      child: child,
      onPointerMove: (PointerMoveEvent event) {
        const moveDistance = 7;
        if (event.position.dy < 100) {
          var to = offset - moveDistance;
          to = (to < 0.0) ? 0.0 : to;
          jumpTo(to);
        }
        if (event.position.dy > MediaQuery.of(context).size.height - 100) {
          jumpTo(offset + moveDistance);
        }
      },
    );
  }
}

class PracticeTestMnemonic extends StatelessWidget {
  final bool showSequenceNo;
  final Mnemonic mnemonic;
  final int index;
  const PracticeTestMnemonic({Key? key, required this.showSequenceNo, required this.mnemonic, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MnemonicClipper(),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: ColoredBox(
                color: mnemonic.cardColor,
                child: Center(
                    child: Text(
                  mnemonic.title,
                  style: kRecoveryMnemonicText,
                  textAlign: TextAlign.center,
                ))),
          ),
          if (showSequenceNo)
            Positioned(
                left: 7.w,
                top: 5.h,
                child: Text(
                  index.toString(),
                  style: kRecoveryMnemonicIndexText,
                )),
        ],
      ),
    );
  }
}

class MnemonicClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 18);
    path.lineTo(18, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 18);
    path.lineTo(size.width - 18, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class PracticeTestViewModel {
  Repository repository;

  PracticeTestViewModel(this.repository);

  List<Mnemonic> acceptedList = [];
  ValueNotifier<List<Mnemonic>> givenListNotifier = ValueNotifier([]);

  void initializeData() {
    acceptedList = [];
    repository.getMnemonic().then((value) {
      if (value.isRight()) {
        final mnemonicString = value.getOrElse(() => '');
        final mnemonicStringList = mnemonicString.split(" ");
        int i = 0;
        final List<Mnemonic> list = [];
        for (int index = 0; index < mnemonicStringList.length; index++) {
          list.add(Mnemonic(title: mnemonicStringList[index], cardColor: colorListForPracticeTest[i % 5], successDrop: false, sequenceNo: index + 1));
          i++;
          if (shouldRepeatColorForSecondColumn(index)) {
            i = 3;
          }
          acceptedList.add(Mnemonic(title: "", cardColor: Colors.grey, successDrop: false, sequenceNo: 0));
        }
        list.shuffle();
        givenListNotifier.value = list;
      }
    });
  }

  void logScreenEvent() {
    repository.logUserJourney(screenName: AnalyticsScreenEvents.practice);
  }

  bool shouldRepeatColorForSecondColumn(int index) => index == 11;
}
