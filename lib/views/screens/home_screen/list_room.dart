import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/views/screens/search_screen/product_search.dart';

List<String> room = [
  'Phòng khách',
  'Phòng ngủ',
  'Phòng ăn',
  'Phòng làm việc',
];

class ListRoomWidget extends StatelessWidget {
  const ListRoomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
       width: MediaQuery.of(context).size.width,
       height: 90,
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
          itemCount: room.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (_) => ProductSearch(search: '', idcatParent: '', nameRoom: room[index],)));
              },
              child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  color: const Color(0xffE8E8E8),
                  child: Text(
                      room[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Color(0xff303030))
                  )
              ),
            );
          }),
    );
  }
}
