import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {


  Future<void> _refresh() async {
    print('Refreshing...');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Screen',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Hồ sơ',
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
              icon: SvgIconData('assets/icons/icon_search.svg'),
            ),
            onPressed: () {},
          ),
          actions: [
            IconButton(
                padding: const EdgeInsets.only(right: 12),
                icon: const SvgIcon(
                  icon: SvgIconData('assets/icons/icon_exit.svg'),
                  responsiveColor: false,
                  color: Color(0xff808080),
                  size: 24,
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (Route<dynamic> route) => false);
                }),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(left: 20, top: 30),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                            backgroundImage: AssetImage('assets/images/img_avatar.png')
                        ),
                      ),
                      Column(
                        children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10, left: 20),
                              child: const Text(
                                  'Phạm Bảo Trí',
                                  style: TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Color(0xff303030))
                              ),
                            ),
                          Container(
                            margin: const EdgeInsets.only(top: 10, left: 20),
                            child: const Text(
                                'abc@gmail.com',
                                style: TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                    color: Color(0xff808080))
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
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
                      child: GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 20, left: 20, right: 10),
                                  child: const Text(
                                    'Đơn hàng của bạn',
                                    style: TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                        color: Color(0xff303030)),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 20, right: 10, bottom: 10),
                                  child: const Text(
                                    'Bạn có 5 đơn hàng',
                                    style: TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Color(0xff808080)),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.all(20),
                              child: const SvgIcon(
                                color: Color(0xff303030),
                                responsiveColor: false,
                                icon: SvgIconData('assets/icons/icon_next.svg'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                      child: GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 20, left: 20, right: 10),
                                  child: const Text(
                                    'Địa chỉ giao hàng của bạn',
                                    style: TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                        color: Color(0xff303030)),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 20, right: 10, bottom: 10),
                                  child: const Text(
                                    '5 địa chỉ',
                                    style: TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Color(0xff808080)),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.all(20),
                              child: const SvgIcon(
                                color: Color(0xff303030),
                                responsiveColor: false,
                                icon: SvgIconData('assets/icons/icon_next.svg'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                      child: GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(20),
                              child: const Text(
                                'Chỉnh sửa hồ sơ',
                                style: TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Color(0xff303030)),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(20),
                              child: const SvgIcon(
                                color: Color(0xff303030),
                                responsiveColor: false,
                                icon: SvgIconData('assets/icons/icon_next.svg'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                      child: GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(20),
                              child: const Text(
                                'Cài đặt',
                                style: TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Color(0xff303030)),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(20),
                              child: const SvgIcon(
                                color: Color(0xff303030),
                                responsiveColor: false,
                                icon: SvgIconData('assets/icons/icon_next.svg'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
