import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/views/screens/product_screen/product_screen.dart';
import 'package:intl/intl.dart';
import '../../../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product productInfor;

  const ProductItem(this.productInfor, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .push(MaterialPageRoute(builder: (_) => const ProductScreen()));
      },
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Image.asset(
            productInfor.urlIamge,
            fit: BoxFit.cover,
            width: 300,
            height: 200,
          ),
          Positioned(
              top: 210,
              child: Text(
                productInfor.name,
                style: const TextStyle(
                    fontFamily: 'NunitoSans',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xff606060)),
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
              top: 155,
              left: 125,
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
