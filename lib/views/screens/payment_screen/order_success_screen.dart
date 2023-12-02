import 'package:flutter/material.dart';
import 'package:furniture_mcommerce_app/views/main.dart';
import 'package:furniture_mcommerce_app/views/screens/order_screen/order_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CongratsScreen',
      home: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 400,
                    height: 60,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: const Text(
                      'Thành Công',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Merriweather',
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff303030)
                      ),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: Image.asset('assets/images/img_order_successs.png', fit: BoxFit.cover,)
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, left: 35, right: 35),
                    child: const Text(
                      'Đơn hàng của bạn sẽ được giao sớm. Cảm ơn bạn đã chọn ứng dụng của chúng tôi!',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff606060)
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, left: 35, right: 35),
                    child: ElevatedButton(
                      // ignore: avoid_print
                        onPressed: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff242424),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(315, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: const Text(
                          'Theo dõi đơn hàng',
                          style: TextStyle(
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        )),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, left: 35, right: 35),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(315, 60),
                        side: const BorderSide(style: BorderStyle.solid, color: Colors.black, width: 1)
                      ),
                      child: const Text(
                          'Trở về trang chủ',
                          style: TextStyle(
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
      ),
    );
  }

}