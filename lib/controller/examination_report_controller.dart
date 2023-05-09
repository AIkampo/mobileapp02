import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:ai_kampo_app/api/oberon_api.dart';
import 'package:ai_kampo_app/common/function.dart';
import 'package:ai_kampo_app/models/allergen_model.dart';
import 'package:ai_kampo_app/models/germs.dart';
import 'package:ai_kampo_app/models/nine_system_model.dart';
import 'package:ai_kampo_app/models/nine_system_trend_model.dart';
import 'package:ai_kampo_app/models/score_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share/share.dart';
import 'package:k2_printer/k2_printer.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:barcode/barcode.dart';


class ExaminationReportController extends GetxController {
  final reportCaseId = "".obs;

  final RxMap<dynamic, dynamic> userProfile = {}.obs;
  final isUserProfileLoading = true.obs;

  //九大組織系統檢測資料
  final nineSystemList = <NineSystemModel>[].obs;
  final isNineSystemDataLoading = true.obs;

  //細菌與微生物評估資料
  final germsList = <GermsModel>[].obs;
  final isGermsDataLoading = true.obs;
  //過敏原評估資料
  final allergenList = <AllergenModel>[].obs;
  final isAllergenDataLoading = true.obs;
  //器官系統分析資料
  final organSystemList = <ScoreModel>[].obs;
  final isOrganSystemDataLoading = true.obs;

//九大組織系統檢測 歷史資料

  final RxMap nineSystemTrendMap = {}.obs;
  final isNineSystemTrendLoading = true.obs;

  // QR Code link
  final phoneNumber = "".obs;

  // for POS printer
  final _k2PrinterPlugin = K2Printer();
  
  // for print qr code
  final Barcode _bc = Barcode.qrCode();

  String get primaryReportLink =>
      "https://api.aikserver01.com/api/Report/basic/$reportCaseId";
  String get professionalReportLink =>
      "https://api.aikserver01.com/api/Report/$reportCaseId/$phoneNumber";

  setPhoneNumber(String number) {
    phoneNumber.value = number;
  }

  Future<void> copyLinkToClipboard(String link) async {
    Clipboard.setData(ClipboardData(text: link));
  }

  Future<void> sharePrimaryReportLink() async {
    Share.share(primaryReportLink);
  }

  Future<void> shareProfessionalReportLink() async {
    Share.share(professionalReportLink);
  }

  Future<Uint8List> generatePrimaryReportQrPdf() async {
    final pdf = pw.Document(title:"基礎報告-${reportCaseId.value}");
    final hwscTtf = pw.Font.ttf(
      await rootBundle.load("assets/font/SourceHanSansHWSC-VF.ttf"));

    pw.TextStyle titleTextStyle = pw.TextStyle(
      fontSize: 16, font: hwscTtf, fontWeight: pw.FontWeight.bold
    );

    pw.Widget title = pw.Align(
      alignment: pw.Alignment.center,
      child: pw.Text("檢測編號：${reportCaseId.value}", style: titleTextStyle)
    );
    pw.Widget reportType = pw.Align(
      alignment: pw.Alignment.center,
      child: pw.Text("基礎報告", style: titleTextStyle)
    );

    final qrCode = pw.Barcode.qrCode();
    final qrCodeImage = qrCode.toSvg(primaryReportLink);
    pw.Widget qrCodeWidget = pw.SvgImage(svg: qrCodeImage);

    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(
          80 * PdfPageFormat.mm,
          double.infinity,
        ),
        build: (context) => pw.Column(
          children: [
            title,
            reportType,
            pw.Divider(height: 15),
            qrCodeWidget,
            pw.Divider(height: 45),
          ]
        ),
      )
    );

    return pdf.save();
  }

  Future<Uint8List> generateProReportQrPdf() async {
    final pdf = pw.Document(title:"專業報告-${reportCaseId.value}");
    final hwscTtf = pw.Font.ttf(
      await rootBundle.load("assets/font/SourceHanSansHWSC-VF.ttf"));

    pw.TextStyle titleTextStyle = pw.TextStyle(
      fontSize: 16, font: hwscTtf, fontWeight: pw.FontWeight.bold
    );

    pw.Widget title = pw.Align(
      alignment: pw.Alignment.center,
      child: pw.Text("檢測編號：${reportCaseId.value}", style: titleTextStyle)
    );
    pw.Widget reportType = pw.Align(
      alignment: pw.Alignment.center,
      child: pw.Text("專業報告", style: titleTextStyle)
    );

    final qrCode = pw.Barcode.qrCode();
    final qrCodeImage = qrCode.toSvg(professionalReportLink);
    pw.Widget qrCodeWidget = pw.SvgImage(svg: qrCodeImage);

    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(
          80 * PdfPageFormat.mm,
          double.infinity,
        ),
        build: (context) => pw.Column(
          children: [
            title,
            reportType,
            pw.Divider(height: 15),
            qrCodeWidget,
            pw.Divider(height: 45),
          ]
        ),
      )
    );

    return pdf.save();
  }

  Future<void> previewPrimaryReportQrPdf() async {
    await Printing.layoutPdf(
      format: const PdfPageFormat(
        80 * PdfPageFormat.mm,
        double.infinity,
      ),
      onLayout: (PdfPageFormat format) async => generatePrimaryReportQrPdf()
    );
  }

  Future<void> previewProReportQrPdf() async {
    await Printing.layoutPdf(
      format: const PdfPageFormat(
        80 * PdfPageFormat.mm,
        double.infinity,
      ),
      onLayout: (PdfPageFormat format) async => generateProReportQrPdf()
    );
  }

  Future<String?> printPrimaryReportQr() async {
    try {
      String platformVersion = await _k2PrinterPlugin.getPlatformVersion()??
        "Unknown platform version";
      print("Platform Version: $platformVersion");
    } on PlatformException {
      return "無法查詢平台編號！";
    }

    final printerCommands = [
      PrintText(text: "檢測編號：${reportCaseId.value}\n"),
      PrintText(text: "基礎報告"),
      LineWrap(n: 2),
      PrintQrCode(data: primaryReportLink, moduleSize: 10, errorLevel: 1),
      LineWrap(n: 2),
      CutPaper(mode: CutPaperMode.fullCut, paperFeed: 15),
    ];
    Document document = Document(
      id: "primaryReportQr",
      printerCommands: printerCommands,
    );
    _k2PrinterPlugin.print(document);
    
    return null;
  }

  Future<String?> printProReportQr() async {
    try {
      String platformVersion = await _k2PrinterPlugin.getPlatformVersion()??
        "Unknown platform version";
      print("Platform Version: $platformVersion");
    } on PlatformException {
      return "無法查詢平台編號！";
    }

    final printerCommands = [
      PrintText(text: "檢測編號：${reportCaseId.value}\n"),
      PrintText(text: "專業報告"),
      LineWrap(n: 2),
      PrintQrCode(data: professionalReportLink, moduleSize: 10, errorLevel: 1),
      LineWrap(n: 2),
      CutPaper(mode: CutPaperMode.fullCut, paperFeed: 15),
    ];
    Document document = Document(
      id: "proReportQr",
      printerCommands: printerCommands,
    );
    _k2PrinterPlugin.print(document);

    return null;
  }

  Future<void> fetchUserProfile(String phoneNumber) async {
    isUserProfileLoading.value = true;
    await FirebaseAPI.getUserData(phoneNumber).then((res) {
      print("+++++ ----- +++++ fetchUserProfile   res...");
      print(res);

      userProfile.value = res;
    }).whenComplete(() => isUserProfileLoading.value = false);
  }

  setUserProfile(Map<dynamic, dynamic> userData) {
    userProfile.value = userData;
  }

  Future<void> fetchNineSystemData(String caseId) async {
    isNineSystemDataLoading.value = true;
    List tempList = await fetchNineSystemScore(caseId);

    if (tempList.isNotEmpty) {
      // TODO: this function is called twice and might interfere nineSystemList in each call
      // currently a hack method
      nineSystemList.clear();
      //先將回傳的資料依索引順序取得值建立LIST、再依數值大小排序
      // [0 消化, 1 呼吸, 2 泌尿, 3循環, 4 淋巴, 5 內分泌, 6 神經, 7 感知, 8 骨骼]
      nineSystemList.add(
        NineSystemModel.fromJson({
          "indexName": "digestion",
          "score": int.parse(tempList[0].toString()),
          "name": "消化系統",
          "img": "assets/icons/digestive_system.png"
        }),
      );
      nineSystemList.add(NineSystemModel.fromJson({
        "indexName": "breathe",
        "score": int.parse(tempList[1].toString()),
        "name": "呼吸系統",
        "img": "assets/icons/respiratory_system.png"
      }));
      nineSystemList.add(NineSystemModel.fromJson({
        "indexName": "urinary",
        "score": int.parse(tempList[2].toString()),
        "name": "泌尿系統",
        "img": "assets/icons/urinary_system.png"
      }));
      nineSystemList.add(NineSystemModel.fromJson({
        "indexName": "cycle",
        "score": int.parse(tempList[3].toString()),
        "name": "循環系統",
        "img": "assets/icons/circulatory_system.png"
      }));
      nineSystemList.add(NineSystemModel.fromJson({
        "indexName": "lymph",
        "score": int.parse(tempList[4].toString()),
        "name": "淋巴系統",
        "img": "assets/icons/lymphatic_system.png"
      }));

      nineSystemList.add(NineSystemModel.fromJson({
        "indexName": "endocrine",
        "score": int.parse(tempList[5].toString()),
        "name": "内分泌系統",
        "img": "assets/icons/endocrine_system.png"
      }));

      nineSystemList.add(NineSystemModel.fromJson({
        "indexName": "nerve",
        "score": int.parse(tempList[6].toString()),
        "name": "神經系統",
        "img": "assets/icons/nervous_system.png"
      }));

      nineSystemList.add(NineSystemModel.fromJson({
        "indexName": "perception",
        "score": int.parse(tempList[7].toString()),
        "name": "感知系統",
        "img": "assets/icons/perception_system.png"
      }));
      nineSystemList.add(NineSystemModel.fromJson({
        "indexName": "skeleton",
        "score": int.parse(tempList[8].toString()),
        "name": "骨骼系統",
        "img": "assets/icons/skeletal_system.png"
      }));

      nineSystemList.sort((a, b) => a.score!.compareTo(b.score!));
      isNineSystemDataLoading.value = false;
    }
  }

  Future<void> fetchGermsData(caseId) async {
    isGermsDataLoading.value = true;
    germsList.clear();
    await OberonAPI.getGermsData(caseId).then((res) {
      if (res.data['success']) {
        List tempList = res.data['data'].toList();
        tempList = sortAndGetList(tempList, "d", "DESC", 5);
        for (var e in tempList) {
          germsList.add(GermsModel.fromJson(e));
        }
      } else {
        Get.snackbar("注意", "無法取得細菌與微生物評估資料");
      }
    }).catchError((e) {
      Get.snackbar("注意!", "無法取得細菌與微生物評估資料");
    }).whenComplete(() {
      isGermsDataLoading.value = false;
    });
  }

  List sortAndGetList(List dataList, column, orderBy, count) {
    if (orderBy == "DESC") {
      dataList.sort((a, b) => b['d'].compareTo(a['d']));
    } else {
      dataList.sort((a, b) => a['d'].compareTo(b['d']));
    }

    return dataList.getRange(0, count).toList();
  }

  Future<void> fetchAllergenData(caseId) async {
    isAllergenDataLoading.value = true;
    allergenList.clear();
    await OberonAPI.getAllergenData(caseId).then((res) {
      if (res.data['success']) {
        List tempList = res.data['data'].toList();
        tempList = sortAndGetList(tempList, "d", "DESC", 5);
        for (var e in tempList) {
          allergenList.add(AllergenModel.fromJson(e));
        }
      } else {
        // Get.snackbar("Failed!", "無法取得過敏原評估資料");
        throw Exception("無法取得過敏原評估資料");
      }
    }).catchError((e) {
      Get.snackbar("注意", "無法取得過敏原評估資料");
    }).whenComplete(() {
      isAllergenDataLoading.value = false;
    });
  }

  Future<void> fetchOrganSystemData(String organ, String caseId) async {
    isOrganSystemDataLoading.value = true;
    organSystemList.clear();

    await OberonAPI.getOrganSystemData(organ, caseId).then((res) {
      if (res.data['success']) {
        List tempList = res.data['data'].toList();
        tempList = sortAndGetList(tempList, "d", "ACE", 10);

        for (var e in tempList) {
          organSystemList.add(ScoreModel.fromJson(e));
        }
      } else {
        throw Exception("無法取得器官系統分析資料!");
      }
    }).catchError((e) {
      Get.snackbar("注意", "無法取得器官系統分析資料!");
    }).whenComplete(() {
      isOrganSystemDataLoading.value = false;
    });

    //RTU
    // try {
    //   final response = await Dio().get(
    //     "https://api.aikserver01.com/api/Score/$organ/7/$caseId",
    //     options: Options(headers: _headers),
    //   );

    //   if (response.data['success']) {
    //     List tempList = response.data['data'].toList();
    //     tempList = sortAndGetList(tempList, "d", "DESC", 5);

    //     for (var e in tempList) {
    //       organSystemList.add(ScoreModel.fromJson(e));
    //     }
    //   } else {
    //     Get.snackbar("Failed!", "無法取得器官系統分析資料!");
    //   }
    // } catch (e) {
    //   Get.snackbar("", "無法取得器官系統分析資料");
    // }
    // isOrganSystemDataLoading.value = false;
  }

  Future<void> setCaseId(String caseId) async {
    reportCaseId.value = caseId;
    fetchNineSystemData(caseId);
    fetchGermsData(caseId);
    fetchAllergenData(caseId);
    nineSystemTrendMap.value = {};
  }

//取得歷使器官分數已繪製「健康趨勢圖」
  Future<void> fetchNineSystemTrendData(List caseIdList) async {
    if (nineSystemTrendMap.isNotEmpty) return;
    isNineSystemTrendLoading.value = true;
    List<SystemTrendModel> digestionList = [];
    List<SystemTrendModel> breatheList = [];
    List<SystemTrendModel> urinaryList = [];
    List<SystemTrendModel> cycleList = [];
    List<SystemTrendModel> lymphList = [];
    List<SystemTrendModel> endocrineList = [];
    List<SystemTrendModel> nerveList = [];
    List<SystemTrendModel> perceptionList = [];
    List<SystemTrendModel> skeletonList = [];

    try {
      for (var caseId in caseIdList.reversed) {
        var tempList = await fetchNineSystemScore(caseId);
        var tempDate = caseIdToDatetime(caseId);

        // [0 消化, 1 呼吸, 2 泌尿, 3循環, 4 淋巴, 5 內分泌, 6 神經, 7 感知, 8 骨骼]
        digestionList.add(SystemTrendModel(tempDate, tempList[0]));
        breatheList.add(SystemTrendModel(tempDate, tempList[1]));
        urinaryList.add(SystemTrendModel(tempDate, tempList[2]));
        cycleList.add(SystemTrendModel(tempDate, tempList[3]));
        lymphList.add(SystemTrendModel(tempDate, tempList[4]));
        endocrineList.add(SystemTrendModel(tempDate, tempList[5]));
        nerveList.add(SystemTrendModel(tempDate, tempList[6]));
        perceptionList.add(SystemTrendModel(tempDate, tempList[7]));
        skeletonList.add(SystemTrendModel(tempDate, tempList[8]));
      }

      nineSystemTrendMap.value = {
        "digestion": digestionList,
        "breathe": breatheList,
        "urinary": urinaryList,
        "cycle": cycleList,
        "lymph": lymphList,
        "endocrine": endocrineList,
        "nerve": nerveList,
        "perception": perceptionList,
        "skeleton": skeletonList
      };
      isNineSystemTrendLoading.value = false;
    } catch (e) {
      Get.snackbar("注意！", "無法解析健康趨勢資料");
      isNineSystemTrendLoading.value = false;
    }
  }

  Future<List> fetchNineSystemScore(String caseId) async {
    List scoreList = [];

    await OberonAPI.getNineSystemScore(caseId).then((res) {
      if (res.data['success']) {
        scoreList = res.data['data'];
      } else {
        throw Exception("無法取得九大組織系統分數");
      }
    }).catchError((e) {
      Get.snackbar("注意!", "無法取得九大組織系統分數");
    }).whenComplete(() => scoreList);
    return scoreList;
  }
}
