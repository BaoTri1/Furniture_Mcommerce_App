import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniture_mcommerce_app/models/states/provider_animationaddtocart.dart';
import 'package:furniture_mcommerce_app/models/states/provider_animationaddtofavorite.dart';
import 'package:furniture_mcommerce_app/views/screens/order_screen/order_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/order_success_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/payment_screen/select_discount/select_discount_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/search_screen/product_search.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:furniture_mcommerce_app/controllers/authorization_controller.dart';
import 'package:furniture_mcommerce_app/local_store/db/account_handler.dart';
import 'package:furniture_mcommerce_app/models/localstore/account.dart';
import 'package:furniture_mcommerce_app/models/states/provider_itemcart.dart';
import 'package:furniture_mcommerce_app/models/states/provider_itemfavorite.dart';
import 'package:furniture_mcommerce_app/shared_resources/share_method.dart';
import 'package:furniture_mcommerce_app/views/screens/cart_screen/cart_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/favorites_screen/favorites_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/home_screen/home_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/login_screen/login_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/notify_screen/notify_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/profile_screen/profile_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/search_screen/search_screen.dart';
import 'package:furniture_mcommerce_app/views/screens/boarding_screen/boarding_screen.dart';


void main() async{
  await dotenv.load(fileName: ".env");
  Stripe.publishableKey = dotenv.env["PUBLISHABLE_KEY"] ?? "";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProviderItemFavorite()),
        ChangeNotifierProvider(create: (context) => ProviderItemCart()),
      ],
      child: MaterialApp(
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
          home: WillPopScope(
            onWillPop: () async {
              // Thực hiện các công việc cuối cùng trước khi thoát ứng dụng ở đây.
              print('Thực hiện công việc cuối cùng trước khi thoát ứng dụng.');
              // Gọi SystemNavigator.pop() để thoát ứng dụng.
              SystemNavigator.pop();
              return true; // Trả về true vì SystemNavigator.pop() sẽ làm thoát ứng dụng.
            },
            child: const OrderScreen(),
        )
      ),
    );
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
  late Account account;
  int _selectedIndex = 0;

  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    autoLogin();
    getConnectivity();
    checkFirstInstall();
    super.initState();
  }


  void autoLogin() async {
    int count = await AccountHandler.countItem();
    account = await AccountHandler.getAccount();
    if(count > 0){
      print('co tai khoan');
      print('${account.sdt} + ${account.passwd}');
      // ignore: use_build_context_synchronously
      if(await ShareMethod.checkInternetConnection(context)){
        if(await AccountHandler.checkIsLogin() == true){
          AuthorizationController.loginHandler(account.sdt, account.passwd).then((dataFormServer) => {
            if(dataFormServer.errCode != 0){
              AccountHandler.setStateLogin(account.id, 0, ''),
            }else{
              AccountHandler.setStateLogin(account.id, 1, dataFormServer.accessToken!),
              print('tự động đăng nhập thành công')
            }
          });
        }
      }else{
        showDialogBox('Lỗi kết nối', 'Không có kết nối mạng. Hãy kiểm tra lại kết nối của bạn!');
      }
    }else{
      print('ko co tai khoan');
    }
  }

  Future<void> checkFirstInstall() async {
    pref = await _prefs;
    final result = pref.getBool('FirstInstall') ?? true;
    if (result) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BoardingScreen()));
    }
  }

  void getConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && isAlertSet == false) {
        showDialogBox("Lỗi kết nối mạng", "Không có kết nối mạng. Kiểm tra lại kết nối của bạn.");
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
        bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final itemFavoriteState = Provider.of<ProviderItemFavorite>(context, listen: true);
    return BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: SvgIcon(
                      icon: _selectedIndex == 0
                          ? const SvgIconData('assets/icons/icon_home_selected.svg')
                          : const SvgIconData('assets/icons/icon_home.svg')),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Stack(children: [
                    Container(
                      width: 40,
                      height: 30,
                    ),
                    Positioned(
                      top: 4,
                      child: SvgIcon(
                          icon: _selectedIndex == 1
                              ? const SvgIconData('assets/icons/icon_mark_selected.svg')
                              : const SvgIconData('assets/icons/icon_mark.svg')),
                    ),
                    itemFavoriteState.getCountItemFavorite > 0 ?
                    Positioned(
                      right: itemFavoriteState.getCountItemFavorite > 99 ? 0: 10,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          itemFavoriteState.getCountItemFavorite > 99 ?
                            '+99' : '${itemFavoriteState.getCountItemFavorite}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : const SizedBox()
                  ]),
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
              iconSize: 26,
              elevation: 5,
              selectedItemColor: Colors.black,
              unselectedItemColor: const Color(0xff999999),
              onTap: (value) {
                setState(() {
                  _selectedIndex = value;
                });
              },
            );
  }

  void showDialogBox(String title, String message) {
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
                      Navigator.pop(context);
                      setState(() {
                        isAlertSet = false;
                      });
                      isDeviceConnected =
                          await InternetConnectionChecker().hasConnection;
                      if (!isDeviceConnected) {
                        showDialogBox("Lỗi kết nối mạng", "Không có kết nối mạng. Kiểm tra lại kết nối của bạn.");
                        setState(() {
                          isAlertSet = false;
                        });
                      }
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
            ));
  }
}

