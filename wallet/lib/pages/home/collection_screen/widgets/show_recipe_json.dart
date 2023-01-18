import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/recipe.pb.dart';

import '../../../../utils/constants.dart';

class ShowRecipeJsonDialog {
  ShowRecipeJsonDialog({
    required this.context,
    required this.recipe,
  });

  Future<void> show() {
    return showDialog(
      context: context,
      builder: (context) => _RecipeJson(
        recipe: recipe,
      ),
    );
  }

  BuildContext context;
  Recipe recipe;
}

class _RecipeJson extends StatelessWidget {
  final Recipe recipe;

  const _RecipeJson({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final object = json.decode(jsonEncode(recipe.toProto3Json()));
    final prettyString = const JsonEncoder.withIndent('  ').convert(object);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.kUserInputTextColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: RawScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(prettyString),
          ),
        ),
      ),
    );
  }
}
