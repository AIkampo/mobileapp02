import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rich_clipboard/rich_clipboard.dart';

class InvitationScreen extends StatefulWidget {
  const InvitationScreen({super.key});

  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("邀請朋友"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "分享邀請碼 贈送100點數",
                style: TextStyle(fontSize: 28),
              ),
              SizedBox(
                height: 30,
              ),
              Image.asset(
                "assets/images/share.png",
                scale: 1.6,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 180,
                child: Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(2),
                    title: Text(
                      "X15FSS95",
                      textAlign: TextAlign.center,
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        await RichClipboard.setData(
                            RichClipboardData(text: "X15FSS95"));
                      },
                      icon: Icon(Icons.copy),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "當您的朋友注冊成功後，輸入您的邀請碼，雙方將獲得100點數！！",
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }
}
