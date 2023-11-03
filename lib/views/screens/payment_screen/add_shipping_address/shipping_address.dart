import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/local_store/db/account_handler.dart';
import 'package:furniture_mcommerce_app/local_store/db/shipping_address_handler.dart';
import 'package:furniture_mcommerce_app/models/localstore/shipping_address.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/add_shipping_address/add_shipping_address.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return ShippingAddressScreenState();
  }
}

class ShippingAddressScreenState extends State<ShippingAddressScreen> {
  late int _isCheckedIndex;

  List<ShippingAddress> _listAddress = [];

  void _setIsCheckedIndex() {
    if(_listAddress.isEmpty){
      _isCheckedIndex = -1;
      return;
    }
    for (int i = 0; i < _listAddress.length; i++) {
      if (_listAddress[i].isDefault == 1){
        _isCheckedIndex = i;
        return;
      }
      else {
        _isCheckedIndex = -1;
      }
    }
  }

  void printTest() {
    for (int i = 0; i < _listAddress.length; i++) {
      print('${_listAddress[i].name}: ${_listAddress[i].isDefault}');
    }
  }

  void createListAddress() async {
    String idUser = await AccountHandler.getIdUser();
    if(idUser.isEmpty) return;
    List<ShippingAddress> datas = await ShippingAddressHandler.getListItemShippingAddress(idUser);
    setState(() {
      _listAddress = datas;
    });
  }

  @override
  void initState() {
    _setIsCheckedIndex();
    createListAddress();
    print(_listAddress.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Địa chỉ giao hàng',
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
      body: ListView.builder(
        itemBuilder: _buildItemAddress,
        itemCount: _listAddress.length,
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 30, right: 10),
        child: FloatingActionButton(
          onPressed: () async{
            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddShippingAddress(
                      isEdit: false,
                    )));

            createListAddress();
            print('$_isCheckedIndex');
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildItemAddress(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _listAddress[index].isDefault == 1,
                    onChanged: (bool? value) {
                      setState(() {
                        print('goi roi ne $value : index: $index idexCheck: $_isCheckedIndex');
                        print('${_listAddress[index].name} : index: $index');
                        value ?? false
                            ? _listAddress[index].isDefault = 1
                            : _listAddress[index].isDefault = 0;
                        if(_isCheckedIndex != -1 && _isCheckedIndex != index){
                          _listAddress[_isCheckedIndex].isDefault = 0;
                          ShippingAddressHandler.updateShippingAddress(_listAddress[_isCheckedIndex]);
                        }
                        _isCheckedIndex = index;
                        printTest();
                        ShippingAddressHandler.updateShippingAddress(_listAddress[index]);
                      });
                    },
                    checkColor: Colors.white,
                    activeColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  const Text(
                    'Đặt làm địa chỉ mặc định',
                    style: TextStyle(
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () async{
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddShippingAddress(
                                      isEdit: true,
                                      shippingAddress: _listAddress[index],
                                    )));
                        createListAddress();
                      },
                      icon: const SvgIcon(
                          icon: SvgIconData('assets/icons/icon_edit.svg'))),
                  IconButton(
                      onPressed: () {
                        ShippingAddressHandler.deleteItemShippingAddress(_listAddress[index].id, _listAddress[index].idUser);
                        createListAddress();
                        if(_listAddress.isEmpty) _isCheckedIndex = -1;
                      },
                      icon: const SvgIcon(
                          icon: SvgIconData('assets/icons/icon_bin.svg')))
                ],
              )
            ],
          ),
          GestureDetector(
            onTap: () {
                Navigator.pop(context, _listAddress[index]);
            },
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
                          '${_listAddress[index].name} | ${_listAddress[index].sdt}',
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
                          _listAddress[index].address,
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
          const SizedBox(
            width: 30,
            height: 20,
          )
        ],
      ),
    );
  }
}

// List<ShippingAddress> _listAddress = [
//   ShippingAddress(
//       id: 1,
//       id_user: 'U01',
//       name: 'Phạm Văn A',
//       sdt: '0123456789',
//       address: '27, mậu thân, ninh kiều, cần thơ',
//       isDefault: false),
//   ShippingAddress(
//       id: 1,
//       id_user: 'U01',
//       name: 'Phạm Văn A',
//       sdt: '0123456789',
//       address: '27, mậu thân, ninh kiều, cần thơ',
//       isDefault: false),
//   ShippingAddress(
//       id: 2,
//       id_user: 'U01',
//       name: 'Phạm Bảo Trí',
//       sdt: '0123456789',
//       address: '25 rue Robert Latouche, Nice, 06200, Côte D’azur, France',
//       isDefault: true),
//   ShippingAddress(
//       id: 3,
//       id_user: 'U01',
//       name: 'Phạm Văn C',
//       sdt: '0123456789',
//       address: '27, mậu thân, ninh kiều, cần thơ',
//       isDefault: false),
//   ShippingAddress(
//       id: 4,
//       id_user: 'U01',
//       name: 'Phạm Văn D',
//       sdt: '0123456789',
//       address: '27, mậu thân, ninh kiều, cần thơ',
//       isDefault: false),
// ];
