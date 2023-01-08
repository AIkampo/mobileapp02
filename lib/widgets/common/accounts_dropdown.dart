import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountsDropdown extends StatelessWidget {
  AccountsDropdown({super.key});

  final List<Map> _accountList = [
    {"phoneNumber": "0912345670", "name": "主帳號", "sex": "male"},
    {"phoneNumber": "0912345677", "name": "黃大明", "sex": "male"},
    {"phoneNumber": "0912345678", "name": "黃小明", "sex": "male"},
    {"phoneNumber": "0912345679", "name": "黃小媚", "sex": "female"},
  ];

  final _selectingAccount = "0912345670".obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() => DropdownButton(
          isExpanded: true,
          value: _selectingAccount.value,
          onChanged: (value) {
            _selectingAccount.value = value;
          },
          items: _accountList.map<DropdownMenuItem>((account) {
            return DropdownMenuItem(
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  account['sex'] == 'male'
                      ? Icon(
                          Icons.male_outlined,
                          color: Colors.blue,
                        )
                      : Icon(
                          Icons.female,
                          color: Colors.red,
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(account['name']),
                  SizedBox(
                    width: 20,
                  ),
                  Text(account['phoneNumber'])
                ],
              ),
              value: account['phoneNumber'],
            );
          }).toList(),
        ));
  }
}
