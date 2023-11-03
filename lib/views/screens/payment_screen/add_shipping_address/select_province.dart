import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/controllers/address_controller.dart';
import 'package:furniture_mcommerce_app/models/province.dart';

class SelectProvince extends StatefulWidget {
  const SelectProvince({super.key});

  @override
  State<StatefulWidget> createState() {
    return SelectProvinceState();
  }
}

class SelectProvinceState extends State<SelectProvince> {
  ListProvince results = ListProvince(results: []);

  @override
  void initState() {
    AddressController.fetchProvince().then((dataFromServer) => {
          setState(() {
            results = dataFromServer;
          })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Chọn Tỉnh/thành phố',
            style: TextStyle(
                fontFamily: 'Merriweather',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xff303030)),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const SvgIcon(
              color: Color(0xff808080),
              responsiveColor: false,
              icon: SvgIconData('assets/icons/icon_back.svg'),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView.builder(
          itemCount: results.results.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context, results.results[index]);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ClipRRect(
                  child: Container(
                      margin: const EdgeInsets.only(bottom: 6.0),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0),
                                blurRadius: 6.0)
                          ]),
                      child: Container(
                          margin: const EdgeInsets.only(
                              top: 20, left: 10, right: 10),
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            results.results[index].provinceName,
                            style: const TextStyle(
                                fontFamily: 'Gelasio',
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Color(0xff242424)),
                          ))),
                ),
              ),
            );
          },
        ));
  }
}
