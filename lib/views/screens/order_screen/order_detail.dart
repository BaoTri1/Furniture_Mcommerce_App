import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/controllers/order_controller.dart';
import 'package:furniture_mcommerce_app/models/ItemOrder.dart';
import 'package:furniture_mcommerce_app/models/order.dart';
import 'package:furniture_mcommerce_app/views/screens/home_screen/list_category.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class OrderDetail extends StatefulWidget {

  String idOrder;

  OrderDetail({super.key, required this.idOrder});
  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return OrderDetailState(idOrder: idOrder);
  }

}
class OrderDetailState extends State<OrderDetail>{
  OrderDetailState({required this.idOrder});
  String idOrder;

  Order infoOrder = Order();
  List<DetailOrder> list = [];

  @override
  void initState() {
    _getInfoOrder();
    super.initState();
  }

  void _getInfoOrder() {
      OrderController.getInfoOrder(idOrder).then((dataFromServer) => {
          setState((){
              infoOrder = dataFromServer.orders!;
              list.addAll(dataFromServer.orders!.detailOrder!);
          })
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Detail Order',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'Chi tiết đơn hàng',
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
          body: Container(
            margin: const EdgeInsets.only(top: 30),
            child: CustomScrollView(
              slivers: [
                //lable: Thông tin giao hàng
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.only(left: 12, bottom: 10),
                    child: const Text(
                      'Thông tin giao hàng',
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xff909090)),
                    ),
                  ),
                ),
                //widget hiển thị thông tin giao hàng
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
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
                              child: Text(
                                 '${infoOrder.nameCustomer ?? ''} - ${infoOrder.sDT ?? ''}',
                                style: const TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Color(0xff303030)),
                              ),
                            ),
                            Container(
                              height: 2,
                              width: 335,
                              color: const Color(0xffF0F0F0),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: Text(
                                infoOrder.address ?? '',
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
                //lable: Thông tin vận chuyển
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, left: 12, bottom: 10),
                    child: const Text(
                      'Thông tin vận chuyển',
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xff909090)),
                    ),
                  ),
                ),
                //widget hiển thị thông tin vận chuyển
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ClipRRect(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        //height: MediaQuery.of(context).size.height,
                        margin: const EdgeInsets.only(bottom: 6.0),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0),
                                  blurRadius: 6.0)
                            ]),
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    child: const Text(
                                      'Hình thức:',
                                      style: TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          color: Color(0xff808080)),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Text(
                                      infoOrder.nameShipment ?? '',
                                      style: const TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    child: const Text(
                                      'Phí vận chuyển:',
                                      style: TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          color: Color(0xff808080)),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Text(
                                      NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(infoOrder.fee ?? 0),
                                      style: const TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: Colors.black),
                                      softWrap: true,
                                      overflow: TextOverflow.clip,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //lable: danh sách sản phẩm
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.only(left: 12, top: 10, bottom: 10),
                    child: const Text(
                      'Danh sách sản phẩm',
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xff909090)),
                    ),
                  ),
                ),
                //Widget danh sách sản phẩm
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: ClipRRect(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          //height: MediaQuery.of(context).size.height,
                          margin: const EdgeInsets.only(bottom: 6.0),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0),
                                    blurRadius: 6.0)
                              ]),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: _buildItemProduct,
                            itemCount: list.length,
                          )),
                    ),
                  ),
                ),
                //lable: Thôn tin đơn hàng
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.only(left: 12, top: 10, bottom: 10),
                    child: const Text(
                      'Thông tin đơn hàng',
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xff909090)),
                    ),
                  ),
                ),
                //Widget hiển thị đơn hàng
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ClipRRect(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        //height: MediaQuery.of(context).size.height,
                        margin: const EdgeInsets.only(bottom: 6.0),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0),
                                  blurRadius: 6.0)
                            ]),
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    child: const Text(
                                      'Mã Đơn hàng:',
                                      style: TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          color: Color(0xff808080)),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Text(
                                      infoOrder.idOrder ?? '',
                                      style: const TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    child: const Text(
                                      'Ngày đặt hàng:',
                                      style: TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          color: Color(0xff808080)),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Text(
                                      DateFormat('dd/MM/yyyy HH:mm')
                                          .format(DateTime.parse(infoOrder.dayCreateAt ?? DateTime.now().toString())),
                                      style: const TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    child: const Text(
                                      'Trạng thái:',
                                      style: TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          color: Color(0xff808080)),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Text(
                                      infoOrder.name ?? '',
                                      style: const TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.black),
                                      softWrap: true,
                                      overflow: TextOverflow.clip,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    child: const Text(
                                      'Thanh toán:',
                                      style: TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: Color(0xff808080)),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Text(
                                      infoOrder.statusPayment == 1 ? 'Đã thanh toán' : 'Chưa thanh toán',
                                      style: const TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.black),
                                      softWrap: true,
                                      overflow: TextOverflow.clip,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    child: const Text(
                                      'Tổng hóa đơn:',
                                      style: TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          color: Color(0xff808080)),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Text(
                                      NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(infoOrder.total ?? 0),
                                      style: const TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: Colors.black),
                                      softWrap: true,
                                      overflow: TextOverflow.clip,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
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
                              child: const Text(
                                'Phương thức thanh toán'
                                ,
                                style: TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Color(0xff303030)),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: Text(
                                infoOrder.namePayment ?? '',
                                style: const TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Color(0xff808080)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //Widget nút Hủy đơn hàng
                (infoOrder.idStatus ?? '' ) == 'R1' ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(340, 60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: const Text('Hủy đơn hàng',
                          style: TextStyle(
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 20)),
                      onPressed: () async {
                          print('hủy đơn');
                          List<ItemOrder> listItemOrder = [];
                          for(var item in infoOrder.detailOrder!){
                            ItemOrder itemorder = ItemOrder(idProduct: item.idProduct, numProduct: item.numProduct);
                            listItemOrder.add(itemorder);
                          }
                          OrderController.cancleOrder(infoOrder.idOrder!, infoOrder.idStatus!, listItemOrder).then((dataFromServer) => {
                              if(dataFromServer.errCode == 0){
                                  setState((){
                                      infoOrder = dataFromServer.orders!;
                                  })
                              }
                          });
                      },
                    ),
                  ),
                ) : const SliverToBoxAdapter(),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildItemProduct(BuildContext context, int index) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 140,
        ),
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.all(10),
          child: Card(
            child: Image.network(
              list[index].imgUrl!,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 120,
          child: SizedBox(
            width: 200,
            child: Text(
              list[index].nameProduct!,
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
          top: 60,
          left: 120,
          child: Text(
            NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                .format(list[index].finalPrice!),
            style: TextStyle(
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: list[index].originalPrice! == list[index].finalPrice! ? const Color(0xff303030) : Colors.red),
          ),
        ),
        list[index].originalPrice! == list[index].finalPrice! ? const SizedBox() :
        Positioned(
          top: 85,
          left: 120,
          child: Text(
            NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                .format(list[index].originalPrice!),
            style: const TextStyle(
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xff808080),
                decoration: TextDecoration.lineThrough,
                decorationThickness: 1.5,
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 15,
          child: Text(
            'x${list[index].numProduct!}',
            style: const TextStyle(
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xff303030)),
          ),
        ),
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
    );
  }

}