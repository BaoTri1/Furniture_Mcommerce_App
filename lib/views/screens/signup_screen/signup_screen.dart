import 'package:flutter/material.dart';
import 'package:furniture_mcommerce_app/views/screens/signup_screen/form_signup.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Signup Screen',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
              child: SingleChildScrollView(
                  child: Column(children: [
            Stack(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 105,
                      height: 1,
                      color: const Color(0xffBDBDBD),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      color: Colors.transparent,
                      width: 70,
                      height: 70,
                      child: Image.asset('assets/images/logo.png'),
                    ),
                    Container(
                      width: 105,
                      height: 1,
                      color: const Color(0xffBDBDBD),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  height: MediaQuery.of(context).size.height,
                  child: const Text(
                    'XIN CHÀO',
                    style: TextStyle(
                        fontFamily: 'Merriweather',
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Color(0xff242424)),
                  ),
                ),
              ]),
              Positioned(
                  top: 160,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff8A959E).withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(
                              0, 3), // Điều chỉnh tọa độ x và y của bóng đổ
                        ),
                      ],
                    ),
                    child: const SignupForm(),
                  ))
            ]),
          ]))),
        ));
  }
}
