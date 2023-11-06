import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniture_mcommerce_app/local_store/db/account_handler.dart';
import 'package:furniture_mcommerce_app/local_store/db/itemfavorite_handler.dart';
import 'package:furniture_mcommerce_app/views/screens/product_screen/product_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../controllers/discount_controller.dart';
import '../../../controllers/product_controller.dart';
import '../../../local_store/db/itemcart_handler.dart';
import '../../../models/localstore/itemcart.dart';
import '../../../models/localstore/itemfavorite.dart';
import '../../../models/states/provider_itemcart.dart';
import '../../../models/states/provider_itemfavorite.dart';
import '../../../shared_resources/share_string.dart';
import '../cart_screen/cart_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return FavoritesScreenState();
  }
}

class FavoritesScreenState extends State<FavoritesScreen> {

  late List<ItemFavorite> _list = [];
  late String idUser;

  @override
  void initState() {
    _getListItemFavorite();
    super.initState();
  }

  void _getListItemFavorite() async {
    idUser = await AccountHandler.getIdUser();
    if(idUser.isEmpty) return;
    ItemFavoriteHandler.getListItemFavorites(idUser).then((list) => {
      // for(var item in list){
      //   print(item.price),
      //   DiscountController.checkDiscountValid(item.idProduct).then((data) => {
      //     if(data.errCode == 0){
      //       item.price = item.price - (item.price * (data.discounts![0].value!/100.0)),
      //       print(item.price),
      //     },
      //     setState((){
      //       _list.add(item);
      //     }),
      //   })
      // },
      setState((){
        _list.addAll(list);
      })
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ItemFavoriteState = Provider.of<ProviderItemFavorite>(context, listen: true);
    final itemCartState = Provider.of<ProviderItemCart>(context, listen: false);
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
            _buildIconCart(context)
          ],
        ),
        body: ItemFavoriteState.getCountItemFavorite > 0
            ? Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverList.builder(
                        itemBuilder: _buildItemFavorite,
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
                          onPressed: () async {
                              for(var item in _list){
                                print('da them vao gio hang');
                                int newID = await ItemCartHandler.lastIndex() + 1;
                                ItemCart itemCart;
                                if(await AccountHandler.checkIsLogin()){
                                  String idUser = await AccountHandler.getIdUser();
                                  if(await ItemCartHandler.checkItemCart(item.idProduct, idUser)){
                                    int oldQuantity = await ItemCartHandler.getQuantityProduct(item.idProduct, idUser);
                                    ProductController.checkQuantityProduct(item.idProduct, oldQuantity + 1).then((dataFormServer) => {
                                      if(dataFormServer.errCode != 0){
                                        showDialogBox("Thông báo", dataFormServer.errMessage!),
                                      }else {
                                        ItemCartHandler.updateQuantityItemCart(item.idProduct, idUser, oldQuantity + 1),
                                        ItemFavoriteHandler.deleteItemFavorite(item.idProduct, idUser),
                                        setState(() {
                                          _list.remove(item);
                                        }),
                                        Fluttertoast.showToast(msg: 'Đâ thêm sản phẩm vào giỏ hàng.', toastLength: Toast.LENGTH_SHORT),
                                        itemCartState.reloadCountItemCart(),
                                        ItemFavoriteState.reloadCountItemFavorite()
                                      }
                                    });
                                  }else{
                                    ProductController.checkQuantityProduct(item.idProduct, 1).then((dataFormServer) => {
                                      if(dataFormServer.errCode != 0){
                                        showDialogBox("Thông báo", dataFormServer.errMessage!),
                                      }else {
                                        itemCart = ItemCart(
                                            id: newID,
                                            idUser: idUser,
                                            idProduct: item.idProduct,
                                            category: item.category,
                                            name: item.name,
                                            price: item.price.toDouble(),
                                            quantity: 1,
                                            urlImg: item.urlImg),
                                        ItemCartHandler.insertItemCart(itemCart),
                                        ItemFavoriteHandler.deleteItemFavorite(item.idProduct, idUser),
                                        setState(() {
                                          _list.remove(item);
                                        }),
                                        Fluttertoast.showToast(msg: 'Đâ thêm sản phẩm vào giỏ hàng.', toastLength: Toast.LENGTH_SHORT),
                                        itemCartState.reloadCountItemCart(),
                                        ItemFavoriteState.reloadCountItemFavorite()
                                      }
                                    });
                                  }
                                }else{
                                  // ignore: use_build_context_synchronously
                                  showDialogBox('Thông báo', 'Bạn cần đăng nhập để thực hiện chức năng này.');
                                }
                              }
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
    final ItemFavoriteState = Provider.of<ProviderItemFavorite>(context, listen: true);
    final itemCartState = Provider.of<ProviderItemCart>(context, listen: true);
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (_) => ProductScreen(
                  id: _list[index].idProduct, nameCategory: _list[index].category,
                )));
      },
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
            top: 70,
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
                  ItemFavoriteHandler.deleteItemFavorite(_list[index].idProduct, idUser);
                  setState(() {
                    _list.removeAt(index);
                  });
                  ItemFavoriteState.reloadCountItemFavorite();
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
                  onPressed: () async {
                    print('da them vao gio hang');
                    int newID = await ItemCartHandler.lastIndex() + 1;
                    ItemCart itemCart;
                    if(await AccountHandler.checkIsLogin()){
                        String idUser = await AccountHandler.getIdUser();
                    if(await ItemCartHandler.checkItemCart(_list[index].idProduct, idUser)){
                        int oldQuantity = await ItemCartHandler.getQuantityProduct(_list[index].idProduct, idUser);
                        ProductController.checkQuantityProduct(_list[index].idProduct, oldQuantity + 1).then((dataFormServer) => {
                            if(dataFormServer.errCode != 0){
                                showDialogBox("Thông báo", dataFormServer.errMessage!),
                            }else {
                                ItemCartHandler.updateQuantityItemCart(_list[index].idProduct, idUser, oldQuantity + 1),
                                ItemFavoriteHandler.deleteItemFavorite(_list[index].idProduct, idUser),
                                setState(() {
                                    _list.removeAt(index);
                                }),
                                Fluttertoast.showToast(msg: 'Đâ thêm sản phẩm vào giỏ hàng.', toastLength: Toast.LENGTH_SHORT),
                                itemCartState.reloadCountItemCart(),
                                ItemFavoriteState.reloadCountItemFavorite()
                            }
                        });
                    }else{
                        ProductController.checkQuantityProduct(_list[index].idProduct, 1).then((dataFormServer) => {
                            if(dataFormServer.errCode != 0){
                                showDialogBox("Thông báo", dataFormServer.errMessage!),
                            }else {
                                itemCart = ItemCart(
                                    id: newID,
                                    idUser: idUser,
                                    idProduct: _list[index].idProduct,
                                    category: _list[index].category,
                                    name: _list[index].name,
                                    price: _list[index].price.toDouble(),
                                    quantity: 1,
                                    urlImg: _list[index].urlImg),
                                ItemCartHandler.insertItemCart(itemCart),
                                ItemFavoriteHandler.deleteItemFavorite(_list[index].idProduct, idUser),
                                setState(() {
                                  _list.removeAt(index);
                                }),
                                Fluttertoast.showToast(msg: 'Đâ thêm sản phẩm vào giỏ hàng.', toastLength: Toast.LENGTH_SHORT),
                                itemCartState.reloadCountItemCart(),
                                ItemFavoriteState.reloadCountItemFavorite()
                            }
                        });
                    }
                    }else{
                        // ignore: use_build_context_synchronously
                        showDialogBox('Thông báo', 'Bạn cần đăng nhập để thực hiện chức năng này.');
                    }
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

  Widget _buildIconCart(BuildContext context) {
    final itemCartState = Provider.of<ProviderItemCart>(context, listen: true);
    return IconButton(
      padding: const EdgeInsets.only(right: 12),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
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
