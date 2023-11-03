import 'package:flutter/material.dart';
import 'package:furniture_mcommerce_app/models/localstore/account.dart';
import 'package:furniture_mcommerce_app/views/main.dart';
import 'package:furniture_mcommerce_app/views/screens/login_screen/login_screen.dart';

import '../../../controllers/authorization_controller.dart';
import '../../../local_store/db/account_handler.dart';
import '../../../shared_resources/share_method.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return SignupFormState();
  }
}

class SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  late String _fullName;
  late String _sdt;
  late String _passwd;
  String? _comfirmPasswd;
  bool _isObscured = true;
  bool _isObscuredConfirm = true;
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
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  hintText: 'Nhập họ và tên',
                  labelText: 'Họ và tên',
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
                validator: (String? fullName) {
                  if (fullName == null || fullName.isEmpty) {
                    return 'Họ và tên không để trống!';
                  }
                  _fullName = fullName.trim();
                  return null;
                },
              ),
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
                  hintText: 'Nhập SDT để đăng ký...',
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
                textInputAction: TextInputAction.next,
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
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscuredConfirm
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xff242424),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscuredConfirm = !_isObscuredConfirm;
                      });
                    },
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  hintText: 'Nhập mật khẩu xác nhận...',
                  labelText: 'Xác nhận mật khẩu',
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
                obscureText: _isObscuredConfirm,
                validator: (String? passwdConfirm) {
                  if (passwdConfirm == null || passwdConfirm.isEmpty) {
                    return 'Xác nhận mật khẩu không để trống!';
                  }

                  if (passwdConfirm != _passwd) {
                    return 'Mật khẩu không khớp!';
                  }
                  _comfirmPasswd = passwdConfirm.trim();
                  return null;
                },
              ),
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
                      // print(
                      //     '${_fullName} + ${_sdt} + ${_passwd} + ${_comfirmPasswd}');
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const MainScreen()));
                      if (await ShareMethod.checkInternetConnection(context)) {
                            AuthorizationController.signupHandler(_fullName, _sdt, _passwd).then((dataFormServer) => {
                              if (dataFormServer.errCode != 0){
                                  showDialogBox("Lỗi đăng ký", dataFormServer.errMessage!)
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
                  child: const Text('Đăng ký',
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 18)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Đã có tài khoản rồi? ',
                    style: TextStyle(
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xff808080)),
                  ),
                  TextButton(
                    child: const Text(
                      'ĐĂNG NHẬP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                          color: Color(0xff303030),
                          fontSize: 14),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                  )
                ],
              ),
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
