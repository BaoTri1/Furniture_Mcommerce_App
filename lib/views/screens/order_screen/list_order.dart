import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: ListView.builder(
          itemBuilder: _buildItem,
          itemCount: 4,
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order No238562312',
                          style: TextStyle(
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xff303030)),
                        ),
                        Text(
                          '20/03/2020',
                          style: TextStyle(
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
                            text: const TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: 'Số lượng: ',
                                  style: TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: Color(0xff808080))),
                              TextSpan(
                                  text: '3',
                                  style: TextStyle(
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
                                      .format(200000000),
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
                        const Text(
                          'Đã giao',
                          style: TextStyle(
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xff27AE60)),
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

}