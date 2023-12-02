import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:flutter_stripe/flutter_stripe.dart'hide Card;
import 'package:furniture_mcommerce_app/controllers/discount_controller.dart';
import 'package:furniture_mcommerce_app/controllers/order_controller.dart';
import 'package:furniture_mcommerce_app/controllers/product_controller.dart';
import 'package:furniture_mcommerce_app/local_store/db/itemcart_handler.dart';
import 'package:furniture_mcommerce_app/local_store/db/shipping_address_handler.dart';
import 'package:furniture_mcommerce_app/models/ItemOrder.dart';
import 'package:furniture_mcommerce_app/models/discount.dart';
import 'package:furniture_mcommerce_app/models/localstore/shipping_address.dart';
import 'package:furniture_mcommerce_app/models/methodpayment.dart';
import 'package:furniture_mcommerce_app/models/methodshipping.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/add_shipping_address/add_shipping_address.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/add_shipping_address/shipping_address.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/order_success_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/select_discount/select_discount_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/select_pay/select_pay_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/select_ship/select_ship_screen.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../local_store/db/account_handler.dart';
import '../../../models/localstore/itemcart.dart';
import '../../../models/states/provider_itemcart.dart';
import '../../../shared_resources/share_method.dart';
import '../../../shared_resources/share_string.dart';
import '../login_screen/login_screen.dart';

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
  List<ItemOrder> itemorders = [];
  bool validDiscount = false;
  bool statusPayment = false;
  double _totalOrder = 0;
  double _totalProductPrice = 0;

  Methodpayment _methodpayment = Methodpayment();
  Methodshinpping _methodshinpping = Methodshinpping();
  Discount  _discount = Discount();
  ShippingAddress? shippingAddress;

  Map<String, dynamic>? paymentIntent;
  var clientKey = dotenv.env["ClientKey"] ?? "";

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent(_totalOrder.toInt().toString(), 'VND');

      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          applePay: null,
          googlePay: null,
          style: ThemeMode.light,
          merchantDisplayName: 'SomeMerchantName',
        ),
      )
          .then((value) {
        log("Success");
        });

      displayPaymentSheet(); // Payment Sheet
    } catch (e, s) {
      String ss = "exception 1 :$e";
      String s2 = "reason :$s";
      log("exception 1:$e");
    }
  }


  displayPaymentSheet() async {
    //final ItemCartState = Provider.of<ProviderItemCart>(context, listen: true);
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                    Text("Thanh toán thành công"),
                  ],
                ),
              ],
            ),
          ),
        );

          statusPayment = true;
          OrderController.createOrder(
              _methodshinpping.idShipment!,
              shippingAddress!.idUser,
              _methodpayment.idPayment!,
              shippingAddress!.name,
              shippingAddress!.sdt,
              shippingAddress!.address,
              _totalOrder,
              statusPayment,
              itemorders).then((dataFormServer) => {
            if(dataFormServer.errCode == 0){
              ItemCartHandler.deleteAll(),
              //ItemCartState.reloadCountItemCart(),
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OrderSuccessScreen()))
            }else{
              showDialogBox('Thông báo', dataFormServer.errMessage!, ShareString.CLOSE_DIALOG),
            }
          });

        paymentIntent = null;
      }).onError((error, stackTrace) {
        String ss = "exception 2 :$error";
        String s2 = "reason :$stackTrace";
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      String ss = "exception 3 :$e";
    } catch (e) {
      log('$e');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount));
    return calculatedAmout.toString();
  }

  createPaymentIntent(String amount, String currency) async {
    try {

      // TODO: Request body
      Map<String, dynamic> body = {
        'amount':calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      // TODO: POST request to stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $clientKey', //SecretKey used here
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      log('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      log('err charging user: ${err.toString()}');
    }
  }

  @override
  void initState() {
    _getShippingAddressDefault();
    totalOrder();
    checkQuantityProduct();
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

  void totalOrder(){
    for(var item in list){
      _totalProductPrice += item.price * item.quantity;
    }
    _totalOrder = _totalProductPrice;
  }

  void checkQuantityProduct() async {
    ItemOrder itemorder;
    for(var item in list) {
      ProductController.checkQuantityProduct(item.idProduct, item.quantity)
          .then((dataFromServer) =>
      {
        if(dataFromServer.errCode == 0){
          itemorder =
              ItemOrder(idProduct: item.idProduct, numProduct: item.quantity),
          itemorders.add(itemorder)
        }else{
          showDialogBox('Thông báo', '${item.name} đã hết hàng.',
              ShareString.CLOSE_DIALOG),
        }
      });
    }
}


  @override
  Widget build(BuildContext context) {
    final ItemCartState = Provider.of<ProviderItemCart>(context, listen: true);
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
                              _totalOrder += resultShipping.fee!;
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
                                      .format(_totalProductPrice),
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
                                            _methodshinpping.fee == null ? _totalOrder
                                                : (_totalOrder + _methodshinpping.fee!.toDouble())),
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
                  onPressed: () async {
                    if (await ShareMethod.checkInternetConnection(context)) {
                      if(shippingAddress == null){
                        showDialogBox('Thông báo', 'Bạn phải thêm địa chỉ giao hàng.', ShareString.CLOSE_DIALOG);
                        return;
                      }

                      if(_methodshinpping.idShipment == null){
                        showDialogBox('Thông báo', 'Bạn phải chọn phương thức vận chuyển.', ShareString.CLOSE_DIALOG);
                        return;
                      }

                      if(_methodpayment.idPayment == null){
                        showDialogBox('Thông báo', 'Bạn phải chọn phương thức thanh toán.', ShareString.CLOSE_DIALOG);
                        return;
                      }
                      //Tạo danh sách sản phẩm orders

                      if(itemorders.length != list.length){
                        showDialogBox('Thông báo', 'có một sản phẩm đã hết hàng. Vui lòng kiểm tra lại.',
                            ShareString.CLOSE_DIALOG);
                        return;
                      }
                      if(_methodpayment.idPayment == 'PM1'){
                        //Thanh toán trực tiếp
                        OrderController.createOrder(
                            _methodshinpping.idShipment!,
                            shippingAddress!.idUser,
                            _methodpayment.idPayment!,
                            shippingAddress!.name,
                            shippingAddress!.sdt,
                            shippingAddress!.address,
                            _totalOrder,
                            statusPayment,
                            itemorders).then((dataFormServer) => {
                          if(dataFormServer.errCode == 0){
                            ItemCartHandler.deleteAll(),
                            ItemCartState.reloadCountItemCart(),
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OrderSuccessScreen()))
                          }else{
                            showDialogBox('Thông báo', dataFormServer.errMessage!, ShareString.CLOSE_DIALOG),
                          }
                        });
                      }
                      else if(_methodpayment.idPayment == 'PM2'){
                        //Thanh toán qua thẻ tín dụng
                        makePayment();
                      }
                    }else{
                      showDialogBox("Lỗi kết nối mạng", 'Không có kết nối mạng. Hãy kiểm tra lại kết nối của bạn!', ShareString.CLOSE_DIALOG);
                    }

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

  void showDialogBox(String title, String message, String action) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
                fontFamily: 'Merriweather',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Color(0xff303030)),
          ),
          content: Text(
            message,
            style: const TextStyle(
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Color(0xff303030)),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  if(action == ShareString.CLOSE_DIALOG){
                    Navigator.pop(context);
                  }
                  else if(action == ShareString.PUSH_LOGIN){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  }
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                      fontFamily: 'NunitoSans',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xff303030)),
                ))
          ],
        ));
  }
}
