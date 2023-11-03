import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniture_mcommerce_app/models/localstore/itemcart.dart';
import 'package:furniture_mcommerce_app/models/product.dart';
import 'package:furniture_mcommerce_app/views/screens/product_screen/product_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../controllers/product_controller.dart';
import '../../../local_store/db/account_handler.dart';
import '../../../local_store/db/itemcart_handler.dart';
import '../../../models/states/provider_itemcart.dart';
import '../login_screen/login_screen.dart';

class ProductItem extends StatelessWidget {
  final Product productInfor;
  const ProductItem(this.productInfor, {super.key});

  // ignore: constant_identifier_names
  static const String CLOSE_DIALOG = 'CloseDialog';
  // ignore: constant_identifier_names
  static const String PUSH_LOGIN = 'PushLogin';

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    final ItemCartState = Provider.of<ProviderItemCart>(context, listen: true);
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
                builder: (_) => ProductScreen(id: productInfor.idProduct!, nameCategory: productInfor.nameCat!,)));
        
      },
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            //height: 500,
          ),
          Image.network(
            productInfor.imgUrl!,
            fit: BoxFit.fill,
            width: 300,
            height: 170,
          ),
          Positioned(
              top: 180,
              child: SizedBox(
                width: 180,
                child: Text(
                  productInfor.nameProduct!,
                  style: const TextStyle(
                      fontFamily: 'NunitoSans',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xff606060)),
                      softWrap: true,
                      overflow: TextOverflow.clip,
                ),
              )),
          Positioned(
              top: 230,
              child: Text(
                NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                    .format(productInfor.price),
                style: const TextStyle(
                    fontFamily: 'NunitoSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xff303030)),
              )),
          Positioned(
              top: 125,
              left: MediaQuery.of(context).size.width>400 ? 145 : 125,
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
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    //showAlertDialog(context, 'Đã thêm vào giỏ hàng');
                    int newID = await ItemCartHandler.lastIndex() + 1;
                    ItemCart itemCart;
                    if(await AccountHandler.checkIsLogin()){
                      String idUser = await AccountHandler.getIdUser();
                      if(await ItemCartHandler.checkItemCart(productInfor.idProduct!, idUser)){
                        int oldQuantity = await ItemCartHandler.getQuantityProduct(productInfor.idProduct!, idUser);
                        ProductController.checkQuantityProduct(productInfor.idProduct!, oldQuantity + 1).then((dataFormServer) => {
                          if(dataFormServer.errCode != 0){
                            showDialogBox(context, "Thông báo", dataFormServer.errMessage!, CLOSE_DIALOG),
                          }else {
                            ItemCartHandler.updateQuantityItemCart(productInfor.idProduct!, idUser, oldQuantity + 1),
                            Fluttertoast.showToast(msg: 'Đâ thêm sản phẩm vào giỏ hàng.', toastLength: Toast.LENGTH_SHORT)
                          }
                        });
                      }else{
                        ProductController.checkQuantityProduct(productInfor.idProduct!, 1).then((dataFormServer) => {
                          if(dataFormServer.errCode != 0){
                            showDialogBox(context, "Thông báo", dataFormServer.errMessage!, CLOSE_DIALOG),
                          }else {
                            itemCart = ItemCart(
                                id: newID,
                                idUser: idUser,
                                idProduct: productInfor.idProduct!,
                                category: productInfor.nameCat!,
                                name: productInfor.nameProduct!,
                                price: productInfor.price!.toDouble(),
                                quantity: 1,
                                urlImg: productInfor.imgUrl!),
                            ItemCartHandler.insertItemCart(itemCart),
                            Fluttertoast.showToast(msg: 'Đâ thêm sản phẩm vào giỏ hàng.', toastLength: Toast.LENGTH_SHORT),
                            ItemCartState.reloadCountItemCart()
                          }
                        });
                      }
                    }else{
                      // ignore: use_build_context_synchronously
                      showDialogBox(context, 'Thông báo', 'Bạn cần đăng nhập để thực hiện chức năng này.', PUSH_LOGIN);
                    }
                  },
                ),
              ))
        ],
      ),
    );
  }

  void showDialogBox(BuildContext context, String title, String message, String action) {
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
                  if(action == CLOSE_DIALOG){
                    Navigator.pop(context);
                  }
                  else if(action == PUSH_LOGIN){
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
