import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:furniture_mcommerce_app/views/screens/cart_screen/cart_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/favorites_screen/favorites_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/home_screen/home_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/login_screen/login_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/notify_screen/notify_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/profile_screen/profile_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/search_screen/search_screen.dart';
//import 'package:furniture_mcommerce_app/views/screens/home_screen/home_screen.dart';
//import 'package:furniture_mcommerce_app/views/screens/product_screen/product_screen.dart';
//import 'package:furniture_mcommerce_app/views/screens/signup_screen/signup_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/boarding_screen/boarding_screen.dart';
//import 'package:furniture_mcommerce_app/views/screens/login_screen/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Furniture Store',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/cart': (context) => const CartScreen(),
          '/search': (context) => const SearchScreen()
        },
        home: const LoginScreen());
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences pref;
  int _selectedIndex = 0;

  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    checkFirstInstall();
    super.initState();
  }

  Future<void> checkFirstInstall() async {
    pref = await _prefs;
    final result = pref.getBool('FirstInstall') ?? true;
    if(result){
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BoardingScreen()));
    }
  }

  void  getConnectivity() {
    print('object');
    subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() {
              isAlertSet = true;
            });
          }
        });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  List<Widget> screenList = [
    const HomeScreen(),
    const FavoritesScreen(),
    const NotificationScreen(),
    const ProfileScreen()
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: SvgIcon(
                icon: _selectedIndex == 0
                    ? const SvgIconData('assets/icons/icon_home_selected.svg')
                    : const SvgIconData('assets/icons/icon_home.svg')),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgIcon(
                icon: _selectedIndex == 1
                    ? const SvgIconData('assets/icons/icon_mark_selected.svg')
                    : const SvgIconData('assets/icons/icon_mark.svg')),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgIcon(
                icon: _selectedIndex == 2
                    ? const SvgIconData('assets/icons/icon_bell_selected.svg')
                    : const SvgIconData('assets/icons/icon_bell.svg')),
            label: '',
          ),
          BottomNavigationBarItem(
              icon: SvgIcon(
                  icon: _selectedIndex == 3
                      ? const SvgIconData('assets/icons/icon_user_selected.svg')
                      : const SvgIconData('assets/icons/icon_user.svg')),
              label: ''),
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        iconSize: 24,
        elevation: 5,
        selectedItemColor: Colors.black,
        unselectedItemColor: const Color(0xff999999),
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }

  showDialogBox() => showDialog<String>(
    context: context,
    builder: (BuildContext context) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Không có kết nối mạng. Kiểm tra lại kết nối của bạn.'),
            const SizedBox(height: 15,),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() {
                  isAlertSet = false;
                });
                isDeviceConnected = await InternetConnectionChecker().hasConnection;
                if(!isDeviceConnected){
                  showDialogBox();
                  setState(() {
                    isAlertSet = false;
                  });
                }
              },
              child: const Text('OK'),)
          ],
        ),
      ),
    )
  );
}
