import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/models/test/product.dart';
import 'package:furniture_mcommerce_app/views/screens/product_screen/product_screen.dart';
import 'package:intl/intl.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return FavoritesScreenState();
  }
}

class FavoritesScreenState extends State<FavoritesScreen> {
  final List<Product> _products = [
    Product(
        name: 'Minimal Stand 1',
        price: 2000000.0,
        urlIamge: 'assets/images/img_product.png'),
    Product(
        name: 'Minimal Stand 2',
        price: 2000000.0,
        urlIamge: 'assets/images/img_product.png'),
    Product(
        name: 'Minimal Stand 3',
        price: 2000000.0,
        urlIamge: 'assets/images/img_product.png'),
    Product(
        name: 'Minimal Stand 4',
        price: 2000000.0,
        urlIamge: 'assets/images/img_product.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favorites Screen',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Sản phẩm yêu thích',
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
                  icon: SvgIconData('assets/icons/icon_cart.svg'),
                  responsiveColor: false,
                  color: Color(0xff808080),
                  size: 24,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                }),
          ],
        ),
        body: _products.isNotEmpty
            ? Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverList.builder(
                        itemBuilder: _buildItemFavorite,
                        itemCount: _products.length,
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
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(334, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: const Text('Thêm tất cả vào giỏ hàng',
                              style: TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18)),
                          onPressed: () {
                            setState(() {
                              _products.clear();
                            });
                          },
                        ),
                      ))
                ],
              )
            : _buildNoteNoItem(context),
      ),
    );
  }

  Widget _buildItemFavorite(BuildContext context, int index) {
    return GestureDetector(
      // onTap: () {
      //   Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      //       builder: (_) => ProductScreen(
      //             name: _products[index].name,
      //           )));
      // },
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 130,
          ),
          Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(10),
            child: Card(
              child: Image.asset(
                _products[index].urlIamge,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 120,
            child: Text(
              _products[index].name,
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
                  .format(_products[index].price),
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
                  print('$index');
                  setState(() {
                    _products.removeAt(index);
                  });
                },
              )),
          Positioned(
              top: 70,
              right: 20,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xff606060).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const SvgIcon(
                    icon: SvgIconData('assets/icons/icon_shoppingbag.svg'),
                    size: 24,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    print('da them vao gio hang');
                    setState(() {
                      _products.removeAt(index);
                    });
                  },
                ),
              )),
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
            'Không có sản phẩm yêu thích nào. Hãy mua sắm đi nào...',
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
