import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/models/product.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:expandable_text/expandable_text.dart';

import '../home_screen/product_item.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return ProductScreenState();
  }
}

class ProductScreenState extends State<ProductScreen> {
  late PageController _pageController;
  int activePage = 0;
  int review = 50;
  int quantity = 1;
  String size = 'D2300 - R800 - C760 mm';
  String material = 'Khung gỗ Ash - nệm bọc vải';
  String des = 'Sofa Coastal gây ấn tượng bằng những đường cong bồng bềnh,'
      ' theo xu hướng Modern Organic – gần gũi với thiên nhiên mà vẫn hiện đại, thoải mái. '
      'Điểm đặc biệt của BST lần này nằm ở sự tỉ mỉ của những người thợ thủ công lành nghề, '
      'họ đã hoàn thành những đường may uốn lượn không tì vết, mang đến một thiết kế chỉn chu, '
      '"cân" mọi góc nhìn. Cảm giác êm ái và thư thái sẽ là những tính từ đầu tiên được nhắc đến khi trải nghiệm sofa Coastal.';

  final List<Product> _products = [
    Product(
        name: 'Minimal Stand',
        price: 2000000.0,
        urlIamge: 'assets/images/img_product.png'),
    Product(
        name: 'Minimal Stand',
        price: 2000000.0,
        urlIamge: 'assets/images/img_product.png'),
    Product(
        name: 'Minimal Stand',
        price: 2000000.0,
        urlIamge: 'assets/images/img_product.png'),
    Product(
        name: 'Minimal Stand',
        price: 2000000.0,
        urlIamge: 'assets/images/img_product.png'),
  ];

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 1.0, initialPage: 0);

    super.initState();
  }

  Widget _buildProductItem(BuildContext context, int index) {
    return ProductItem(_products[index]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Screen',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                  leading: IconButton(
                    icon: const SvgIcon(
                      icon: SvgIconData('assets/icons/icon_back.svg'),
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  backgroundColor: Colors.white,
                  expandedHeight: 250.0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 250,
                            child: PageView.builder(
                              itemCount: images.length,
                              pageSnapping: true,
                              controller: _pageController,
                              itemBuilder: (context, pagePosition) {
                                return Container(
                                    width: MediaQuery.of(context).size.width,
                                    //margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        //color: Colors.amber,
                                        image: DecorationImage(
                                            image: AssetImage(
                                                images[pagePosition]),
                                            fit: BoxFit.contain)));
                              },
                            )),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: images.length,
                          effect: const ExpandingDotsEffect(
                              dotHeight: 2,
                              dotWidth: 6,
                              dotColor: Color(0xff999999),
                              activeDotColor: Color(0xff303030)),
                        ),
                      ],
                    ),
                  )),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: const Text(
                    'Sofa Coastal 2 chỗ KD1085-18 xanh M2',
                    style: TextStyle(
                        fontFamily: 'Gelasio',
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: Color(0xff303030)),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Text(
                    NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                        .format(200000000),
                    style: const TextStyle(
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                        color: Color(0xff303030)),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('mo danh gia');
                      },
                      child: Row(children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 30,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          child: const Text(
                            '4.5',
                            style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Color(0xff303030)),
                          ),
                        ),
                        Container(
                          margin:
                              const EdgeInsets.only(top: 4, left: 4, right: 30),
                          child: Text(
                            '($review đánh giá)',
                            style: const TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Color(0xff808080)),
                          ),
                        ),
                      ]),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              size: 30,
                              color: Color(0xff303030),
                            ),
                            onPressed: () {
                              if (quantity == 1) {
                                return;
                              }
                              setState(() {
                                quantity--;
                              });
                            },
                          )),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          quantity.toString(),
                          style: const TextStyle(
                              fontFamily: 'Gelasio',
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: Color(0xff303030)),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline,
                              size: 30,
                              color: Color(0xff303030),
                            ),
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                          )),
                    ]),
                  ],
                ),
              )),
              SliverToBoxAdapter(
                child: Container(
                    margin: const EdgeInsets.only(left: 10, top: 20),
                    child: Text('Kích thước: $size',
                        style: const TextStyle(
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xff606060)))),
              ),
              SliverToBoxAdapter(
                child: Container(
                    margin: const EdgeInsets.only(left: 10, top: 20),
                    child: Text('Vật liệu: $material',
                        style: const TextStyle(
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xff606060)))),
              ),
              SliverToBoxAdapter(
                  child: Container(
                      margin: const EdgeInsets.only(left: 10, top: 20),
                      child: ExpandableText(
                        'Mô tả sản phẩm: \n$des',
                        expandText: "Xem thêm",
                        collapseText: 'Thu gọn',
                        maxLines: 3,
                        style: const TextStyle(
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xff606060)),
                        linkColor: const Color(0xff242424),
                      ))),
              SliverToBoxAdapter(
                child: _products.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.all(10),
                        child: const Center(
                          child: Text(
                            'Sản phẩm tương tự',
                            style: TextStyle(
                                fontFamily: 'Gelasio',
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                                color: Color(0xff303030)),
                          ),
                        ),
                      )
                    : const SizedBox(
                        width: 70,
                        height: 50,
                      ),
              ),
              _products.isNotEmpty
                  ? SliverPadding(
                      padding: const EdgeInsets.all(10),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(_buildProductItem,
                            childCount: _products.length),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 4 / 6,
                        ),
                      ),
                    )
                  : const SliverToBoxAdapter(
                      child: SizedBox(
                        width: 70,
                        height: 50,
                      ),
                    ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  width: 70,
                  height: 100,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xffF0F0F0),
                    ),
                    child: IconButton(
                        onPressed: () {
                          int a = products.length;
                          print('$a');
                        },
                        icon: const SvgIcon(
                            icon: SvgIconData('assets/icons/icon_mark.svg'))),
                  ),
                  const SizedBox(
                    width: 20,
                    height: 20,
                  ),
                  Expanded(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(250, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: const Text('Thêm vào giỏ hàng',
                        style: TextStyle(
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 20)),
                    onPressed: () {},
                  )),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

List<String> images = [
  'assets/images/img_sofa.jpg',
  'assets/images/img_sofa.jpg',
  'assets/images/img_sofa.jpg',
  'assets/images/img_sofa.jpg',
  'assets/images/img_sofa.jpg',
];
