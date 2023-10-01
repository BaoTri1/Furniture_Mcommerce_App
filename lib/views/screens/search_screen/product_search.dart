import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/views/screens/home_screen/product_item.dart';
import 'package:furniture_mcommerce_app/views/screens/home_screen/list_category.dart';

import '../../../models/product.dart';

class ProductSearch extends StatefulWidget {
  const ProductSearch({super.key});

  @override
  State<StatefulWidget> createState() {
    return ProductSearchState();
  }
}

class ProductSearchState extends State<ProductSearch> {
  static const double _endReachedThreshold = 200;
  final List<Product> _products = [];
  bool _loading = true;
  bool _canLoadMore = true;

  @override
  void initState() {
    _controller.addListener(_onScroll);
    _getProducts();

    super.initState();
  }

  final ScrollController _controller = ScrollController();

  Future<void> _getProducts() async {
    _loading = true;
    final newProducts = await getProduct();
    setState(() {
      _products.addAll(newProducts);
    });
    _loading = false;
  }

  void _onScroll() {
    if (!_controller.hasClients || _loading) return;

    final thresholdReached =
        _controller.position.extentAfter < _endReachedThreshold;

    if (thresholdReached) {
      _getProducts();
    }
  }

  Future<void> _refresh() async {
    _canLoadMore = true;
    _products.clear();
    await _getProducts();
    print('Refreshing...');
  }

  Widget _buildProductItem(BuildContext context, int index) {
    return ProductItem(_products[index]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Screen',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'Make home\n',
                    style: TextStyle(
                        fontFamily: 'Gelasio',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color(0xff909090))),
                TextSpan(
                    text: 'BEAUTIFUL',
                    style: TextStyle(
                        fontFamily: 'Gelasio',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xff242424)))
              ])),
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
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            controller: _controller,
            slivers: [
              // SliverToBoxAdapter(
              //   child: Container(
              //     padding: const EdgeInsets.only(left: 10, top: 10),
              //     child: const Text(
              //       'Danh mục',
              //       style: TextStyle(
              //           fontFamily: 'Gelasio',
              //           fontWeight: FontWeight.w700,
              //           fontSize: 18,
              //           color: Color(0xff242424)),
              //     ),
              //   ),
              // ),
              // SliverToBoxAdapter(
              //   child: Container(
              //     padding: const EdgeInsets.only(left: 10, top: 10),
              //     child: const Text(
              //       'Hôm nay mua gì?',
              //       style: TextStyle(
              //           fontFamily: 'Gelasio',
              //           fontWeight: FontWeight.w700,
              //           fontSize: 18,
              //           color: Color(0xff242424)),
              //     ),
              //   ),
              // ),
              SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(_buildProductItem,
                      childCount: _products.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 4 / 6,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _canLoadMore
                    ? Container(
                        padding: const EdgeInsets.only(bottom: 16),
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
