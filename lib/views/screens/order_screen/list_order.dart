import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/controllers/order_controller.dart';
import 'package:furniture_mcommerce_app/shared_resources/share_string.dart';
import 'package:furniture_mcommerce_app/views/screens/order_screen/order_detail.dart';
import 'package:intl/intl.dart';

import '../../../local_store/db/account_handler.dart';
import '../../../models/order.dart';

// ignore: must_be_immutable
class ListOrder extends StatefulWidget {
  ListOrder({super.key, required this.status});
  String status;

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return ListOrderState(status: status);
  }

}

class ListOrderState extends State<ListOrder> {
  ListOrderState({required this.status});
  String status;

  final List<Order> _list = [];
  bool hidden = false;

  @override
  void initState() {
    _getListOrder();
    super.initState();
  }

  void _getListOrder() async {
    String idUser = await AccountHandler.getIdUser();
    print(idUser);
    if(idUser.isEmpty) return;
    if(status == ShareString.DANG_XU_LY){
      OrderController.getListOrderProcess(idUser).then((dataFormServer) => {
          if(dataFormServer.errCode == 0){
              setState((){
                  _list.addAll(dataFormServer.orders!);

              })
          }else{
              setState((){
                hidden = true;
              })
          }
      });
    }else if(status == ShareString.SAN_SANG_GIAO_HANG){
      OrderController.getListOrderReadyDelivery(idUser).then((dataFormServer) => {
        if(dataFormServer.errCode == 0){
          setState((){
            _list.addAll(dataFormServer.orders!);

          })
        }else{
          setState((){
            hidden = true;
          })
        }
      });
    }else if(status == ShareString.DANG_GIAO_HANG){
      OrderController.getListOrderDelivering(idUser).then((dataFormServer) => {
        if(dataFormServer.errCode == 0){
          setState((){
            _list.addAll(dataFormServer.orders!);

          })
        }else{
          setState((){
            hidden = true;
          })
        }
      });
    }else if(status == ShareString.DA_GIAO_HANG_THANH_CONG){
      OrderController.getListOrderDelivered(idUser).then((dataFormServer) => {
        if(dataFormServer.errCode == 0){
          setState((){
            _list.addAll(dataFormServer.orders!);

          })
        }else{
          setState((){
            hidden = true;
          })
        }
      });
    }else if(status == ShareString.DA_HUY){
      OrderController.getListOrderCancel(idUser).then((dataFormServer) => {
        if(dataFormServer.errCode == 0){
          setState((){
            _list.addAll(dataFormServer.orders!);

          })
        }else{
          setState((){
            hidden = true;
          })
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return hidden == true ? _buildNoteNoItem(context) : Container(
      margin: const EdgeInsets.only(top: 30),
      child: ListView.builder(
          itemBuilder: _buildItem,
          itemCount: _list.length,
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index){
      return GestureDetector(
        onTap: () {

        },
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
          child: ClipRRect(
            child: Container(
              margin: const EdgeInsets.only(bottom: 6.0),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 6.0)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _list[index].idOrder!,
                          style: const TextStyle(
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xff303030)),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(_list[index].dayCreateAt!)),
                          style: const TextStyle(
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xff808080)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 2,
                    width: 335,
                    color: const Color(0xffF0F0F0),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: <TextSpan>[
                              const TextSpan(
                                  text: 'Số lượng: ',
                                  style: TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: Color(0xff808080))),
                              TextSpan(
                                  text: _list[index].quantity!,
                                  style: const TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Color(0xff242424)))
                            ])),
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: <TextSpan>[
                              const TextSpan(
                                  text: 'Tổng tiền: ',
                                  style: TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: Color(0xff808080))),
                              TextSpan(
                                  text: NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                                      .format(_list[index].total!),
                                  style: const TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Color(0xff242424)))
                            ])),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          // ignore: avoid_print
                            onPressed: () async {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => OrderDetail(idOrder: _list[index].idOrder!)));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff242424),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(100, 36),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            child: const Text(
                              'Chi tiết',
                              style: TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            )),
                        Text(
                          _list[index].name!,
                          style: TextStyle(
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: status == ShareString.DA_GIAO_HANG_THANH_CONG ? const Color(0xff27AE60)
                                  : (status == ShareString.DA_HUY ? Colors.red
                                  :(status == ShareString.DANG_XU_LY ? Colors.amber
                                  : (status == ShareString.SAN_SANG_GIAO_HANG ? Colors.blueAccent : const Color(0xff00EE76))))
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                icon: SvgIconData('assets/icons/icon_order.svg'))),
        Container(
          margin: EdgeInsets.all(20),
          child: const Text(
            'Không có đơn hàng nào.',
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

}