import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/models/item_ship.dart';
import 'package:furniture_mcommerce_app/models/methodshipping.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../controllers/otherservice_controller.dart';
import '../../../../local_store/db/account_handler.dart';

class SelectShip extends StatefulWidget {
  const SelectShip({super.key});

  @override
  State<StatefulWidget> createState() {
    return SelectShipState();
  }
}

class SelectShipState extends State<SelectShip> {

  late List<Methodshinpping> _list = [];
  bool _enabled = true;

  @override
  void initState() {
    _getListMethodShipping();
    super.initState();
  }

  void _getListMethodShipping() async {
    String token = await AccountHandler.getToken();
    if(token.isEmpty) return;
    OtherServiceController.fetchListMethodShipping(token).then((dataFormServer) => {
      if(dataFormServer.errCode == 0){
        setState((){
          _list = dataFormServer.methodshinppings!;
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
          'Chọn phương thức vận chuyển',
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
                      icon: SvgIconData(_list[index].iconShipment!),
                      size: 35,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Text(
                      '${_list[index].nameShipment!}\n'
                          'Phí vận chuyển: ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(_list[index].fee!)}\n '
                          'Thời gian vận chuyển: ${_list[index].timeShip!}',
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

List<ItemShip> _listShip = [
  ItemShip(
      id: '1',
      name: "giao hàng nhanh.",
      fee: 20000.0,
      timeShip: '2-3 ngày',
      icon: 'assets/icons/icon_fast_delivery.svg'),
  ItemShip(
      id: '2',
      name: "Giao hàng bình thường",
      fee: 10000.0,
      timeShip: '7-10 ngày',
      icon: 'assets/icons/icon_delivery.svg'),
];
