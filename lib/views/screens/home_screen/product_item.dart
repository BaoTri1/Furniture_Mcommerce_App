import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/models/product.dart';
import 'package:furniture_mcommerce_app/views/screens/product_screen/product_screen.dart';
import 'package:intl/intl.dart';

class ProductItem extends StatelessWidget {
  final Product productInfor;

  const ProductItem(this.productInfor, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print(productInfor.idProduct);
        final result = await Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
                builder: (_) => ProductScreen(id: productInfor.idProduct!, nameCategory: productInfor.nameCat!,)));

        late Product receive;
        if (result != null) receive = result;
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
              child: Container(
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
                  onPressed: () {
                    print('da them vao gio hang');
                  },
                ),
              ))
        ],
      ),
    );
  }
}
