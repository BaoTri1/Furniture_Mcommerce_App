import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/shared_resources/share_string.dart';
import 'package:furniture_mcommerce_app/views/screens/order_screen/list_order.dart';

class OrderScreen extends StatefulWidget{
  const OrderScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return OrderScreenState();
  }
    
}

class OrderScreenState extends State<OrderScreen>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "OrderScreen",
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text(
                  'Đơn hàng của bạn',
                style:  TextStyle(
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
              bottom: const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(
                    child: Text(
                        ShareString.DANG_XU_LY,
                        style: TextStyle(
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            //color: Color(0xff999999)
                        ),
                    )
                  ),
                  Tab(
                      child: Text(
                        ShareString.SAN_SANG_GIAO_HANG,
                        style: TextStyle(
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            //color: Color(0xff999999)
                        ),
                      )
                  ),
                  Tab(
                      child: Text(
                        ShareString.DANG_GIAO_HANG,
                        style: TextStyle(
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            //color: Color(0xff999999)
                        ),
                      )
                  ),
                  Tab(
                      child: Text(
                        ShareString.DA_GIAO_HANG_THANH_CONG,
                        style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          //color: Color(0xff999999)
                        ),
                      )
                  ),
                  Tab(
                      child: Text(
                        ShareString.DA_HUY,
                        style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          //color: Color(0xff999999)
                        ),
                      )
                  ),
                ],
                labelColor: Colors.black, // Màu sắc của văn bản được chọn
                indicatorColor: Colors.black,
              ),
            ),
            body: TabBarView(
              children: [
                ListOrder(status: ShareString.DANG_XU_LY),
                ListOrder(status: ShareString.SAN_SANG_GIAO_HANG),
                ListOrder(status: ShareString.DANG_GIAO_HANG),
                ListOrder(status: ShareString.DA_GIAO_HANG_THANH_CONG),
                ListOrder(status: ShareString.DA_HUY),
              ],
            ),
        ),
      ),
    );
  }
  
}