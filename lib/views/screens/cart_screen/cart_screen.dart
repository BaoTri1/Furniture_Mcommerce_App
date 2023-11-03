import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/controllers/product_controller.dart';
import 'package:furniture_mcommerce_app/local_store/db/itemcart_handler.dart';
import 'package:furniture_mcommerce_app/models/states/provider_itemcart.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/payment_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/product_screen/product_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../local_store/db/account_handler.dart';
import '../../../models/localstore/itemcart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return CartScreenState();
  }
}

class CartScreenState extends State<CartScreen> {

  late List<ItemCart> _list = [];
  late String idUser;
  int quantity = 1;
  double total = 0;

  @override
  void initState() {
    _getListItemCart();
    super.initState();
  }

  void _getListItemCart() async {
    idUser = await AccountHandler.getIdUser();
    if(idUser.isEmpty) return;
    ItemCartHandler.getListItemCart(idUser).then((list) => {
      setState((){
        _list.addAll(list);
      }),
      for (var item in list) {
          total += (item.price * item.quantity)
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemCartState = Provider.of<ProviderItemCart>(context, listen: true);
    return MaterialApp(
      title: 'Cart Screen',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'Giỏ hàng',
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
          body: itemCartState.getCountItemCart > 0
              ? Stack(
                  children: [
                    CustomScrollView(
                      slivers: [
                        SliverList.builder(
                          itemBuilder: _buildItemCart,
                          itemCount: _list.length,
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            width: 70,
                            height: 100,
                          ),
                        )
                      ],
                    ),
                    Align(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            //margin: const EdgeInsets.only(bottom: 30),
                            children: [
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Tổng cộng:',
                                  style: TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Color(0xff808080)),
                                ),
                                Text(
                                  NumberFormat.currency(
                                          locale: 'vi_VN', symbol: '₫')
                                      .format(total),
                                  style: const TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Color(0xff303030)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(334, 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              child: const Text('Thanh toán',
                                  style: TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PaymentScreen(list: _list,)));
                              },
                            ),
                          ),
                        ]))
                  ],
                )
              : _buildNoteNoItem(context)),
    );
  }

  Widget _buildItemCart(BuildContext context, int index) {
    final itemCartState = Provider.of<ProviderItemCart>(context, listen: false);
    return GestureDetector(
      // onTap: () {
      //   Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      //       builder: (_) => ProductScreen(
      //             name: _listItem[index].name,
      //           )));
      // },
      child: Stack(
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
                _list[index].urlImg,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 120,
            child: SizedBox(
              width: 220,
              child: Text(
                _list[index].name,
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
            top: 60,
            left: 120,
            child: Text(
              NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                  .format(_list[index].price),
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
              child: IconButton(
                icon: const SvgIcon(
                    icon: SvgIconData('assets/icons/icon_delete.svg')),
                onPressed: () {
                  ItemCartHandler.deleteItemCart(_list[index].idProduct, idUser);
                  setState(() {
                    total -=
                        (_list[index].price * _list[index].quantity);
                    _list.removeAt(index);
                  });
                  itemCartState.reloadCountItemCart();
                },
              )),
          Positioned(
            top: 85,
            left: 100,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      size: 30,
                      color: Color(0xff808080),
                    ),
                    onPressed: () {
                      if (_list[index].quantity == 1) {
                        return;
                      }
                      ItemCartHandler.updateQuantityItemCart(
                          _list[index].idProduct,
                          idUser,
                          _list[index].quantity - 1
                      );
                      setState(() {
                        _list[index].quantity =
                            _list[index].quantity - 1;
                        total -= _list[index].price;
                      });
                    },
                  )),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Text(
                  _list[index].quantity.toString(),
                  style: const TextStyle(
                      fontFamily: 'Gelasio',
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: Color(0xff303030)),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      size: 30,
                      color: Color(0xff808080),
                    ),
                    onPressed: () {
                      ProductController.checkQuantityProduct(_list[index].idProduct, _list[index].quantity + 1)
                          .then((dataFormServer) => {
                            if(dataFormServer.errCode == 0){
                                ItemCartHandler.updateQuantityItemCart(
                                    _list[index].idProduct,
                                    idUser,
                                    _list[index].quantity + 1
                                ),
                                setState(() {
                                  _list[index].quantity =
                                      _list[index].quantity + 1;
                                  total += _list[index].price;
                                })
                            }else{
                              showDialogBox('Thông báo', dataFormServer.errMessage!)
                            }
                      });
                    },
                  )),
            ]),
          ),
          Positioned(
              top: 125,
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
      ),
    );
  }

  Widget _buildNoteNoItem(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.all(10),
            width: 100,
            height: 100,
            child: const SvgIcon(
                icon: SvgIconData('assets/icons/icon_shopping-cart.svg'))),
        Container(
          margin: EdgeInsets.all(20),
          child: const Text(
            'Không có nào sản phẩm trong giỏ hàng. Hãy mua sắm đi nào...',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Gelasio',
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: Color(0xff242424)),
          ),
        ),
      ],
    );
  }

  void showDialogBox(String title, String message) {
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
                onPressed: () {
                  Navigator.pop(context);
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
