import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/models/authorization.dart';
import 'package:furniture_mcommerce_app/views/screens/profile_screen/edit_profile.dart';

// ignore: must_be_immutable
class DetailProfile extends StatefulWidget {
  DetailProfile({super.key, required this.user});

  User user;

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return DetailProfileState(user: user);
  }
}

class DetailProfileState extends State<DetailProfile> {
  DetailProfileState({required this.user});
  User user;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Detail Profile',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Chi tiết hồ sơ',
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
                  child: Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircleAvatar(
                          backgroundImage: (user.avatar ?? '') == '' ? const AssetImage('assets/images/img_avatar.png') as ImageProvider
                              : NetworkImage(user.avatar ?? '')
                      ),
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
                            'Họ và tên:',
                            style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xff808080)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(
                           user.fullName ?? '',
                            style: const TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black),
                            softWrap: true,
                            overflow: TextOverflow.clip,
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
                            'Số điện thoại:',
                            style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xff808080)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(
                            user.sdtUser ?? 'Chưa nhập số điện thoại',
                            style: const TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black),
                            softWrap: true,
                            overflow: TextOverflow.clip,
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
                            'Giới tính:',
                            style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xff808080)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(
                            user.gender ?? 'Chưa nhập giới tính.',
                            style: const TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black),
                            softWrap: true,
                            overflow: TextOverflow.clip,
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
                            'Email:',
                            style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xff808080)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(
                            user.email ?? 'Chưa nhập email',
                            style: const TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black),
                            softWrap: true,
                            overflow: TextOverflow.clip,
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
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(
                            user.dateOfBirth ?? 'Chưa nhập ngày sinh',
                            style: const TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black),
                            softWrap: true,
                            overflow: TextOverflow.clip,
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
                        child: const Text('Chỉnh sửa hồ sơ',
                            style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w600,
                                fontSize: 20)),
                        onPressed: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(user: user)));
                          }
                      ),
                    ),
                  ),
                )
              ],
          ),
        ),
      ),
    );
  }

}