import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/controllers/authorization_controller.dart';
import 'package:furniture_mcommerce_app/controllers/order_controller.dart';
import 'package:furniture_mcommerce_app/local_store/db/shipping_address_handler.dart';
import 'package:furniture_mcommerce_app/models/authorization.dart';
import 'package:furniture_mcommerce_app/views/screens/order_screen/order_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/profile_screen/detail_profile.dart';

import '../../../local_store/db/account_handler.dart';
import '../payment_screen/add_shipping_address/shipping_address.dart';
import '../search_screen/search_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {

  int countOrder = 0;
  int countAddress = 0;

  User userInfo = User();

  @override
  void initState() {
    _getCountOrder();
    _getCountAddress();
    _getInfoUser();
    super.initState();
  }

  void _getInfoUser() {
    AuthorizationController.getInfoUser().then((dataFormServer) => {
        if(dataFormServer.errCode == 0){
           setState((){
              userInfo = dataFormServer.userData!;
           })
        }
    });
  }

  void _getCountOrder() async {
    String idUser = await AccountHandler.getIdUser();
    print(idUser);
    if(idUser.isEmpty) return;
    OrderController.getNumOrder(idUser).then((dataFromServer) => {
        if(dataFromServer.errCode == 0){
            setState((){
                countOrder = dataFromServer.numorder!;
            })
        }
    });
  }

  void _getCountAddress() async {
      String idUser = await AccountHandler.getIdUser();
      print(idUser);
      if(idUser.isEmpty) return;
      ShippingAddressHandler.countItem(idUser).then((value) => {
        setState((){
          countAddress = value;
        })
      });
  }

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
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
            },
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
                  AccountHandler.deleteAll();
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
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                            // ignore: unnecessary_null_comparison
                            backgroundImage: (userInfo.avatar ?? '') == '' ? const AssetImage('assets/images/img_avatar.png') as ImageProvider
                                : NetworkImage(userInfo.avatar ?? '')
                        ),
                      ),
                      Column(
                        children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10, left: 20),
                              child: Text(
                                  userInfo.fullName ?? '',
                                  style: const TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Color(0xff303030))
                              ),
                            ),
                          Container(
                            margin: const EdgeInsets.only(top: 10, left: 20),
                            child: Text(
                                userInfo.email ?? 'Bạn chưa có email.',
                                style: const TextStyle(
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
                child: GestureDetector(
                  onTap: () async {
                    print('Mở order');
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderScreen()));
                  },
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
                                  child: Text(
                                    countOrder == 0 ? 'Bạn chưa có đơn hàng nào' : 'Bạn có $countOrder đơn hàng',
                                    style: const TextStyle(
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
                child: GestureDetector(
                  onTap: () async {
                    Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(builder: (_) => const ShippingAddressScreen())
                    );
                  },
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
                                    child: Text(
                                     countAddress == 0 ? 'Bạn chưa có địa chỉ nào' : 'Có $countAddress địa chỉ',
                                      style: const TextStyle(
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
              ),
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailProfile(user: userInfo,)));
                  },
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
                                  'Hồ sơ của bạn',
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
              ),
              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              //     child: ClipRRect(
              //       child: Container(
              //         margin: const EdgeInsets.only(bottom: 6.0),
              //         decoration: const BoxDecoration(
              //             color: Colors.white,
              //             boxShadow: [
              //               BoxShadow(
              //                   color: Colors.grey,
              //                   offset: Offset(0.0, 1.0),
              //                   blurRadius: 6.0)
              //             ]),
              //         child: GestureDetector(
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Container(
              //                 margin: const EdgeInsets.all(20),
              //                 child: const Text(
              //                   'Cài đặt',
              //                   style: TextStyle(
              //                       fontFamily: 'NunitoSans',
              //                       fontWeight: FontWeight.w700,
              //                       fontSize: 18,
              //                       color: Color(0xff303030)),
              //                 ),
              //               ),
              //               Container(
              //                 margin: const EdgeInsets.all(20),
              //                 child: const SvgIcon(
              //                   color: Color(0xff303030),
              //                   responsiveColor: false,
              //                   icon: SvgIconData('assets/icons/icon_next.svg'),
              //                 ),
              //               )
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
