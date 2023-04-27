import 'package:flutter/material.dart';

class SliverLoading extends StatelessWidget {
  const SliverLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 30),
          child: const Center(
            child: CircularProgressIndicator(),
          )),
    );
  }
}
