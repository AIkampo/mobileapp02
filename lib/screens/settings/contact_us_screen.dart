import 'package:flutter/material.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("聯絡我們"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: const [
              Text(
                "如您的問題無法透過客服解決，請隨時聯係我們，我們會爲您解答。",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(Icons.business_outlined),
                title: Text("台灣智能漢方股份有限公司"),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text("台北市中正區忠孝西路一段72號2樓之5"),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.email_outlined),
                title: Text("sales@aikampo.com"),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text("02-7755 2030"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
