import 'package:get/get.dart';


class LinkMetaData {
  String link;
  String title;

  LinkMetaData({
    required this.link,
    required this.title,
  });
}

class LinkListState {
  final data = <LinkMetaData>[].obs;
  final loadingData = true.obs;
}
