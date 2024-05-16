import 'package:easy_localization/easy_localization.dart';
import 'package:evently/evently_provider.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/models/events.dart';
import 'package:evently/screens/custom_widgets/bottom_buttons.dart';
import 'package:evently/screens/custom_widgets/page_app_bar.dart';
import 'package:evently/screens/custom_widgets/step_labels.dart';
import 'package:evently/screens/custom_widgets/steps_indicator.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/utils/screen_responsive.dart';
import 'package:evently/utils/space_utils.dart';
import 'package:evently/viewmodels/create_event_viewmodel.dart';
import 'package:evently/widgets/evently_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class PerksScreen extends StatefulWidget {
  const PerksScreen({super.key});

  @override
  State<PerksScreen> createState() => _PerksScreenState();
}

class _PerksScreenState extends State<PerksScreen> {
  @override
  Widget build(BuildContext context) {
    final createEventViewModel = context.watch<CreateEventViewModel>();

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Consumer<EventlyProvider>(
              builder: (_, provider, __) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VerticalSpace(20),
                      MyStepsIndicator(currentStep: createEventViewModel.currentStep),
                      const VerticalSpace(5),
                      StepLabels(currentPage: createEventViewModel.currentPage, currentStep: createEventViewModel.currentStep),
                      const VerticalSpace(20),
                      PageAppBar(
                        onPressBack: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          createEventViewModel.previousPage();
                        },
                      ),
                      const VerticalSpace(20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.add_perk.tr(),
                              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: () => provider.setPerks = PerksModel(name: kFreeShirt, description: ''),
                              child: DecoratedBox(
                                decoration: const BoxDecoration(
                                  color: EventlyAppTheme.kBlue,
                                ),
                                child: Icon(Icons.add, size: 16.h, color: EventlyAppTheme.kWhite),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalSpace(10),
                      if (provider.perks.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            LocaleKeys.there_no_perks_created.tr(),
                            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: EventlyAppTheme.kGrey01),
                          ),
                        ),
                      if (provider.perks.isNotEmpty)
                        PerksView(
                          perksModel: provider.perks,
                          onChangeDescription: (String value) => provider.updatePerks(
                            PerksModel.updateDescription(
                              description: value,
                              perksModel: provider.perks[provider.selectedPerk],
                            ),
                            provider.selectedPerk,
                          ),
                          onChangeName: (String value) => provider.updatePerks(
                            PerksModel.updateName(
                              name: value,
                              perksModel: provider.perks[provider.selectedPerk],
                            ),
                            provider.selectedPerk,
                          ),
                          removePerk: () => provider.removePerks(provider.selectedPerk),
                          selectedIndex: provider.selectedPerk,
                          setSelectedPerk: (_) => provider.setSelectedPerks = _,
                        ),
                    ],
                  ),
                  const VerticalSpace(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BottomButtons(
                      onPressContinue: () {
                        createEventViewModel.nextPage();
                      },
                      onPressSaveDraft: () {},
                      isContinueEnable: true,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PerksView extends StatelessWidget {
  const PerksView({
    super.key,
    required this.perksModel,
    required this.onChangeDescription,
    required this.onChangeName,
    required this.removePerk,
    required this.selectedIndex,
    required this.setSelectedPerk,
  });

  final List<PerksModel> perksModel;
  final int selectedIndex;
  final ValueChanged<String> onChangeName;
  final ValueChanged<String> onChangeDescription;
  final VoidCallback removePerk;
  final ValueChanged<int> setSelectedPerk;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: perksModel
              .asMap()
              .entries
              .map(
                (e) => GestureDetector(
                  onTap: () => setSelectedPerk(e.key),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ScreenResponsive(
                          mobileScreen: (context) => Image.asset(
                            selectedIndex == e.key ? PngUtils.kLightPurpleSingleLine : PngUtils.kDarkPurpleSingleLine,
                            height: 40.h,
                            width: 1.sw,
                            fit: BoxFit.fill,
                          ),
                          tabletScreen: (context) => Image.asset(
                            selectedIndex == e.key ? PngUtils.kLightPurpleSingleLine : PngUtils.kDarkPurpleSingleLine,
                            height: 32.h,
                            width: 1.sw,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: SvgPicture.asset(SVGUtils.kMinus),
                                onTap: () => removePerk(),
                              ),
                              HorizontalSpace(10.w),
                              Text(
                                e.value.name.tr(),
                                style: TextStyle(color: EventlyAppTheme.kWhite, fontSize: 15.sp, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const VerticalSpace(10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.w),
          child: Text(
            LocaleKeys.perk_icon.tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
        ),
        const VerticalSpace(6),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PerksIconSelection(
                icon: SVGUtils.kShirt,
                isSelected: perksModel[selectedIndex].name == kFreeShirt,
                onTap: () => onChangeName(kFreeShirt),
              ),
              PerksIconSelection(
                icon: SVGUtils.kGift,
                isSelected: perksModel[selectedIndex].name == kFreeGift,
                onTap: () => onChangeName(kFreeGift),
              ),
              PerksIconSelection(
                icon: SVGUtils.kDrinks,
                isSelected: perksModel[selectedIndex].name == kFreeDrink,
                onTap: () => onChangeName(kFreeDrink),
              ),
            ],
          ),
        ),
        const VerticalSpace(20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.w),
          child: EventlyTextField(
            onChanged: (_) => onChangeDescription(_),
            noOfLines: 4,
            label: LocaleKeys.description_optional.tr(),
            hint: LocaleKeys.claim_free_drink.tr(),
            controller: TextEditingController(text: perksModel[selectedIndex].description)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: perksModel[selectedIndex].description.length),
              ),
            textCapitalization: TextCapitalization.sentences,
          ),
        ),
      ],
    );
  }
}

class PerksIconSelection extends StatelessWidget {
  const PerksIconSelection({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String icon;
  final bool isSelected;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(7),
        color: isSelected ? EventlyAppTheme.kTextLightPurple : Colors.transparent,
        child: SvgPicture.asset(icon),
      ),
    );
  }
}
