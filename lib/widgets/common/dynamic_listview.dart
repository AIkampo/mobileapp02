import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DynamicListView {
  final maxScrollOffset = 150;
  bool _fetchingLock = false;
  ScrollController? _controller;
  Future Function()? _onScrollEnd;
  final allDataFetched = false.obs;

  void initScroll({
    required ScrollController controller,
    required Future Function() onScrollEnd,
  }) {
    print("initScroll");
    _controller = controller;
    _onScrollEnd = onScrollEnd;
    _controller!.addListener(_onEndOfScroll);
  }

  void _onEndOfScroll() async {
    print("_onEndOfScroll");
    if (
      _controller!.position.pixels >=
        (_controller!.position.maxScrollExtent - maxScrollOffset) &&
      _controller!.position.pixels >= _controller!.position.minScrollExtent
    ) {
      if (allDataFetched.value) return; // ignore if all data fetched
      if (_fetchingLock) return; // ignore if fetching lock
      _fetchingLock = true;
      await _onScrollEnd!();
      _fetchingLock = false;
    }
  }

  void checkInitialExtent() {
    print("checkInitialExtent");
    // do nothing if not yet initialize
    if (_onScrollEnd == null || _controller == null) return;
    if (allDataFetched.value) return; // ignore if all data fetched
    if (_fetchingLock) return; // ignore if fetching lock

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_controller!.hasClients) {
        // if the list is not scrollable yet
        if (_controller!.position.maxScrollExtent == 0) {
          if (_fetchingLock) return;
          _fetchingLock = true;
          await _onScrollEnd!();
          _fetchingLock = false;
          checkInitialExtent();
        }
      }
    });
  }
}