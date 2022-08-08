import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../easel_provider.dart';

class EaselHashtagInputField extends StatefulWidget {
  const EaselHashtagInputField({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HashtagInputFieldState();
  }
}

class _HashtagInputFieldState extends State<EaselHashtagInputField> {
  final _inputController = TextEditingController();
  late final ValueNotifier<List<String>> _hashtagsNotifier;

  @override
  void initState() {
    super.initState();

    _hashtagsNotifier =
        ValueNotifier(context.read<EaselProvider>().hashtagsList);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EaselProvider>(
      builder: (_, provider, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            kHashtagsText,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4.h),
          Stack(children: [
            Image.asset(
              kTextFieldSingleLine,
              height: isTablet ? 32.h : 40.h,
              width: 1.sw,
              fit: BoxFit.fill,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0.w),
                  child: SvgPicture.asset(kSearchIcon),
                ),
                Flexible(
                    child: SizedBox(
                        height: isTablet ? 32.h : 40.h,
                        child: Align(
                            alignment: Alignment.center,
                            child: TextFormField(
                              style: TextStyle(
                                  fontSize: isTablet ? 16.sp : 18.sp,
                                  fontWeight: FontWeight.w400,
                                  color: EaselAppTheme.kDarkText),
                              controller: _inputController,
                              minLines: 1,
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.none,
                              decoration: InputDecoration(
                                hintText: kHintHashtag,
                                hintStyle: TextStyle(
                                    fontSize: isTablet ? 16.sp : 18.sp,
                                    color: EaselAppTheme.kGrey),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                contentPadding:
                                    EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                            )))),
                Padding(
                  padding: EdgeInsets.only(right: 10.0.w),
                  child: InkWell(
                    child: SvgPicture.asset(kAddIcon),
                    onTap: () {
                      setState(() {
                        var trimmed = _inputController.text.trim();
                        trimmed = trimmed.replaceAll('#', '');
                        if (trimmed.isNotEmpty &&
                            !_hashtagsNotifier.value.contains(trimmed)) {
                          _hashtagsNotifier.value.add(trimmed);
                        }
                        _inputController.clear();
                      });
                    },
                  ),
                ),
              ],
            )
          ]),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _hashtagsNotifier.value
                      .map((hashtag) => Row(
                            children: [
                              Text('#' + hashtag,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: EaselAppTheme.kGrey)),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _hashtagsNotifier.value.remove(hashtag);
                                  });
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: EaselAppTheme.kLightGrey,
                                ),
                              ),
                              SizedBox(width: 10.w)
                            ],
                          ))
                      .toList(),
                ),
              ))
        ],
      ),
    );
  }
}
