import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Screen',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Hồ sơ',
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
              icon: SvgIconData('assets/icons/icon_search.svg'),
            ),
            onPressed: () {},
          ),
          actions: [
            IconButton(
                padding: const EdgeInsets.only(right: 12),
                icon: const SvgIcon(
                  icon: SvgIconData('assets/icons/icon_exit.svg'),
                  responsiveColor: false,
                  color: Color(0xff808080),
                  size: 24,
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (Route<dynamic> route) => false);
                }),
          ],
        ),
      ),
    );
  }
}
