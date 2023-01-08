import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAPI {
  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<void> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final refResult = await ref.listAll();
    final urls = await _getDownloadLinks(refResult.items);
    print('*********** 1 **************');
    print(refResult.items);
    print('************ 2 *************');
    print(ref.child("0963517217.jpg").getDownloadURL());
    ref.child("0963517217.jpg").getDownloadURL().then((e) {
      print('************ 3 *************');
      print(e.toString());
    });
    print('************ 4 *************');
    print(urls);
  }

  static Future<String> getUserAvatarUrl(String phoneNumber) async {
    final storageRef = FirebaseStorage.instance.ref('userAvatar/');
    return await storageRef.child('$phoneNumber.jpg').getDownloadURL();
  }
}
