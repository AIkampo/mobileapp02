import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:ai_kampo_app/screens/sub.accounts/add_sub_account_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("子帳號管理"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/add.sub.account").then((value) {
                  setState(() {});
                });
              },
              icon: Icon(CupertinoIcons.person_add))
        ],
      ),
      body: FutureBuilder(
          future: FirebaseAPI.getSubAccounts('0970483255'),
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.data.isEmpty) {
                  return const Center(
                    child: Text("尚無子帳號"),
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
    );
  }

  ListView subAccountListView(subAccounts) {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: subAccounts.length,
        itemBuilder: (context, index) {
          final account = subAccounts[index];
          return ListTile(
            leading: Icon(
              account['sex'] == 'male' ? Icons.male : Icons.female,
              color: account['sex'] == 'male' ? Colors.blue : Colors.red,
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

  Future<void> handleDeleteSubAccount(String subAccountPhoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final userPhoneNumber = prefs.getString('phoneNumber') ?? '0970483255';

    await FirebaseAPI.deleteSubAccount(userPhoneNumber, subAccountPhoneNumber)
        .then((value) {
      Get.snackbar('Info', '子帳號已刪除！');
      setState(() {});
    }).catchError((error) => Get.snackbar('Info', '無法刪除子帳號！'));
  }

  _confirmToDeleteDialog(String subAccountPhoneNumber) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("確定要刪除？"),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text('確定'),
            onPressed: () {
              Get.back();
              handleDeleteSubAccount(subAccountPhoneNumber);
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
