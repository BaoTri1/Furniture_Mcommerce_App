import 'package:flutter/material.dart';
import 'package:furniture_mcommerce_app/views/main.dart';
import 'package:furniture_mcommerce_app/views/screens/signup_screen/signup_screen.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<StatefulWidget> createState() {
    return FormLoginState();
  }
}

class FormLoginState extends State<FormLogin> {
  final _formKey = GlobalKey<FormState>();
  String? _sdt;
  String? _passwd;
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                maxLength: 10,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  hintText: 'Nhập SDT để đăng nhập...',
                  labelText: 'Số điện thoại',
                  labelStyle: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w400,
                      color: Color(0xff909090),
                      fontSize: 14),
                  hintStyle: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w400,
                      color: Color(0xff909090),
                      fontSize: 12),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                          color: Color(0xff242424), width: 1.0)),
                ),
                validator: (String? sdt) {
                  if (sdt == null || sdt.isEmpty) {
                    return 'Số điện thoại không để trống!';
                  }

                  if (sdt.length < 10) {
                    return 'Số điện thoại không hợp lệ!';
                  }
                  _sdt = sdt.trim();
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xff242424),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  hintText: 'Nhập mật khẩu...',
                  labelText: 'Mật khẩu',
                  labelStyle: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w400,
                      color: Color(0xff909090),
                      fontSize: 14),
                  hintStyle: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w400,
                      color: Color(0xff909090),
                      fontSize: 12),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                          color: Color(0xff242424), width: 1.0)),
                ),
                obscureText: _isObscured,
                validator: (String? passwd) {
                  if (passwd == null || passwd.isEmpty) {
                    return 'Mật khẩu không để trống!';
                  }
                  _passwd = passwd.trim();
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                  child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Quên mật khẩu?',
                        style: TextStyle(
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w600,
                            color: Color(0xff303030),
                            fontSize: 18),
                      ))),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(285, 50)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print('${_sdt} + ${_passwd}');
                      if (_sdt == '0123456789' && _passwd == '123') {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainScreen()));
                      }
                    }
                  },
                  child: const Text('Đăng nhập',
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 18)),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                  child: TextButton(
                child: const Text(
                  'ĐĂNG KÝ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'NunitoSans',
                      fontWeight: FontWeight.w600,
                      color: Color(0xff303030),
                      fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupScreen()));
                },
              )),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ));
  }
}
