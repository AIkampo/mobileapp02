import 'dart:async';
import 'package:ai_kampo_app/common/config.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ClinicsScreen extends StatefulWidget {
  const ClinicsScreen({super.key});

  @override
  State<ClinicsScreen> createState() => _ClinicsScreenState();
}

class _ClinicsScreenState extends State<ClinicsScreen> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(25.048584811272598, 121.51162538113131), zoom: 14);

  List clinicList = [
    {"name": "國健中醫診所", "address": "臺北市中正區館前路6號7樓之7", "telephone": "02-23715012"},
    {"name": "南陽中醫診所", "address": "臺北市中正區南陽街3號7樓之2號", "telephone": "09-07278069"},

    // {"name": "", "address": "", "telephone": ""},
  ];
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      header: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 20,
        child: Center(
          child: Container(
            height: 6,
            width: 42,
            decoration: ShapeDecoration(
              color: KampoColors.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
      panel: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(
              label: Text("聯盟診搜尋"),
              prefixIcon: Image.asset(
                "assets/icons/clinic.png",
                scale: 1.2,
              ),
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
              ),
            ),
          ),
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(3),
              color: const Color(0xFFAEE0DD),
              child: const Text(
                "您附近的聯盟診所",
                style: TextStyle(color: Color(0xFF01ACBD)),
              )),
          Expanded(
            child: ListView.separated(
                itemCount: 100,
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${clinicList[index % 2]['name']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${clinicList[index % 2]['address']}"),
                        Text("${clinicList[index % 2]['telephone']}"),
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
