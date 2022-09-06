import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/model/transaction_failure_model.dart';
import 'package:pylons_wallet/pages/transaction_failure_manager/failure_manager_view_model.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/extension.dart';

class FailureListScreen extends StatefulWidget {
  const FailureListScreen({Key? key}) : super(key: key);

  @override
  State<FailureListScreen> createState() => _FailureListScreenState();
}

class _FailureListScreenState extends State<FailureListScreen> {
  FailureManagerViewModel get failureManagerViewModel => sl();

  IconButton getTransactionStatusButton({required LocalTransactionModel txManager}) {
    final TransactionStatus txStatusEnum = txManager.status.toTransactionStatusEnum();
    switch (txStatusEnum) {
      case TransactionStatus.Success:
        return IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.done,
              color: Colors.green,
            ));
      case TransactionStatus.Failed:
        return IconButton(
            onPressed: () => failureManagerViewModel.handleRetry(txManager: txManager),
            icon: const Icon(
              Icons.refresh,
              color: Colors.redAccent,
            ));
      case TransactionStatus.Undefined:
        return IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.error_outline,
              color: Colors.redAccent,
            ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Failures"),
      ),
      body: FutureBuilder<List<LocalTransactionModel>>(
        future: failureManagerViewModel.getAllFailuresFromDB(),
        builder: (context, AsyncSnapshot snapshot) {
          if (ConnectionState.waiting == snapshot.connectionState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.length == 0) {
            return const Center(
              child: Text(
                "No Failures!!",
                style: TextStyle(color: Colors.black),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(15),
            child: ListView.builder(
                itemCount: snapshot.data.length as int,
                itemBuilder: (context, int index) {
                  final LocalTransactionModel txManager = snapshot.data[index] as LocalTransactionModel;
                  return ListTile(
                      title: Text(
                        txManager.transactionDescription,
                        style: TextStyle(fontSize: 18.sp),
                      ),
                      trailing: getTransactionStatusButton(txManager: txManager));
                }),
          );
        },
      ),
    );
  }
}
