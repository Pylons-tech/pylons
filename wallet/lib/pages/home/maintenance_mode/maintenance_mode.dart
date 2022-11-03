import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:pylons_wallet/components/feedback_text_field.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/clipper_utils.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart' as clipper;

import '../../../generated/locale_keys.g.dart';

class MaintenanceMode {
  final BuildContext context;

  MaintenanceMode({
    required this.context,
  });

  Future<void> show() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) =>
            Dialog(backgroundColor: Colors.transparent, insetPadding: EdgeInsets.symmetric(horizontal: isTablet ? 65.w : 21.w), child: const _MaintenanceModeMessage()));
  }
}

class _MaintenanceModeMessage extends StatefulWidget {
  const _MaintenanceModeMessage({Key? key}) : super(key: key);

  @override
  State<_MaintenanceModeMessage> createState() => _MaintenanceModeMessageState();
}

class _MaintenanceModeMessageState extends State<_MaintenanceModeMessage> {
  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.grey,
      child: Text(LocaleKeys.maintenance_mode_message.tr()),
    );
  }
}