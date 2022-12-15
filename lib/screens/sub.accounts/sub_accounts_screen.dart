import 'package:ai_kampo_app/screens/sub.accounts/add_sub_account_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

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
                Get.to(() => AddSubAccountScreen());
              },
              icon: Icon(CupertinoIcons.person_add))
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: 3,
        itemBuilder: (context, index) => ListTile(
          leading: Icon(
            CupertinoIcons.person_alt_circle,
            size: 48,
          ),
          title: Text("09XXXXXXX"),
          trailing: IconButton(
            icon: Icon(
              Icons.remove_circle,
              color: Colors.red,
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
