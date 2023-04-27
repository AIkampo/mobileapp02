import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class KampoDialog {
  static confirmToPop(
    BuildContext context,
    String title,
    String content,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: title.isEmpty ? null : Text(title),
        content: content.isEmpty ? null : Text(content),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('確認'),
          ),
        ],
      ),
    );
  }

  static confirmAndOffAllNamed(
    BuildContext context,
    String title,
    String content,
    String screenName,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: title.isEmpty ? null : Text(title),
        content: content.isEmpty ? null : Text(content),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              Get.offAllNamed("/$screenName");
            },
            child: const Text('確認'),
          ),
        ],
      ),
    );
  }
}
