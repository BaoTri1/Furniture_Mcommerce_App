import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/views/screens/search_screen/product_search.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Screen',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const SvgIcon(
                icon: SvgIconData('assets/icons/icon_back.svg'),
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: Container(
              margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                          color: Color(0xff242424), width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                          color: Color(0xff242424), width: 1.0)),
                  hintText: 'Nhập từ khóa cần tìm...',
                  hintStyle: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                      color: Color(0xffE0E0E0),
                      fontSize: 16),
                  suffixIcon: IconButton(
                      icon: const SvgIcon(
                        icon: SvgIconData('assets/icons/icon_search.svg'),
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductSearch()));
                      }),
                ),
              ),
            )),
        // body: CustomScrollView(
        //   slivers: [
        //     SliverAppBar(
        //         expandedHeight: 70,
        //         leading: IconButton(
        //           icon: const SvgIcon(
        //             icon: SvgIconData('assets/icons/icon_back.svg'),
        //             color: Colors.black,
        //           ),
        //           onPressed: () {
        //             Navigator.pop(context);
        //           },
        //         ),
        //         backgroundColor: Colors.white,
        //         pinned: true,
        //         flexibleSpace: FlexibleSpaceBar(
        //             background: Container(
        //           margin: const EdgeInsets.only(
        //               top: 5, left: 50, right: 30, bottom: 10),
        //           child: TextField(
        //             decoration: InputDecoration(
        //               filled: true,
        //               fillColor: Colors.white,
        //               enabledBorder: OutlineInputBorder(
        //                   borderRadius: BorderRadius.circular(5),
        //                   borderSide: const BorderSide(
        //                       color: Color(0xff242424), width: 1.0)),
        //               focusedBorder: OutlineInputBorder(
        //                   borderRadius: BorderRadius.circular(5),
        //                   borderSide: const BorderSide(
        //                       color: Color(0xff242424), width: 1.0)),
        //               hintText: 'Nhập từ khóa cần tìm...',
        //               hintStyle: const TextStyle(
        //                   fontFamily: 'Nunito Sans',
        //                   fontWeight: FontWeight.w600,
        //                   color: Color(0xffE0E0E0),
        //                   fontSize: 16),
        //               suffixIcon: IconButton(
        //                 icon: const SvgIcon(
        //                   icon: SvgIconData('assets/icons/icon_search.svg'),
        //                   color: Colors.black,
        //                 ),
        //                 onPressed: () {},
        //               ),
        //             ),
        //           ),
        //         ))),
        //   ],
        // ),
      ),
    );
  }
}
