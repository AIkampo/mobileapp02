import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

class PaymentAPI {
  static Future linePayRequest() async {
    const uri = '/v3/payments/request';

    final String nonce = Uuid().v4();
    const channelSecret = '48fc5d4a97a10a8f4d99fee9e13cb8f9';

    final requestJson = json.encode({
      "amount": 4000,
      "currency": "TWD",
      "orderId": "order504ac11a-1888-4410-89b2-75382fef61b3",
      "packages": [
        {
          "id": "20191011I001",
          "amount": 4000,
          "name": "星戰公仔",
          "products": [
            {"name": "星際大戰足輕白兵第一軍團風暴兵", "quantity": 2, "price": 2000}
          ]
        }
      ],
      "redirectUrls": {
        "confirmUrl": "https://6ddcf789.ngrok.io/confitmUrl",
        "cancelUrl": "https://6ddcf789.ngrok.io/cancelUrl"
      }
    });

    final headersObj = {
      'Content-Type': 'application/json',
      'X-LINE-ChannelId': '1660744588',
      'X-LINE-Authorization-Nonce': nonce.toString(),
      'X-LINE-Authorization':
          encrypt(channelSecret, channelSecret + uri + requestJson.toString() + nonce)
    };

    return await Dio().post('https://sandbox-api-pay.line.me/v3/payments/request',
        options: Options(
          headers: headersObj,
        ),
        data: requestJson);
  }

  static encrypt(final String keys, final String data) {
    var hmacSha256 = Hmac(sha256, utf8.encode(keys));
    var covertData = hmacSha256.convert(utf8.encode(data));

    return base64Encode(covertData.bytes);
  }
}
