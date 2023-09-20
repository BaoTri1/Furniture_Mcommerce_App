import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
var img_bg = const AssetImage("assets/images/background_board_screen.png");

class BoardingScreen extends StatelessWidget {
  const BoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(img_bg, context);
    return MaterialApp(
      title: "BoardingScreen",
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: img_bg, fit: BoxFit.fill),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: const EdgeInsets.only(top: 180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: const Text('MAKE YOUR',
                      style: TextStyle(
                          fontFamily: 'gelasio',
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          color: Color(0xff606060))),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 20, top: 10),
                    child: const Text('HOME BEAUTIFUL',
                        style: TextStyle(
                            fontFamily: 'gelasio',
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                            color: Color(0xff303030)))),
                Container(
                  margin: const EdgeInsets.only(left: 30, top: 20, right: 30),
                  child: const Text(
                      'Nơi đơn giản nhất mà bạn có thể khám phá '
                      'những nội thất tuyệt vời nhất và làm cho ngôi nhà của bạn trở nên đẹp đẽ',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Color(0xff808080))),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 120),
                  child: Center(
                      child: ElevatedButton(
                          // ignore: avoid_print
                          onPressed: () => {print('bat dau click')},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff242424),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(159, 54),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4))),
                          child: const Text(
                            'Bắt đầu',
                            style: TextStyle(
                                fontFamily: 'gelasio',
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
