import 'dart:io';
import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:ai_kampo_app/utils/get_image_from_gallery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar({Key? key, required this.phoneNumber}) : super(key: key);
  final String phoneNumber;

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  late Future<String> _userAvatarUrl;
  File? _newUserImgFile;

  @override
  Widget build(BuildContext context) {
    // _userAvatarUrl = FirebaseAPI.getUserAvatarUrl(widget.phoneNumber);
    return _newUserImgFile != null
        ? imgAvatar(userAvatarFile: _newUserImgFile)
        : FutureBuilder<String>(
            future: FirebaseAPI.getUserAvatarUrl(widget.phoneNumber),
            builder: ((context, snapshot) {
              if (snapshot.hasError) return defaultAvatar();
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CircleAvatar(
                    radius: 50,
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  String userAvatarUrl = snapshot.data!;
                  return imgAvatar(userAvatarUrl: userAvatarUrl);
                default:
                  return defaultAvatar();
              }
            }));
  }

  GestureDetector defaultAvatar() {
    return GestureDetector(
      onLongPress: () => updateImg(),
      child: const CircleAvatar(
        radius: 50,
        child: Icon(
          CupertinoIcons.person,
          size: 50,
        ),
      ),
    );
  }

  CupertinoContextMenu imgAvatar(
      {String? userAvatarUrl, File? userAvatarFile}) {
    return CupertinoContextMenu(
      actions: [
        CupertinoContextMenuAction(
            child: Text("更新照片"),
            trailingIcon: Icons.photo,
            onPressed: () {
              Get.back();
              updateImg();
            }),
        CupertinoContextMenuAction(
          isDestructiveAction: true,
          child: Text("刪除"),
          trailingIcon: Icons.delete_outline,
          onPressed: () {
            Get.back();

            deleteImg();
          },
        ),
      ],
      child: userAvatarFile != null
          ? CircleAvatar(
              backgroundImage: FileImage(userAvatarFile),
              radius: 50,
            )
          : CircleAvatar(
              backgroundImage: NetworkImage(userAvatarUrl!),
              radius: 50,
            ),
    );
  }

  Future<void> updateImg() async {
    await getImageFromGallery().then((imgFile) {
      if (imgFile != null) {
        FirebaseAPI.saveUserAvatar(
                phoneNumber: widget.phoneNumber, imgFile: imgFile)
            .then((value) {
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _newUserImgFile = imgFile;
            });
          });
        }).catchError((error) {
          Get.snackbar("更新失敗", "無法儲存照片！");
        });
      }
    }).catchError((error) {
      // Get.snackbar("更新失敗", "無法上傳照片！");
    });
  }

  Future<void> deleteImg() async {
    FirebaseAPI.deleteUserAvatar(widget.phoneNumber).then((value) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _newUserImgFile = null;
          _userAvatarUrl = Future<String>(() => '');
        });
      });
    }).catchError((error) {
      Get.snackbar("提醒", "無法刪除照片！");
    });
  }
}
