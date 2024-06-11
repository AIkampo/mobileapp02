import 'package:flutter/material.dart';
import 'package:get/get.dart';


const transparentRouteDuration = Duration(milliseconds: 250);
const loadingPageColor = Color.fromRGBO(200, 200, 200, 0.7);

// TransparentRoute for loading page
class TransparentRoute extends PageRoute<void> {
  TransparentRoute({
    required this.builder,
    RouteSettings? settings,
  }): super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => transparentRouteDuration;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: result,
      ),
    );
  }
}

class ProgressLoadingPage extends StatefulWidget {
  const ProgressLoadingPage({Key? key}) : super(key: key);

  @override
  _ProgressLoadingPageState createState() => _ProgressLoadingPageState();
}

class _ProgressLoadingPageState extends State<ProgressLoadingPage> {
  final Future task = Get.arguments['task'];

  @override
  void initState() {
    super.initState();
    task.then((value) => Get.back(result: value))
      .catchError((err) => Get.back());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: loadingPageColor,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
