//過敏原評估
import 'package:ai_kampo_app/screens/test.results/test_results_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Allergen extends StatefulWidget {
  const Allergen({super.key});

  @override
  State<Allergen> createState() => _AllergenState();
}

class _AllergenState extends State<Allergen> {
  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<TestResultsController>();
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      sliver: Obx(() => SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Card(
                child: ListTile(
                  title: Text(
                    "${_controller.allergenList[index].name}",
                    style: TextStyle(fontSize: 22),
                  ),
                  trailing: Text(
                    "${_controller.allergenList[index].d}%",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              );
            }, childCount: _controller.allergenList.length),
          )),
    );
  }
}
