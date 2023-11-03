import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/local_store/db/shipping_address_handler.dart';
import 'package:furniture_mcommerce_app/models/localstore/shipping_address.dart';
import 'package:furniture_mcommerce_app/models/methodpayment.dart';
import 'package:furniture_mcommerce_app/models/methodshipping.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/add_shipping_address/add_shipping_address.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/add_shipping_address/shipping_address.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/select_pay/select_pay_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/select_ship/select_ship_screen.dart';
import 'package:intl/intl.dart';

import '../../../local_store/db/account_handler.dart';
import '../../../models/localstore/itemcart.dart';

// ignore: must_be_immutable
class PaymentScreen extends StatefulWidget {
  PaymentScreen({super.key, required this.list});

  List<ItemCart> list;

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return PaymentScreenState(list: list);
  }
}

class PaymentScreenState extends State<PaymentScreen> {
  PaymentScreenState({required this.list});
  List<ItemCart> list;

  Methodpayment _methodpayment = Methodpayment();
  Methodshinpping _methodshinpping = Methodshinpping();

  ShippingAddress? shippingAddress;

  @override
  void initState() {
    _getShippingAddressDefault();
    print('name: ${shippingAddress?.name}, address: ${shippingAddress?.address}');
    super.initState();
  }

  void _getShippingAddressDefault() async {
    String idUser = await AccountHandler.getIdUser();
    print(idUser);
    if(idUser.isEmpty) return;
    if(await ShippingAddressHandler.countItem(idUser) > 0){
      print('true');
      ShippingAddressHandler.getItemShippingAddressDefault(idUser).then((data) => {
        setState((){
          shippingAddress = data;
          print('${shippingAddress!.name} + ${shippingAddress!.sdt} + ${shippingAddress!.address} ');

        })
      });
    }

  }

  double totalOrder(){
    double total = 0;
    for(var item in list){
      total += item.price * item.quantity;
    }
    return total;
  }


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
            //lable: địa chỉ giao hàng và btn edit
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
                        onPressed: () async {
                            final resultShippingAddress = await Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(builder: (_) => const ShippingAddressScreen())
                            );
                            if(resultShippingAddress != null){
                              setState(() {
                                  shippingAddress = resultShippingAddress;
                              });
                            }
                            print('${shippingAddress!.name} + ${shippingAddress!.sdt} + ${shippingAddress!.address} ');
                        },
                        icon: const SvgIcon(
                            icon: SvgIconData('assets/icons/icon_edit.svg'))),
                  )
                ],
              ),
            ),
            //widget hiển thị địa chỉ
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
                          child: Text(
                           shippingAddress?.name == null ? 'Chọn địa chỉ giao hàng của bạn.'
                               : '${shippingAddress?.name} | ${shippingAddress?.sdt}',
                            style: const TextStyle(
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
                        shippingAddress?.address != null ? Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(
                            shippingAddress?.address ?? '',
                            style: const TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xff808080)),
                          ),
                        ) : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //lable: danh sách sản phẩm
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
            //Widget danh sách sản phẩm
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
                        itemCount: list.length,
                      )),
                ),
              ),
            ),
            //lable: mã giảm giá và btn edit
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
            //Widget hiển thị giảm giá
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
            //lable: phương thức thanh toán và btn edit
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
                        onPressed: () async {
                         final resultPayment = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const SelectPay())
                         );
                         if(resultPayment != null){
                            setState(() {
                              _methodpayment = resultPayment as Methodpayment;
                            });
                            print('${_methodpayment.idPayment} + ${_methodpayment.namePayment} + ${_methodpayment.iconPayment}');
                         }
                        },
                        icon: const SvgIcon(
                          icon: SvgIconData('assets/icons/icon_edit.svg'),
                          color: Color(0xff808080),
                        )),
                  )
                ],
              ),
            ),
            //Widget hiển thị phương thức thanh toán
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
                          _methodpayment.iconPayment == null ? const SizedBox()
                              : SvgIcon(
                                  icon: SvgIconData(
                                      _methodpayment.iconPayment ?? ''),
                                  size: 35,
                                ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Text(
                              _methodpayment.namePayment ?? 'Chọn phương thức thanh toán.',
                              style: const TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: Color(0xff303030)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //lable: phương thức vận chuyển và btn edit
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
                        onPressed: () async {
                          final resultShipping = await Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const SelectShip())
                          );
                          if(resultShipping != null){
                            setState(() {
                              _methodshinpping = resultShipping as Methodshinpping;
                            });
                            print('${_methodshinpping.idShipment} + ${_methodshinpping.nameShipment} + ${_methodshinpping.iconShipment}');
                          }
                        },
                        icon: const SvgIcon(
                          icon: SvgIconData('assets/icons/icon_edit.svg'),
                          color: Color(0xff808080),
                        )),
                  )
                ],
              ),
            ),
            //Widget hiển thị phương thức vận chuyển
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
                          _methodshinpping.iconShipment == null ? const SizedBox()
                              : SvgIcon(
                                  icon: SvgIconData(
                                      _methodshinpping.iconShipment ?? ''),
                                  size: 35,
                                ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Text(
                              _methodshinpping.nameShipment ?? 'Chọn phương thức vận chuyển.',
                              style: const TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Color(0xff303030)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //Widget hiển thị thanh toán
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
                                      .format(totalOrder()),
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
                                      .format(_methodshinpping.fee ?? 0),
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
                                      .format(
                                            _methodshinpping.fee == null ? totalOrder()
                                                : (totalOrder() + _methodshinpping.fee!.toDouble())),
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
            //Widget nút thanh toán
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
                  onPressed: () {
                    showAlertDialog(context);
                    //Navigator.of(context).pop(context);
                  },
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
            child: Image.network(
              list[index].urlImg,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 120,
          child: SizedBox(
            width: 200,
            child: Text(
              list[index].name,
              style: const TextStyle(
                  fontFamily: 'NunitoSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xff606060)),
              softWrap: true,
              overflow: TextOverflow.clip,
            ),
          ),
        ),
        Positioned(
          top: 80,
          left: 120,
          child: Text(
            NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                .format(list[index].price),
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
            'x${list[index].quantity}',
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

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Thông báo đặt hàng"),
      content: Text("Đã đặt hàng thành công."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
