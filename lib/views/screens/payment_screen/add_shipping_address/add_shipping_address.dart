import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniture_mcommerce_app/local_store/db/account_handler.dart';
import 'package:furniture_mcommerce_app/local_store/db/shipping_address_handler.dart';
import 'package:furniture_mcommerce_app/models/district.dart';
import 'package:furniture_mcommerce_app/models/province.dart';
import 'package:furniture_mcommerce_app/models/localstore/shipping_address.dart';
import 'package:furniture_mcommerce_app/models/ward.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/add_shipping_address/select_district.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/add_shipping_address/select_province.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/add_shipping_address/select_ward.dart';
import 'package:furniture_mcommerce_app/shared_resources/check_string.dart';

// ignore: must_be_immutable
class AddShippingAddress extends StatelessWidget {
  AddShippingAddress({super.key, required this.isEdit, this.shippingAddress});

  ShippingAddress? shippingAddress;
  bool isEdit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'Thêm địa chỉ giao hàng',
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
          body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: FormAddAddress(
                isEdit: isEdit,
                shippingAddress: shippingAddress,
              )));
  }
}

// ignore: must_be_immutable
class FormAddAddress extends StatefulWidget {
  FormAddAddress({super.key, this.shippingAddress, required this.isEdit});

  ShippingAddress? shippingAddress;
  bool isEdit;

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return FormAddAddressState(
        shippingAddress: shippingAddress, isEdit: isEdit);
  }
}

class FormAddAddressState extends State<FormAddAddress> {
  FormAddAddressState({this.shippingAddress, required this.isEdit});

  ShippingAddress? shippingAddress;
  bool isEdit;
  late int newId;

  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _sdt;
  late String _address;
  late Province _province =
      Province(provinceId: '', provinceName: '', provinceType: '');
  late District _district = District(
      districtId: '', districtName: '', districtType: '', provinceId: '');
  late Ward _ward =
      Ward(wardId: '', wardName: '', wardType: '', districtId: '');

  late TextEditingController _controllerName;
  late TextEditingController _controllerPhone;
  late TextEditingController _controllerAddress;
  late TextEditingController _controllerProvince;
  late TextEditingController _controllerDistrict;
  late TextEditingController _controllerWard;

  void createNewID() async {
    newId = await ShippingAddressHandler.lastIndex() + 1;
  }

  @override
  void initState() {
    createNewID();
    if (isEdit) {
      print(shippingAddress?.address);
      _controllerName = TextEditingController(text: shippingAddress?.name);
      _controllerPhone = TextEditingController(text: shippingAddress?.sdt);
      List<String>? sliptAddress = shippingAddress?.address.split(', ');
      _controllerAddress = TextEditingController(text: sliptAddress?[0]);
      _controllerProvince = TextEditingController(text: sliptAddress?[3]);
      _controllerDistrict = TextEditingController(text: sliptAddress?[2]);
      _controllerWard = TextEditingController(text: sliptAddress?[1]);
    } else {
      print('tạo mới');
      _controllerName = TextEditingController();
      _controllerPhone = TextEditingController();
      _controllerAddress = TextEditingController();
      _controllerProvince = TextEditingController();
      _controllerDistrict = TextEditingController();
      _controllerWard = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _controllerName,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                          color: Color(0xff242424), width: 1.0)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Họ và tên',
                  labelStyle: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w400,
                      color: Color(0xff242424),
                      fontSize: 16),
                  hintText: 'VD: Pham Bao Tri',
                  hintStyle: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                      color: Color(0xffE0E0E0),
                      fontSize: 16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Họ tên không để trống!';
                  }

                  if(CheckString.checkNumandSpecialCharacters(value)){
                    return 'Họ và tên không hợp lệ';
                  }
                  _name = value.trim();
                  return null;
                },
              ),
              const SizedBox(
                width: 30,
                height: 30,
              ),
              TextFormField(
                controller: _controllerPhone,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                          color: Color(0xff242424), width: 1.0)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Số điện thoại',
                  labelStyle: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w400,
                      color: Color(0xff242424),
                      fontSize: 16),
                  hintText: 'VD: 0912345678',
                  hintStyle: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                      color: Color(0xffE0E0E0),
                      fontSize: 16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Số điện thoại không để trống!';
                  }

                  if(value.length < 10){
                    return 'Số điện thoại không hợp lệ!';
                  }
                  _sdt = value.trim();
                  return null;
                },
              ),
              const SizedBox(
                width: 30,
                height: 30,
              ),
              TextFormField(
                controller: _controllerAddress,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                          color: Color(0xff242424), width: 1.0)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Số nhà, tên đường',
                  labelStyle: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w400,
                      color: Color(0xff242424),
                      fontSize: 16),
                  hintText: 'VD:Hẻm 27, Mậu Thân...',
                  hintStyle: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                      color: Color(0xffE0E0E0),
                      fontSize: 16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Số nhà không để trống!';
                  }

                  if(CheckString.checkSpecialCharacters(value)){
                    return 'Địa chỉ không hợp lệ!';
                  }
                  _address = value.trim().replaceAll(', ', ' ');
                  return null;
                },
              ),
              const SizedBox(
                width: 30,
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text(
                  'Tỉnh/Thành phố:',
                  style: TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w400,
                      color: Color(0xff242424),
                      fontSize: 16),
                ),
              ),
              const SizedBox(
                width: 30,
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectProvince()));
                  if (result != null) {
                    _province = result;
                    setState(() {
                      _controllerProvince.text = _province.provinceName;
                    });
                  }
                },
                child: TextFormField(
                  enabled: false,
                  style: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                      color: Color(0xff242424),
                      fontSize: 16),
                  controller: _controllerProvince,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Color(0xff242424), width: 1.0)),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Chọn Thành phố/tỉnh của bạn...',
                      hintStyle: const TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                          color: Color(0xff242424),
                          fontSize: 16),
                      suffixIcon: const Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                      )),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Phải chọn thành phố/tỉnh của bạn';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                width: 30,
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text(
                  'Quận/Huyện:',
                  style: TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w400,
                      color: Color(0xff242424),
                      fontSize: 16),
                ),
              ),
              const SizedBox(
                width: 30,
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  if (_province.provinceId.isEmpty) {
                    return;
                  }
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectDistrict(
                              idProvince: _province.provinceId)));
                  if (result != null) {
                    _district = result;
                    setState(() {
                      _controllerDistrict.text = _district.districtName;
                    });
                  }
                },
                child: TextFormField(
                  enabled: false,
                  style: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                      color: Color(0xff242424),
                      fontSize: 16),
                  controller: _controllerDistrict,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Color(0xff242424), width: 1.0)),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Chọn Quận/huyện của bạn...',
                      hintStyle: const TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                          color: Color(0xff242424),
                          fontSize: 16),
                      suffixIcon: const Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                      )),
                  validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Phải chọn quận/huyện của bạn!';
                      }
                      return null;
                  },
                ),
              ),
              const SizedBox(
                width: 30,
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text(
                  'Phường/xã',
                  style: TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w400,
                      color: Color(0xff242424),
                      fontSize: 16),
                ),
              ),
              const SizedBox(
                width: 30,
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  if (_district.districtId.isEmpty) {
                    return;
                  }
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SelectWard(idDistrict: _district.districtId)));
                  if (result != null) {
                    _ward = result;
                    setState(() {
                      _controllerWard.text = _ward.wardName;
                    });
                  }
                },
                child: TextFormField(
                  enabled: false,
                  style: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                      color: Color(0xff242424),
                      fontSize: 16),
                  controller: _controllerWard,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Color(0xff242424), width: 1.0)),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Chọn Phường/xã của bạn...',
                      hintStyle: const TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                          color: Color(0xff242424),
                          fontSize: 16),
                      suffixIcon: const Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                      )),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Phải chọn phường/xã của bạn!';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                width: 30,
                height: 30,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(340, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text('Lưu địa chỉ',
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 20)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String address =
                          '$_address, ${_controllerWard.text}, ${_controllerDistrict.text}, ${_controllerProvince.text}';
                      if (isEdit) {
                        ShippingAddress updateShippingAddress = ShippingAddress(
                            id: shippingAddress!.id,
                            idUser: shippingAddress!.idUser,
                            name: _name,
                            sdt: _sdt,
                            address: address,
                            isDefault: shippingAddress!.isDefault);
                        //Update lại address
                        ShippingAddressHandler.updateShippingAddress(updateShippingAddress);

                      } else {
                        print('new ID: ${newId}');
                        String idUser = await AccountHandler.getIdUser();
                        ShippingAddress newShippingAddress = ShippingAddress(
                            id: newId,
                            idUser: idUser,
                            name: _name,
                            sdt: _sdt,
                            address: address,
                            isDefault: 0);
                        //Insert
                        ShippingAddressHandler.insertShippingAddress(
                            newShippingAddress);

                        print(newShippingAddress.address);
                      }

                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 30,
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
