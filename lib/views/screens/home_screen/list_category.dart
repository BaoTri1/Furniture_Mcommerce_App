import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/views/screens/search_screen/product_search.dart';

List<String> categorys = [
  'Phòng',
  'Sofa',
  'Bàn',
  'Ghế',
  'Giường',
  'Tủ & Kệ',
  'Khác'
];

List<String> icons = [
  'assets/icons/icon_room.svg',
  'assets/icons/icon_sofa.svg',
  'assets/icons/icon_table.svg',
  'assets/icons/icon_chair.svg',
  'assets/icons/icon_bed.svg',
  'assets/icons/icon_capbinet.svg',
  'assets/icons/icon_other.svg',
];

class ListCategoryWidget extends StatelessWidget {
  const ListCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
          itemCount: categorys.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, int index) {
            return GestureDetector(
              onTap: () {
                print('${categorys[index]} + ' '${icons[index]}');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProductSearch()));
              },
              child: Card(
                color: const Color(0xffF0F0F0),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgIcon(
                          icon: SvgIconData(icons[index]),
                        ),
                        Text(
                          categorys[index],
                          style: const TextStyle(
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xff999999)),
                        ),
                      ]),
                ),
              ),
            );
          }),
    );
  }
}
