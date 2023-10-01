import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/models/item_cart.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/add_shipping_address/shipping_address.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/select_pay/select_pay_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/select_ship/select_ship_screen.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return PaymentScreenState();
  }
}

class PaymentScreenState extends State<PaymentScreen> {
  final List<ItemCart> _listItem = [
    ItemCart(
        id: 1,
        id_user: 'U01',
        name: 'Bàn 1',
        quantity: 2,
        price: 20000000,
        urlImg: 'assets/images/img_sofa.jpg'),
    ItemCart(
        id: 2,
        id_user: 'U01',
        name: 'Bàn 2',
        quantity: 1,
        price: 20000000,
        urlImg: 'assets/images/img_sofa.jpg'),
    ItemCart(
        id: 3,
        id_user: 'U01',
        name: 'Bàn 3',
        quantity: 1,
        price: 20000000,
        urlImg: 'assets/images/img_sofa.jpg'),
    ItemCart(
        id: 4,
        id_user: 'U01',
        name: 'Bàn 4',
        quantity: 3,
        price: 20000000,
        urlImg: 'assets/images/img_sofa.jpg'),
    ItemCart(
        id: 5,
        id_user: 'U01',
        name: 'Bàn 5',
        quantity: 2,
        price: 20000000,
        urlImg: 'assets/images/img_sofa.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Screen',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Thanh toán',
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
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Text(
                      'Địa chỉ giao hàng',
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xff909090)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ShippingAddressScreen()));
                        },
                        icon: const SvgIcon(
                            icon: SvgIconData('assets/icons/icon_edit.svg'))),
                  )
                ],
              ),
            ),
            SliverToBoxAdapter(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: const Text(
                            'Phạm Bảo Trí | SĐT: 0123456789',
                            style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Color(0xff303030)),
                          ),
                        ),
                        Container(
                          height: 2,
                          width: 335,
                          color: const Color(0xffF0F0F0),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: const Text(
                            '25 rue Robert Latouche, Nice, 06200, Côte D’azur, France',
                            style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xff808080)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(left: 5, top: 10),
                child: const Text(
                  'Danh sách sản phẩm',
                  style: TextStyle(
                      fontFamily: 'NunitoSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color(0xff909090)),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: ClipRRect(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      //height: MediaQuery.of(context).size.height,
                      margin: const EdgeInsets.only(bottom: 6.0),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0),
                                blurRadius: 6.0)
                          ]),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: _buildItemProduct,
                        itemCount: _listItem.length,
                      )),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 20),
                    child: const Text(
                      'Mã giảm giá',
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xff909090)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10, top: 20),
                    child: IconButton(
                        onPressed: () {},
                        icon: const SvgIcon(
                          icon: SvgIconData('assets/icons/icon_edit.svg'),
                          color: Color(0xff808080),
                        )),
                  )
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ClipRRect(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    //height: MediaQuery.of(context).size.height,
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
                      margin: const EdgeInsets.all(10),
                      child: const Text(
                        'Chọn hoặc nhập mã giảm giá',
                        style: TextStyle(
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xff303030)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 20),
                    child: const Text(
                      'Phương thức thanh toán',
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xff909090)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10, top: 20),
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectPay()));
                        },
                        icon: const SvgIcon(
                          icon: SvgIconData('assets/icons/icon_edit.svg'),
                          color: Color(0xff808080),
                        )),
                  )
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ClipRRect(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    //height: MediaQuery.of(context).size.height,
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
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const SvgIcon(
                            icon: SvgIconData(
                                'assets/icons/icon_paying_by_redict.svg'),
                            size: 35,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: const Text(
                              'Thanh toán trực tiếp khi nhận hàng.',
                              style: TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Color(0xff303030)),
                            ),
                          )
                        ],
                      ),
                      // child: const Text(
                      //   'Chọn phương thức thanh toán',
                      //   style: TextStyle(
                      //       fontFamily: 'NunitoSans',
                      //       fontWeight: FontWeight.w700,
                      //       fontSize: 16,
                      //       color: Color(0xff303030)),
                      // ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 20),
                    child: const Text(
                      'Phương thức vận chuyển',
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xff909090)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10, top: 20),
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectShip()));
                        },
                        icon: const SvgIcon(
                          icon: SvgIconData('assets/icons/icon_edit.svg'),
                          color: Color(0xff808080),
                        )),
                  )
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ClipRRect(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    //height: MediaQuery.of(context).size.height,
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
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const SvgIcon(
                            icon: SvgIconData(
                                'assets/icons/icon_fast_delivery.svg'),
                            size: 35,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: const Text(
                              'Giao hàng nhanh (2-3 ngày)',
                              style: TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Color(0xff303030)),
                            ),
                          )
                        ],
                      ),
                      // child: const Text(
                      //   'Chọn phương thức thanh toán',
                      //   style: TextStyle(
                      //       fontFamily: 'NunitoSans',
                      //       fontWeight: FontWeight.w700,
                      //       fontSize: 16,
                      //       color: Color(0xff303030)),
                      // ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: ClipRRect(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    //height: MediaQuery.of(context).size.height,
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
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: const Text(
                                  'Đơn hàng:',
                                  style: TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Color(0xff808080)),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: Text(
                                  NumberFormat.currency(
                                          locale: 'vi_VN', symbol: '₫')
                                      .format(20000000),
                                  style: const TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: const Text(
                                  'Phí vận chuyển:',
                                  style: TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Color(0xff808080)),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: Text(
                                  NumberFormat.currency(
                                          locale: 'vi_VN', symbol: '₫')
                                      .format(20000),
                                  style: const TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: const Text(
                                  'Tổng cộng:',
                                  style: TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Color(0xff808080)),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: Text(
                                  NumberFormat.currency(
                                          locale: 'vi_VN', symbol: '₫')
                                      .format(20020000),
                                  style: const TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                              )
                            ],
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
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(340, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text('Đặt hàng',
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 20)),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemProduct(BuildContext context, int index) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 140,
        ),
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.all(10),
          child: Card(
            child: Image.asset(
              _listItem[index].urlImg,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 120,
          child: Text(
            _listItem[index].name,
            style: const TextStyle(
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xff606060)),
          ),
        ),
        Positioned(
          top: 50,
          left: 120,
          child: Text(
            NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                .format(_listItem[index].price),
            style: const TextStyle(
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xff303030)),
          ),
        ),
        Positioned(
          top: 10,
          right: 15,
          child: Text(
            'x${_listItem[index].quantity}',
            style: const TextStyle(
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xff303030)),
          ),
        ),
        Positioned(
            top: 110,
            right: 55,
            child: Center(
              child: Container(
                width: 250,
                height: 1,
                margin: const EdgeInsets.all(10),
                color: const Color(0xffE0E0E0),
              ),
            )),
      ],
    );
  }
}
