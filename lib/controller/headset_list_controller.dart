import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class HeadsetListContorller extends GetxController {
  final selectedHeadset = Rx<BluetoothDevice?>(null);
  final isScanning = true.obs;
  final isConnecting = false.obs;
}
