import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/controllers/category_controller.dart';
import 'package:furniture_mcommerce_app/models/category.dart';
import 'package:furniture_mcommerce_app/views/screens/home_screen/product_item.dart';
import 'package:provider/provider.dart';

import '../../../controllers/product_controller.dart';
import '../../../local_store/db/account_handler.dart';
import '../../../models/product.dart';
import '../../../models/states/provider_itemcart.dart';
import '../../../shared_resources/share_string.dart';
import '../cart_screen/cart_screen.dart';
import '../login_screen/login_screen.dart';

// ignore: must_be_immutable
class ProductSearch extends StatefulWidget {
  ProductSearch({super.key, required this.search, required this.idcatParent, required this.nameRoom});
  String search;
  String idcatParent;
  String nameRoom;

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return ProductSearchState(search: search, idcatParent: idcatParent, nameRoom: nameRoom);
  }
}

class ProductSearchState extends State<ProductSearch> {
  ProductSearchState({required this.search, required this.idcatParent, required this.nameRoom});
  String search;
  String idcatParent;
  String nameRoom;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const double _endReachedThreshold = 200;
  final List<Product> _products = [];
  final List<Category> _category = [];
  final List<String> _listCategory = [];
  bool _loading = true;
  bool _canLoadMore = false;
  int _page = 1;
  final int _limit = 20;
  late int _totalPage;

  String maxprice = '1000000000';
  String minprice = '0';
  String nameroom = '';
  String category = '';
  String price = '0-1000000000';

  String selectPrice = '';
  String rat = '0.0';

  @override
  void initState() {
    if(nameRoom.isNotEmpty) nameroom = nameRoom;
    _controller.addListener(_onScroll);
    _getProducts();
    _getListCategory();
    super.initState();
  }

  final ScrollController _controller = ScrollController();

  void _getProducts() {
    _loading = true;
    ProductController.fetchSearchListProduct(_page, _limit, search, category, nameroom, '$minprice-$maxprice', idcatParent, rat).then((dataFormServer) => {
      if(dataFormServer.errCode == 0){
        setState(() {
          _totalPage = dataFormServer.totalPage!;
          _products.addAll(dataFormServer.products as Iterable<Product>);
          _loading = false;
          if(dataFormServer.totalPage! > 1){
            _canLoadMore = true;
          }
          for(var item in dataFormServer.products!){
              if(!_listCategory.contains(item.nameCat)){
                  _listCategory.add(item.nameCat!);
              }
          }
        })
      }
      else{
          showDialogBox("Thông báo", dataFormServer.errMessage!, ShareString.CLOSE_DIALOG)
      }
    });
  }

  void _getListCategory() {
      CategoryController.fetchListCategory(search, idcatParent, nameRoom).then((dataFormServer) => {
          setState((){
              _category.addAll(dataFormServer.categorys!);
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
        key: _scaffoldKey,
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
            _buildIconCart(context),
            IconButton(
              icon: const SvgIcon(
                icon: SvgIconData('assets/icons/icon_filter.svg'),
                responsiveColor: false,
                color: Color(0xff303030),
                size: 24,
              ),
              onPressed: () {
                // Mở Drawer khi nút được nhấn
                _scaffoldKey.currentState?.openEndDrawer();
              },
            )
          ],
        ),
        endDrawer: Drawer(
          // Đặt nội dung của Drawer ở đây
          child: _buildFilter(context)
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            controller: _controller,
            slivers: [
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

  Widget _buildFilter(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
              'Bộ lọc sản phẩm',
              style: TextStyle(
                  fontFamily: 'Gelasio',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xff303030))),
            automaticallyImplyLeading: false,
        ),
        body: Container(
          color: Colors.white,
          child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: const Text(
                      "Danh mục",
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xff303030)
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                        return GestureDetector(
                            onTap: ()  {
                              setState((){
                                category == _listCategory[index] ? category = '' :
                                category = _listCategory[index];
                              });
                            },
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                color:  category == _listCategory[index] ? Colors.black : const Color(0xffE8E8E8),
                                child: Text(
                                  _listCategory[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: category == _listCategory[index] ? Colors.white : const Color(0xff303030)),
                                )));},
                        childCount: _listCategory.length),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2/0.5
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, top: 30),
                    child: const Text(
                      "khoảng giá(đ)",
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xff303030)
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 50,
                                child: TextField(
                                    onChanged: (value){
                                      setState(() {
                                        minprice = value;
                                      });
                                    },
                                    onSubmitted: (String value){
                                      setState(() {
                                        minprice = value;
                                      });
                                    },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: Color(0xff242424))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: Color(0xff242424), width: 1.0)),
                                    hintText: 'TỐI THIỂU',
                                    hintStyle: const TextStyle(
                                        fontFamily: 'Nunito Sans',
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xffE0E0E0),
                                        fontSize: 16),

                                  ))),
                              Container(
                                width: 20,
                                height: 1,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                  width: 100,
                                  height: 50,
                                  child: TextField(
                                      onChanged: (value){
                                          setState(() {
                                            maxprice = value;
                                          });
                                      },
                                      onSubmitted: (String value){
                                        setState(() {
                                          maxprice = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5),
                                            borderSide: const BorderSide(
                                                color: Color(0xff242424))),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5),
                                            borderSide: const BorderSide(
                                                color: Color(0xff242424), width: 1.0)),
                                        hintText: '    TỐI ĐA',
                                        hintStyle: const TextStyle(
                                            fontFamily: 'Nunito Sans',
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xffE0E0E0),
                                            fontSize: 16),

                                      ))),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                      setState(() {
                                          minprice = '0';
                                          maxprice = '10000000';
                                          selectPrice = '0-10000000';
                                      });
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      color:  selectPrice == '0-10000000' ? Colors.black : const Color(0xffE8E8E8),
                                      child: Text(
                                          '0-10tr',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'NunitoSans',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18,
                                              color: selectPrice == '0-10000000' ? Colors.white : const Color(0xff303030))
                                      )
                                  ),
                                ),
                                GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        minprice = '10000000';
                                        maxprice = '20000000';
                                        selectPrice = '10000000-20000000';
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      color: selectPrice == '10000000-20000000' ? Colors.black : const Color(0xffE8E8E8),
                                      child: Text(
                                          '10tr-20tr',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'NunitoSans',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18,
                                              color: selectPrice == '10000000-20000000' ? Colors.white : const Color(0xff303030))
                                      )
                                  ),
                                ),
                                GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        minprice = '20000000';
                                        maxprice = '30000000';
                                        selectPrice = '20000000-30000000';
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      color: selectPrice == '20000000-30000000' ? Colors.black : const Color(0xffE8E8E8),
                                      child: Text(
                                          '20tr-30tr',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'NunitoSans',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18,
                                              color: selectPrice == '20000000-30000000' ? Colors.white : const Color(0xff303030))
                                      )
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                    )
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, top: 30),
                    child: nameRoom.isEmpty ? const Text(
                      "Loại phòng",
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xff303030)
                      ),
                    ) : const SizedBox(),
                  ),
                ),
                nameRoom.isEmpty ? SliverPadding(
                  padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: ()  {
                                      setState((){
                                        nameroom == _listRoom[index] ? nameroom = '' :
                                        nameroom = _listRoom[index];
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      color:  nameroom == _listRoom[index] ? Colors.black : const Color(0xffE8E8E8),
                                      child: Text(
                                        _listRoom[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'NunitoSans',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                            color: nameroom == _listRoom[index] ? Colors.white : const Color(0xff303030)),
                                    )));},
                        childCount: _listRoom.length),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 2/0.5

                    ),
                  ),
                ) : const SliverToBoxAdapter(),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, top: 30),
                    child: const Text(
                      "Đánh giá",
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xff303030)
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                      return GestureDetector(
                          onTap: ()  {
                            setState((){
                                rat = rating[index].toString();
                            });
                          },
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              color:  rat == rating[index].toString() ? Colors.black : const Color(0xffE8E8E8),
                              child: Text(
                                rating[index] == 5 ? '${rating[index]} sao' : 'Từ ${rating[index]} sao',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                    color: rat == rating[index].toString() ? Colors.white : const Color(0xff303030)),
                              )));},
                        childCount: rating.length),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 2/0.5

                    ),
                  ),
                ),
              ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: OutlinedButton(
                      onPressed: () {
                          setState(() {
                            category = '';
                            nameroom = '';
                            minprice = '0';
                            maxprice = '1000000000';
                            selectPrice = '';
                            rat = '0.0';
                            _products.clear();
                            _page = 1;
                            _canLoadMore = false;
                            print('$category + $nameroom + $minprice + $maxprice + $rat');
                          });
                          _getProducts();
                          _scaffoldKey.currentState?.closeEndDrawer();
                      },
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(40, 50),
                          side: const BorderSide(style: BorderStyle.solid, color: Colors.black, width: 1)
                      ),
                      child: const Text(
                        'Thiết lập lại',
                        style: TextStyle(
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      // ignore: avoid_print
                        onPressed: () async {
                          print('$category + $nameroom + $minprice + $maxprice');
                          setState(() {
                              _products.clear();
                              _page = 1;
                              _canLoadMore = false;
                          });
                          _getProducts();
                          _scaffoldKey.currentState?.closeEndDrawer();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(45, 50)),
                        child: const Text(
                          '  Áp dụng  ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        )),
                  ),
                  label: '')
            ],
        ),
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

List<String> _listRoom = [
  'Phòng khách',
  'Phòng ngủ',
  'Phòng ăn',
  'Phòng làm việc',
];

List<int> rating = [
  1,
  2,
  3,
  4,
  5
];
