import 'dart:convert';
import 'package:crypto/crypto.dart';

Future<String> encryptPassword(String password) async {
  final bytes = utf8.encode(password);
  final digest = sha512.convert(bytes);
  return digest.toString();
}
