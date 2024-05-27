import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';

class Utils {
  static Future<bool> isNetworkAvailable() async {
    return await Connectivity()
        .checkConnectivity()
        .then((res) => res != ConnectivityResult.none);
  }
}

String fullPhoneRepresentation(String countryCode, String number) {
  return "$countryCode $number";
}

String removeCountryCode(String representation) {
  return representation.split(" ").length >= 2?
    representation.split(" ")[1]: representation;
}

String dateTimeToYearUntilDay(DateTime date) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(date);
}

String dateTimeToYearUntilMinute(DateTime date) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
  return formatter.format(date);
}

DateTime? dateTimeFromJson(Timestamp? ts) => ts?.toDate();
Timestamp? dateTimeToJson(DateTime? date) => date == null?
  null: Timestamp.fromDate(date);
