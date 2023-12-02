// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:furniture_mcommerce_app/local_store/db/itemcart_handler.dart';
import 'package:furniture_mcommerce_app/models/localstore/itemcart.dart';
import 'package:furniture_mcommerce_app/models/localstore/itemfavorite.dart';
import 'package:furniture_mcommerce_app/models/rating.dart';
import 'package:furniture_mcommerce_app/models/states/provider_itemcart.dart';
import 'package:furniture_mcommerce_app/views/screens/login_screen/login_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/product_screen/zoom_image.dart';
import 'package:furniture_mcommerce_app/views/screens/rating_screen/rating_screen.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/controllers/product_controller.dart';
import 'package:furniture_mcommerce_app/models/product.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:lottie/lottie.dart';

import '../../../controllers/ratingandreview_controller.dart';
import '../../../local_store/db/account_handler.dart';
import '../../../local_store/db/itemfavorite_handler.dart';
import '../../../models/states/provider_itemfavorite.dart';
import '../../../shared_resources/share_string.dart';
import '../cart_screen/cart_screen.dart';
import '../home_screen/product_item.dart';

// ignore: must_be_immutable
class ProductScreen extends StatefulWidget {
  ProductScreen({super.key, required this.id, required this.nameCategory});
  String id;
  String nameCategory;

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return ProductScreenState(id: id, nameCategory: nameCategory);
  }
}

class ProductScreenState extends State<ProductScreen> with TickerProviderStateMixin {
  ProductScreenState({required this.id, required this.nameCategory});
  String id;
  String nameCategory;

  final ScrollController _controller = ScrollController();
  late final AnimationController _controllerAnimation;
  static const double _endReachedThreshold = 200;
  bool _loading = true;
  bool _canLoadMore = true;
  bool _showAnimationAddToCart = false;
  bool _showAnimationAddToFavorite = false;

  bool _enabled = true;
  late Product _product = Product();
  late final List<Product> _listProductSimilar = [];
  late List<String> listImage = [];
  late Ratings ratings = Ratings();
  late PageController _pageController;
  int page = 1;
  int limit = 10;
  late int totalPage;
  int activePage = 0;
  int quantity = 1;

  late ItemFavorite itemFavorite;
  late String idUser;
  bool _isFavorite = false;

  late ItemCart itemCart;

  double _scale = 1.0;

  @override
  void initState() {
    _controller.addListener(_onScroll);
    _controllerAnimation = AnimationController(vsync: this);
    _pageController = PageController(viewportFraction: 1.0, initialPage: 0);
    _getInfoProduct();
    _getSimilarProducts();
    _checkItemFavorite();
    _getRating();
    super.initState();
  }


  @override
  void dispose() {
    _controller.dispose();
    _controllerAnimation.dispose();
    super.dispose();
  }

  void _checkItemFavorite() async {
      idUser = await AccountHandler.getIdUser();
      if(idUser.isEmpty) return;
      if(await ItemFavoriteHandler.checkItemFavorite(id, idUser)){
        _isFavorite = true;
      }
  }

  void _getRating() {
    RatingAndReviewController.fetchRating(id).then((dataFormServer) => {
        if(dataFormServer.errCode == 0){
            setState((){
                ratings = dataFormServer.ratings!;
            })
        }
    });
  }

  void _getInfoProduct() {
    ProductController.fetchProduct(id).then((dataFormServer) => {
      setState(() {
        _product = dataFormServer.product!;
        listImage.add(dataFormServer.product!.imgUrl!);
        for (var detailImg in dataFormServer.product!.listImageDetail!) {
          listImage.add(detailImg.imgUrl!);
        }
        _enabled = !_enabled;
      })
    });
  }

  void _getSimilarProducts() {
    _loading = true;
    ProductController.fetchListSimilarProduct(page, limit, nameCategory).then((dataFromServer) => {
      setState((){
        _listProductSimilar.addAll(dataFromServer.products as Iterable<Product>);
        totalPage = dataFromServer.totalPage!;
        for(int i = 0; i < _listProductSimilar.length; i++){
          if(_listProductSimilar[i].idProduct == id){
            _listProductSimilar.removeAt(i);
          }
        }
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
      if(page < totalPage){
        page++;
        _getSimilarProducts();
      }
    }
  }

  Future<void> _refresh() async {
    _enabled = !_enabled;
    _canLoadMore = true;
    listImage.clear();
    _listProductSimilar.clear();
    page = 1;
    _getInfoProduct();
    _getSimilarProducts();
    _getRating();
    print('Refreshing...');
  }


  Widget _buildProductItem(BuildContext context, int index) {
    return ProductItem(_listProductSimilar[index]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Screen',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: Stack(
            children: [
              Skeletonizer(
                enabled: _enabled,
                child: CustomScrollView(
                  controller: _controller,
                  slivers: [
                    SliverAppBar(
                        leading: IconButton(
                          icon: const SvgIcon(
                            icon: SvgIconData('assets/icons/icon_back.svg'),
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context, _product);
                          },
                        ),
                        actions: [
                          _buildIconCart(context)
                        ],
                        backgroundColor: Colors.white,
                        expandedHeight: 300.0,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          background: GestureDetector(
                            onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ZoomImage(listImg: listImage,)));
                            },
                            child: Column(
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                    child: PageView.builder(
                                      itemCount: listImage.length,
                                      pageSnapping: true,
                                      controller: _pageController,
                                      itemBuilder: (context, pagePosition) {
                                        return Container(
                                            width: MediaQuery.of(context).size.width,
                                            //margin: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                //color: Colors.amber,
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        listImage[pagePosition]),
                                                    fit: BoxFit.contain)));
                                      },
                                    )),
                                const SizedBox(
                                  width: 10,
                                  height: 10,
                                ),
                                listImage.isEmpty ?
                                 const SizedBox(
                                  width: 10,
                                  height: 10,
                                ) : SmoothPageIndicator(
                                  controller: _pageController,
                                  count: listImage.length,
                                  effect: const ExpandingDotsEffect(
                                      dotHeight: 2,
                                      dotWidth: 6,
                                      dotColor: Color(0xff999999),
                                      activeDotColor: Color(0xff303030)),
                                ),
                              ],
                            ),
                          ),
                        )),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Text(
                          _product.nameProduct ?? '',
                          style: const TextStyle(
                              fontFamily: 'Gelasio',
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              color: Color(0xff303030)),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Text(
                              NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                                  .format(_product.value == null ? _product.price ?? 0
                                  : (_product.price! - (_product.price!*(_product.value!/100.0)))),
                              style: TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30,
                                  color: _product.value == null ? const Color(0xff303030) : Colors.red),
                            ),
                            _product.value == null ? const SizedBox()
                                : Container(
                                    margin: const EdgeInsets.only(left:  20),
                                    child: Text(
                                      '-${_product.value}%',
                                      style: const TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
                                        color: Color(0xff303030)),
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: _product.value == null ? const SizedBox() : Text(
                          NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                              .format(_product.price),
                          style: const TextStyle(
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            color: Color(0xff303030),
                            decoration: TextDecoration.lineThrough,
                            decorationThickness: 1.5,),
                        )
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      RatingScreen(imgUrl: _product.imgUrl!,
                                        idProduct: id, nameProduct: _product.nameProduct!)));
                              // if(ratings.numReviews! > 0){
                              //     Navigator.push(context,
                              //         MaterialPageRoute(builder: (context) =>
                              //             RatingScreen(rating: ratings, imgUrl: _product.imgUrl!, idProduct: id,)));
                              // }
                            },
                            child: ratings.numReviews == 0 ? Container(
                              margin:
                              const EdgeInsets.only(top: 4, left: 4, right: 30),
                              child: const Text(
                                '(Chưa có đánh giá)',
                                style: TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Color(0xff808080)),
                              ),
                            ) : Row(children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 30,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      ratings.aVGPoint ?? '',
                                      style: const TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: Color(0xff303030)),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.only(top: 4, left: 4, right: 30),
                                    child: Text(
                                      '(${ratings.numReviews ?? ''} đánh giá)',
                                      style: const TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: Color(0xff808080)),
                                    ),
                                  ),
                            ]),
                          ),
                          //Nút tang giam so luong
                          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                            Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    size: 30,
                                    color: Color(0xff303030),
                                  ),
                                  onPressed: () {
                                    if (quantity == 1) {
                                      return;
                                    }
                                    setState(() {
                                      quantity--;
                                    });
                                  },
                                )),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Text(
                                quantity.toString(),
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
                                    color: Color(0xff303030),
                                  ),
                                  onPressed: () {
                                    quantity++;
                                    ProductController.checkQuantityProduct(id, quantity).then((dataFormServer) => {
                                      if(dataFormServer.errCode != 0){
                                        showDialogBox("Thông báo", dataFormServer.errMessage!, ShareString.CLOSE_DIALOG),
                                      }else {
                                        setState(() {
                                          quantity;
                                        })
                                      }
                                    });
                                  },
                                )),
                          ]),
                        ],
                      ),
                    )),
                    SliverToBoxAdapter(
                      child: Container(
                          margin: const EdgeInsets.only(left: 10, top: 20),
                          child: Text('Kích thước: ${_product.size ?? ''}',
                              style: const TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Color(0xff606060)))),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                          margin: const EdgeInsets.only(left: 10, top: 20),
                          child: Text('Vật liệu: ${_product.material ?? ''}',
                              style: const TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Color(0xff606060)))),
                    ),
                    SliverToBoxAdapter(
                        child: Container(
                            margin: const EdgeInsets.only(left: 10, top: 20),
                            child: ExpandableText(
                              'Mô tả sản phẩm: \n${_product.description ?? ''}',
                              expandText: "Xem thêm",
                              collapseText: 'Thu gọn',
                              maxLines: 3,
                              style: const TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Color(0xff606060)),
                              linkColor: const Color(0xff242424),
                            ))),
                    SliverToBoxAdapter(
                      child: _listProductSimilar.isNotEmpty
                          ? Container(
                              margin: const EdgeInsets.all(10),
                              child: const Center(
                                child: Text(
                                  'Sản phẩm tương tự',
                                  style: TextStyle(
                                      fontFamily: 'Gelasio',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24,
                                      color: Color(0xff303030)),
                                ),
                              ),
                            )
                          : const SizedBox(
                              width: 70,
                              height: 50,
                            ),
                    ),
                    _listProductSimilar.isNotEmpty
                        ? SliverPadding(
                            padding: const EdgeInsets.all(10),
                            sliver: SliverGrid(
                              delegate: SliverChildBuilderDelegate(_buildProductItem,
                                  childCount: _listProductSimilar.length),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 4 / 6,
                              ),
                            ),
                          )
                        : const SliverToBoxAdapter(
                            child: SizedBox(
                              width: 70,
                              height: 50,
                            ),
                          ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        width: 70,
                        height: 100,
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
                ),),
              _buildPannelButton(context),
              _showAnimationAddToCart ?
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.6),
                    ],
                  )),
                child: Lottie.asset(
                    'assets/animations/addtocart_animation.json',
                    width: 100,
                    height: 100,
                    controller: _controllerAnimation,
                    onLoaded: (composition) {
                      _controllerAnimation
                        ..duration = composition.duration
                        ..reset()
                        ..forward().whenComplete(() => {
                            setState((){
                                _showAnimationAddToCart = !_showAnimationAddToCart;
                            })
                        });
                    },
                    alignment: const Alignment(0, 0)
                ),
              ),
            ) : const SizedBox(),
            _showAnimationAddToFavorite ?
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
                child: Lottie.asset(
                    'assets/animations/addtofavorite_animation.json',
                    controller: _controllerAnimation,
                    onLoaded: (composition) {
                      _controllerAnimation
                        ..duration = composition.duration
                        ..reset()
                        ..forward().whenComplete(() => {
                            setState((){
                                _showAnimationAddToFavorite = !_showAnimationAddToFavorite;
                            })
                        });
                    },
                    alignment: const Alignment(-1, 0.7)
                ),
              ),
            ) : const SizedBox()
          ],
          ),
        ),
      ),
    );
  }

  Widget _buildPannelButton(BuildContext context){
    final ItemFavoriteState = Provider.of<ProviderItemFavorite>(context, listen: true);
    final ItemCartState = Provider.of<ProviderItemCart>(context, listen: true);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xffF0F0F0),
              ),
              child: IconButton(
                  onPressed: () async {
                    if(await AccountHandler.checkIsLogin()){
                      if(!_isFavorite){
                        int newID = await ItemFavoriteHandler.lastIndex() + 1;
                        itemFavorite = ItemFavorite(
                            id: newID,
                            idUser: idUser,
                            idProduct: _product.idProduct!,
                            category: _product.nameCat!,
                            name: _product.nameProduct!,
                            price: _product.price!.toDouble(),
                            urlImg: _product.imgUrl!);
                        ItemFavoriteHandler.insertItemFavorite(itemFavorite);
                        setState(() {
                          _isFavorite = !_isFavorite;
                          _showAnimationAddToFavorite = !_showAnimationAddToFavorite;
                        });
                      }else{
                        ItemFavoriteHandler.deleteItemFavorite(id, idUser);
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                      }
                      ItemFavoriteState.reloadCountItemFavorite();
                    }else{
                      showDialogBox('Thông báo', 'Bạn cần đăng nhập để thực hiện chức năng này.', ShareString.PUSH_LOGIN);
                    }
                  },
                  icon: SvgIcon(
                      icon: SvgIconData(_isFavorite ? 'assets/icons/icon_mark_selected.svg' : 'assets/icons/icon_mark.svg'))),
            ),
            const SizedBox(
              width: 20,
              height: 20,
            ),
            Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(250, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text('Thêm vào giỏ hàng',
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 20)),
                      onPressed: () async {
                        if(await AccountHandler.checkIsLogin()){
                            int newID = await ItemCartHandler.lastIndex() + 1;
                            if(await ItemCartHandler.checkItemCart(_product.idProduct!, idUser)){
                                int oldQuantity = await ItemCartHandler.getQuantityProduct(_product.idProduct!, idUser);
                                int newQuantity = oldQuantity + quantity;
                                ProductController.checkQuantityProduct(_product.idProduct!, newQuantity).then((dataFormServer) => {
                                  if(dataFormServer.errCode != 0){
                                    showDialogBox("Thông báo", dataFormServer.errMessage!, ShareString.CLOSE_DIALOG),
                                  }else {
                                    ItemCartHandler.updateQuantityItemCart(_product.idProduct!, idUser, newQuantity),
                                    setState(() {
                                        _showAnimationAddToCart = !_showAnimationAddToCart;
                                    })
                                  }
                                });
                            }else{
                              ProductController.checkQuantityProduct(_product.idProduct!, quantity).then((dataFormServer) => {
                                if(dataFormServer.errCode != 0){
                                  showDialogBox("Thông báo", dataFormServer.errMessage!, ShareString.CLOSE_DIALOG),
                                }else {
                                  itemCart = ItemCart(
                                      id: newID,
                                      idUser: idUser,
                                      idProduct: _product.idProduct!,
                                      category: _product.nameCat!,
                                      name: _product.nameProduct!,
                                      price: _product.price!.toDouble(),
                                      quantity: quantity,
                                      urlImg: _product.imgUrl!),

                                  ItemCartHandler.insertItemCart(itemCart),
                                  setState(() {
                                    _showAnimationAddToCart = !_showAnimationAddToCart;
                                  }),
                                  ItemCartState.reloadCountItemCart()
                                }
                              });
                            }
                        }else{
                            showDialogBox('Thông báo', 'Bạn cần đăng nhập để thực hiện chức năng này.', ShareString.PUSH_LOGIN);
                        }
                      },
                )),
          ],
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