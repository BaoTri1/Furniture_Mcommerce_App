import 'dart:async';
import 'package:flutter/material.dart';
import 'package:furniture_mcommerce_app/local_store/db/account_handler.dart';
import 'package:furniture_mcommerce_app/models/localstore/account.dart';
import 'package:furniture_mcommerce_app/shared_resources/share_method.dart';
import 'package:furniture_mcommerce_app/controllers/authorization_controller.dart';
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
  late String _sdt;
  late String _passwd;
  bool _isObscured = true;
  late Account account;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (await ShareMethod.checkInternetConnection(context)) {
                        AuthorizationController.loginHandler(_sdt, _passwd).then((dataFormServer) => {
                        if (dataFormServer.errCode != 0){
                            showDialogBox("Lỗi đăng nhập", dataFormServer.errMessage!)
                        }else {
                            AccountHandler.deleteAll(),
                            account = Account(
                            id: 1,
                            idUser: dataFormServer.user!.idUser!,
                            sdt: _sdt,
                            passwd: _passwd,
                            isLogin: 1,
                            token: dataFormServer.accessToken!),

                            AccountHandler.insertAccount(account),
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainScreen()))}});
                    }else{
                      showDialogBox("Lỗi kết nối mạng", 'Không có kết nối mạng. Hãy kiểm tra lại kết nối của bạn!');
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

  void showDialogBox(String title, String message) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: Text(
                title,
                style: const TextStyle(
                    fontFamily: 'Merriweather',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xff303030)),
              ),
              content: Text(
                message,
                style: const TextStyle(
                    fontFamily: 'NunitoSans',
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Color(0xff303030)),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Thử lại',
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Color(0xff303030)),
                    ))
              ],
            )
    );
  }

}
