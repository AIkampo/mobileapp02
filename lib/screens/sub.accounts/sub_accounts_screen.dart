import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:ai_kampo_app/controller/account_controller.dart';
import 'package:ai_kampo_app/widgets/kampo_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubAccountsScreen extends StatefulWidget {
  const SubAccountsScreen({super.key});

  @override
  State<SubAccountsScreen> createState() => _SubAccountsScreenState();
}

class _SubAccountsScreenState extends State<SubAccountsScreen> {
  final _isLoading = true.obs;
  String _userPhoneNumber = "";

  @override
  Widget build(BuildContext context) {
    getUserPhoneNumber();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.find<AccountController>().selectedPhoneNumber.value = "";
              Get.find<AccountController>().initData();
              Get.offNamed("/main");
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        centerTitle: true,
        title: Text("子帳號管理"),
        actions: [
          IconButton(
              onPressed: () {
                Get.offAndToNamed("/add.sub.account");
              },
              icon: Icon(CupertinoIcons.person_add))
        ],
      ),
      body: Obx(
        () => _isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : FutureBuilder(
                future: FirebaseAPI.getSubAccounts(_userPhoneNumber),
                builder: ((context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      if (snapshot.data.isEmpty) {
                        return const Center(
                          child: Text(
                            "目前沒有子帳號",
                            style: TextStyle(fontSize: 22),
                          ),
                        );
                      } else {
                        return subAccountListView(snapshot.data);
                      }
                    case ConnectionState.waiting:
                    default:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                  }
                })),
      ),
    );
  }

  getUserPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    _userPhoneNumber = prefs.getString('phoneNumber')!;
    _isLoading.value = false;
  }

  ListView subAccountListView(subAccounts) {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: subAccounts.length,
        itemBuilder: (context, index) {
          final account = subAccounts[index];
          return ListTile(
            leading: Icon(
              account['sex'] == 'M' ? Icons.male : Icons.female,
              color: account['sex'] == 'M' ? Colors.blue : Colors.red,
              size: 48,
            ),
            title: Text(account['username']),
            subtitle: Text(account['phoneNumber']),
            trailing: IconButton(
                icon: Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                ),
                onPressed: () {
                  _confirmToDeleteDialog(account['phoneNumber']);
                }),
          );
        });
  }

  Future<void> handleDeleteSubAccount(
      BuildContext context, String subAccountPhoneNumber) async {
    _isLoading.value = true;

    final prefs = await SharedPreferences.getInstance();
    final userPhoneNumber = prefs.getString('phoneNumber')!;

    await FirebaseAPI.deleteSubAccount(userPhoneNumber, subAccountPhoneNumber)
        .then((value) {
      // Get.snackbar('通知', '子帳號已刪除！');
      KampoDialog.confirmToPop(context, "", "子帳號已刪除");

      _isLoading.value = false;
    }).catchError((error) {
      // Get.snackbar('通知', '無法刪除子帳號！');
      KampoDialog.confirmToPop(context, "", "無法刪除子帳號");
    });
  }

  _confirmToDeleteDialog(String subAccountPhoneNumber) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("確定要刪除？"),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text('確定'),
            onPressed: () {
              Get.back();
              handleDeleteSubAccount(context, subAccountPhoneNumber);
            },
          ),
          CupertinoDialogAction(
            child: Text('取消'),
            onPressed: () => Get.back(),
          )
        ],
      ),
    );
  }
}
