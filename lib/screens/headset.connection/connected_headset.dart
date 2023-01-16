import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/gen/flutterblueplus.pbserver.dart';

class ConnectedHeadset extends StatelessWidget {
  const ConnectedHeadset({super.key, required this.headset});
  final BluetoothDevice headset;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Connected Headset:${headset.name.toString()}"),
    );
  }
}
