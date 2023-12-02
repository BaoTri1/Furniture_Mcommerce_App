import 'dart:io';

import 'package:flutter/material.dart';
import 'package:furniture_mcommerce_app/controllers/authorization_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:image_picker/image_picker.dart';

import '../../../local_store/db/account_handler.dart';
import '../../../models/authorization.dart';
import '../../../shared_resources/share_string.dart';
import '../login_screen/login_screen.dart';

// ignore: must_be_immutable
class EditProfile extends StatefulWidget {
  EditProfile({super.key, required this.user});

  User user;

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return EditProfileState(user: user);
  }

}

class EditProfileState extends State<EditProfile> {
  EditProfileState({required this.user});
  User user;

  String? selectedGender;

  DateTime selectedDate = DateTime.now();

  late TextEditingController _controllerName;
  late TextEditingController _controllerPhone;
  late TextEditingController _controllerEmail;

  String? name;
  String? _errorName;
  String? sdt;
  String? _errorSDT;
  String? email;
  String? _errorEmail;
  String? gender;
  String? dayOfBird;

  ImagePicker picker = ImagePicker();
  XFile? image;

  String? idUser;


  @override
  void initState() {
    _getIdUser();
    _controllerName = TextEditingController(text: user.fullName!);
    _controllerPhone = TextEditingController(text: user.sdtUser ?? '');
    _controllerEmail = TextEditingController(text: user.email ?? '');
    selectedGender = user.gender ?? 'Nam';
    super.initState();
  }

  void _getIdUser() async {
    idUser = await AccountHandler.getIdUser();
    print(idUser);
    if(idUser!.isEmpty) return;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    final format = DateFormat("dd/MM/yyyy");
    return format.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edit Profile',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Chỉnh sửa hồ sơ',
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
          margin: const EdgeInsets.only(top: 20),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircleAvatar(
                          backgroundImage: image == null ? (user.avatar == null ? const AssetImage('assets/images/img_avatar.png') as ImageProvider :
                          NetworkImage(user.avatar!))
                                : FileImage(File(image!.path))
                      ),
                    ),
                    Container(
                      child: TextButton(
                          onPressed: () async {
                            image = await picker.pickImage(source: ImageSource.gallery);
                            setState(() {

                            });
                            AuthorizationController.updateAvatar(idUser!, File(image!.path)).then((dataFromServer) => {
                              showDialogBox('Thông báo', dataFromServer.errMessage!, ShareString.CLOSE_DIALOG)
                            });
                          },
                          child: const Text(
                              'Chỉnh sửa',
                              style: TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xff242424))),
                          )
                      ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: const Text(
                          'Họ và tên:',
                          style: TextStyle(
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0xff808080)),
                        ),
                      ),
                      SizedBox(
                        //width: MediaQuery.of(context).size.width - 200,
                        child: TextField(
                            controller: _controllerName,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            onChanged: (value){
                              setState(() {
                                name = value;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                      color: Color(0xff242424))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                      color: Color(0xff242424), width: 1.0)),
                              hintText: 'Nhập họ và tên...',
                              errorText: _errorName,
                              hintStyle: const TextStyle(
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffE0E0E0),
                                  fontSize: 16),

                            )),
                      )
                        ]
              ))),
              SliverToBoxAdapter(
                  child: Container(
                      margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: const Text(
                                'Số điện thoại:',
                                style: TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Color(0xff808080)),
                              ),
                            ),
                            SizedBox(
                              //width: MediaQuery.of(context).size.width - 200,
                              child: TextField(
                                  controller: _controllerPhone,
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  maxLength: 10,
                                  onChanged: (value){
                                    setState(() {
                                      sdt = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: Color(0xff242424))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: Color(0xff242424), width: 1.0)),
                                    hintText: 'Nhập số điện thoại...',
                                    errorText: _errorSDT,
                                    hintStyle: const TextStyle(
                                        fontFamily: 'Nunito Sans',
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xffE0E0E0),
                                        fontSize: 16),

                                  )),
                            )
                          ]
                      ))),
              SliverToBoxAdapter(
                  child: Container(
                      margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: const Text(
                                'Email:',
                                style: TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Color(0xff808080)),
                              ),
                            ),
                            SizedBox(
                              //width: MediaQuery.of(context).size.width - 200,
                              child: TextField(
                                  controller: _controllerEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (value){
                                    setState(() {
                                      email = value;
                                    });
                                  },
                                  onSubmitted: (String value){
                                    setState(() {
                                    });
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: Color(0xff242424))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: Color(0xff242424), width: 1.0)),
                                    hintText: 'Nhập email...',
                                    errorText: _errorEmail,
                                    hintStyle: const TextStyle(
                                        fontFamily: 'Nunito Sans',
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xffE0E0E0),
                                        fontSize: 16),
                                  )),
                            )
                          ]
                      ))),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: const Text(
                          'Giới tính:',
                          style: TextStyle(
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0xff808080)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, right: 30),
                        child: DropdownButton<String>(
                          value: selectedGender,
                          onChanged: (String? value){
                              setState(() {
                                  selectedGender = value;
                              });
                          },
                          items: <String>['Nam', 'Nữ']
                              .map((String s) {
                            return DropdownMenuItem<String>(
                              value: s,
                              child: Text(
                                  s,
                                  style: const TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      color: Color(0xff242424)),
                              ),
                            );
                          })
                              .toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: const Text(
                          'Ngày sinh:',
                          style: TextStyle(
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0xff808080)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(
                            _formatDate(selectedDate),
                            style: const TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black),
                            softWrap: true,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(340, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: const Text('Cập nhật hồ sơ',
                            style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w600,
                                fontSize: 20)),
                        onPressed: () async {
                          name = _controllerName.text.trim();
                          sdt = _controllerPhone.text.trim();
                          email = _controllerEmail.text.trim();

                            if(name!.isEmpty){
                                setState(() {
                                    _errorName = 'Họ và tên không bỏ trống.';
                                });
                                return;
                            }else{
                              setState(() {
                                _errorName = null;
                              });
                            }

                          if(sdt!.isEmpty){
                            setState(() {
                              _errorSDT = 'Số điện thoại không bỏ trống.';
                            });
                            return;
                          }else{
                            setState(() {
                              _errorSDT = null;
                            });
                          }

                          if(sdt!.length < 10){
                            setState(() {
                              _errorSDT = 'Số điện thoại không hợp lệ.';
                            });
                            return;
                          }else{
                            setState(() {
                              _errorSDT = null;
                            });
                          }

                          if(email!.isEmpty){
                            setState(() {
                              _errorEmail = 'Email không bỏ trống.';
                            });
                            return;
                          }else{
                            setState(() {
                              _errorEmail = null;
                            });
                          }

                          if(selectedGender == null || selectedGender!.isEmpty){
                            showDialogBox('Thông báo', 'Bạn chưa chọn giới tính.', ShareString.CLOSE_DIALOG);
                            return;
                          }
                          
                          AuthorizationController.updateInfoUser(idUser!, name!, sdt!, email!, selectedGender!, selectedDate!.toIso8601String())
                            .then((dataFormServer) => {
                              showDialogBox('Thông báo', dataFormServer.errMessage!, ShareString.CLOSE_DIALOG)
                          });
                          print(selectedDate);

                        }
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDialogBox(String title, String message, String action) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
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
                onPressed: () async {
                  if(action == ShareString.CLOSE_DIALOG){
                    Navigator.pop(context);
                  }
                  else if(action == ShareString.PUSH_LOGIN){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  }
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                      fontFamily: 'NunitoSans',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xff303030)),
                ))
          ],
        ));
  }
}