import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/controllers/product_controller.dart';
import 'package:furniture_mcommerce_app/local_store/db/account_handler.dart';
import 'package:furniture_mcommerce_app/models/product.dart';
import 'package:furniture_mcommerce_app/models/states/provider_itemcart.dart';
import 'package:furniture_mcommerce_app/views/screens/cart_screen/cart_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/home_screen/list_room.dart';
import 'package:furniture_mcommerce_app/views/screens/home_screen/product_item.dart';
import 'package:furniture_mcommerce_app/views/screens/home_screen/list_category.dart';
import 'package:furniture_mcommerce_app/views/screens/search_screen/search_screen.dart';
import 'package:provider/provider.dart';

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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
            },
          ),
          actions: [
            _buildIconCart(context)
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
                    'Nhóm danh mục',
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
                    'Loại phòng',
                    style: TextStyle(
                        fontFamily: 'Gelasio',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xff242424)),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child:  Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: const ListRoomWidget(),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(left: 10, top: 20),
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

  Widget _buildIconCart(BuildContext context) {
    final itemCartState = Provider.of<ProviderItemCart>(context, listen: true);
    return IconButton(
        padding: const EdgeInsets.only(right: 12),
        onPressed: () async {
          if(await AccountHandler.checkIsLogin()) {
            // ignore: use_build_context_synchronously
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CartScreen()));
          }
        },
        icon: Stack(children: [
            const SizedBox(
              width: 40,
              height: 30,
            ),
            const Positioned(
              top: 4,
              child: SvgIcon(
                icon: SvgIconData('assets/icons/icon_cart.svg'),
                responsiveColor: false,
                color: Color(0xff808080),
                size: 24,
              ),
            ),
            itemCartState.getCountItemCart > 0 ?
              Positioned(
                right: itemCartState.getCountItemCart > 99 ? 0: 6,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    itemCartState.getCountItemCart > 99 ?
                    '+99' : '${itemCartState.getCountItemCart}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
      )
                : const SizedBox()]),);
  }
}
