import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/controllers/address_controller/product_controller.dart';
import 'package:furniture_mcommerce_app/models/product.dart';
import 'package:furniture_mcommerce_app/views/screens/home_screen/product_item.dart';
import 'package:furniture_mcommerce_app/views/screens/home_screen/list_category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  static const double _endReachedThreshold = 200;
  final List<Product> _products = [];
  bool _loading = true;
  bool _canLoadMore = true;
  int _page = 1;
  final int _limit = 20;
  late int _totalPage;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(_onScroll);
    _getProducts();

    super.initState();
  }

  void _getProducts() {
    _loading = true;
    ProductController.fetchListProduct(_page, _limit).then((dataFormServer) => {
      setState(() {
          _totalPage = dataFormServer.totalPage!;
          _products.addAll(dataFormServer.products as Iterable<Product>);
          _loading = false;
      })
    });
  }

  void _onScroll() {
    if (!_controller.hasClients || _loading){
      _canLoadMore = false;
      return;
    }

    final thresholdReached =
        _controller.position.extentAfter < _endReachedThreshold;

    if (thresholdReached) {
      if(_page < _totalPage){
        _page++;
        _getProducts();
      }
    }
  }

  Future<void> _refresh() async {
    _canLoadMore = true;
    _products.clear();
    _page = 1;
    _getProducts();
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
              icon: SvgIconData('assets/icons/icon_search.svg'),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
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
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: const Text(
                    'Danh mục',
                    style: TextStyle(
                        fontFamily: 'Gelasio',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xff242424)),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: ListCategoryWidget(),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: const Text(
                    'Hôm nay mua gì?',
                    style: TextStyle(
                        fontFamily: 'Gelasio',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xff242424)),
                  ),
                ),
              ),
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
