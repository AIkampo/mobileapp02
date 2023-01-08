import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    final Future<String> userAvatarUrl =
        FirebaseAPI.getUserAvatarUrl(phoneNumber);

    return FutureBuilder<String>(
        future: userAvatarUrl,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return CircleAvatar(
              child: Icon(
                CupertinoIcons.person,
                size: 50,
              ),
              radius: 50,
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircleAvatar(
                child: CircularProgressIndicator(),
                radius: 50,
              );

            case ConnectionState.done:
              return avatarWithImg(snapshot);
            case ConnectionState.none:
            default:
              return CircleAvatar(
                child: Icon(CupertinoIcons.person),
                radius: 50,
              );
          }
        }));
  }

  CircleAvatar avatarWithImg(AsyncSnapshot<String> snapshot) {
    return CircleAvatar(
      backgroundImage: NetworkImage(snapshot.data!),
      radius: 50,
    );
  }
}
