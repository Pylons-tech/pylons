import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/utils/constants.dart';

abstract class FirestoreHelper {
  /// This method will save users feedback to firebase based on its wallet address
  /// Input : [walletAddress], [subject] and [feedback] the address against which the feedbacks needs to be stored
  /// Output : [bool] It will return true if the saving feedback is successful otherwise false
  Future<bool> saveUserFeedback({required String walletAddress, required String subject, required String feedback});
}

class FirestoreHelperImp implements FirestoreHelper {
  CollectionReference mainFeedbacksCollection;

  FirestoreHelperImp({required this.mainFeedbacksCollection});

  @override
  Future<bool> saveUserFeedback({required String walletAddress, required String subject, required String feedback}) async {
    try {
      final DocumentReference documentReference = mainFeedbacksCollection.doc();
      final timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      final Map<String, dynamic> data = <String, dynamic>{
        kSubjectKey: subject,
        kFeedbackKey: feedback,
        kTimeStampKey: timeStamp,
        kAddressKey: walletAddress,
      };

      await documentReference.set(data);
      return true;
    } catch (e) {
      throw HandlerFactory.ERR_SOMETHING_WENT_WRONG;
    }
  }
}
