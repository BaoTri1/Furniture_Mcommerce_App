import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/models/item_cart.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/payment_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/product_screen/product_screen.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return CartScreenState();
  }
}

class CartScreenState extends State<CartScreen> {
  int quantity = 1;
  double total = 0;

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

  double _totalPrice() {
    _listItem.forEach((element) {
      total += (element.price * element.quantity);
    });
    return total;
  }

  @override
  void initState() {
    _totalPrice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          body: _listItem.isNotEmpty
              ? Stack(
                  children: [
                    CustomScrollView(
                      slivers: [
                        SliverList.builder(
                          itemBuilder: _buildItemCart,
                          itemCount: _listItem.length,
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
                                        builder: (context) => PaymentScreen()));
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
              child: IconButton(
                icon: const SvgIcon(
                    icon: SvgIconData('assets/icons/icon_delete.svg')),
                onPressed: () {
                  setState(() {
                    total -=
                        (_listItem[index].price * _listItem[index].quantity);
                    _listItem.removeAt(index);
                  });
                },
              )),
          Positioned(
            top: 70,
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
                      if (_listItem[index].quantity == 1) {
                        return;
                      }
                      setState(() {
                        _listItem[index].quantity =
                            _listItem[index].quantity - 1;
                        total -= _listItem[index].price;
                      });
                    },
                  )),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Text(
                  _listItem[index].quantity.toString(),
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
                      setState(() {
                        _listItem[index].quantity =
                            _listItem[index].quantity + 1;
                        total += _listItem[index].price;
                      });
                    },
                  )),
            ]),
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
}
