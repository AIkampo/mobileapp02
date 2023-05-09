//能量寶石指引 頁面
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:ai_kampo_app/widgets/common/KampoTitle.dart';
import 'package:ai_kampo_app/widgets/common/SliverLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';


class PrimaryReportLinkScreen extends StatelessWidget {
  PrimaryReportLinkScreen({super.key});

  final _controller = Get.find<ExaminationReportController>();
  final GlobalKey _qrKey = GlobalKey();

  Future<void> qrCodePreview() async {
    _controller.previewPrimaryReportQrPdf();
  }

  Future<void> printQrCode() async {
    String? printMessage = await _controller.printPrimaryReportQr();
    if (printMessage != null) Get.snackbar("列印失敗", printMessage);
  }

  Future<void> _shareQrCoder() async {
    await _controller.sharePrimaryReportLink();
  }

  Future<void> _copyLink() async {
    _controller.copyLinkToClipboard(_controller.primaryReportLink);
    Get.snackbar("成功", "成功將連結複製至剪貼簿!");
  }

  Future<void> _openLink() async {
    final Uri _url = Uri.parse(_controller.primaryReportLink);
    if (!await launchUrl(_url)) {
      Get.snackbar("失敗", "無法開啟網址連結");
      throw Exception("Could not launch ${_controller.primaryReportLink}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("基礎報告"),
      ),
      body: Column(
        children: [
          const KampoTitle(title: "基礎報告 QR Code"),
          Expanded(
            child: Obx(
              () => _controller.reportCaseId.value.isEmpty
              ? const SliverLoading()
              : Padding(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "檢測編號：${_controller.reportCaseId.value}",
                        style: const TextStyle(fontSize: 24),
                      ),
                      const Divider(height: 20, color: Colors.transparent),
                      Container(
                        constraints: BoxConstraints(
                          minWidth: 200,
                          maxWidth: 512,
                        ),
                        width: 0.5 * MediaQuery.of(context).size.width,
                        child: RepaintBoundary(
                          key: _qrKey,
                          child:  BarcodeWidget(
                            barcode: Barcode.qrCode(
                              errorCorrectLevel: BarcodeQRCorrectionLevel.low
                            ),
                            data: _controller.primaryReportLink,
                          ),
                        ),
                      ),
                      const Divider(height: 20, color: Colors.transparent),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.share, size: 30),
                            onPressed: _shareQrCoder,
                          ),
                          const VerticalDivider(width: 30),
                          IconButton(
                            icon: const Icon(Icons.link, size: 30),
                            onPressed: _copyLink,
                          ),
                          const VerticalDivider(width: 30),
                          IconButton(
                            icon: const Icon(Icons.web, size: 30),
                            onPressed: _openLink,
                          )
                        ]
                      ),
                      const Divider(height: 40, color: Colors.transparent),
                      IconButton(
                        onPressed: printQrCode,
                        icon: Icon(Icons.print, color: Colors.cyan[600]),
                        iconSize: 50,
                      ),
                      const Divider(height: 40, color: Colors.transparent),
                      TextButton(
                        onPressed: qrCodePreview,
                        child: const Text(
                          "預覽列印", style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
