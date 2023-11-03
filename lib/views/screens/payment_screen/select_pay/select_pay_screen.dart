import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/controllers/otherservice_controller.dart';
import 'package:furniture_mcommerce_app/local_store/db/account_handler.dart';
import 'package:furniture_mcommerce_app/models/item_pay.dart';
import 'package:furniture_mcommerce_app/models/methodshipping.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../models/methodpayment.dart';

class SelectPay extends StatefulWidget {
  const SelectPay({super.key});

  @override
  State<StatefulWidget> createState() {
    return SelectPayState();
  }
}

class SelectPayState extends State<SelectPay> {

  late List<Methodpayment> _list = [];
  bool _enabled = true;

  @override
  void initState() {
    _getListMethodPayment();
      super.initState();
  }

  void _getListMethodPayment() async {
      String token = await AccountHandler.getToken();
      if(token.isEmpty) return;
      OtherServiceController.fetchListMethodPayment(token).then((dataFormServer) => {
        if(dataFormServer.errCode == 0){
          setState((){
              _list = dataFormServer.methodpayments!;
              _enabled = !_enabled;
          })
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Chọn phương thức thanh toán',
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
            icon: SvgIconData('assets/icons/icon_back.svg'),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Skeletonizer(
        enabled: _enabled,
        child: ListView.builder(
          itemBuilder: _buildItemPay,
          itemCount: _list.length,
        ),
      ),
    );
  }

  Widget _buildItemPay(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context, _list[index]);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ClipRRect(
            child: Container(
              margin: const EdgeInsets.only(bottom: 6.0),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0),
                    blurRadius: 6.0)
              ]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: SvgIcon(
                      icon: SvgIconData(_list[index].iconPayment!),
                      size: 35,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Text(
                      _list[index].namePayment!,
                      style: const TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xff808080)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<ItemPay> _listPay = [
  ItemPay(
      id: '1',
      name: "Thanh toán trực tiếp khi nhận hàng.",
      icon: 'assets/icons/icon_paying_by_cash.svg'),
  ItemPay(
      id: '2',
      name: "Thanh toán bằng thẻ tín dụng.",
      icon: 'assets/icons/icon_paying_by_redict.svg'),
];
