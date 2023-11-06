import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:furniture_mcommerce_app/controllers/discount_controller.dart';
import 'package:furniture_mcommerce_app/models/discount.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SelectDiscountScreen extends StatefulWidget {
  const SelectDiscountScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return SelectDiscountScreenState();
  }
}

class SelectDiscountScreenState extends State<SelectDiscountScreen>{

  bool _enabled = true;
  static const double _endReachedThreshold = 200;
  final List<Discount> _discounts = [];
  bool _loading = true;
  bool _canLoadMore = true;
  int _page = 1;
  final int _limit = 20;
  late int _totalPage;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(_onScroll);
    _getDiscounts();
    super.initState();
  }

  void _getDiscounts() {
    _loading = true;
    DiscountController.fetchListDiscount(_page, _limit).then((dataFormServer) => {
      setState(() {
        _totalPage = dataFormServer.totalPage!;
        _discounts.addAll(dataFormServer.discounts as Iterable<Discount>);
        _loading = false;
        _enabled = !_enabled;
      })
    });
  }

  void _onScroll() {
    if (!_controller.hasClients || _loading){
      _canLoadMore = false;
      return;
    }

    final thresholdReached =
        _controller.position.extentAfter < _endReachedThreshold;

    if (thresholdReached) {
      if(_page < _totalPage){
        _page++;
        _getDiscounts();
      }
    }
  }

  Future<void> _refresh() async {
    _canLoadMore = true;
    _enabled = !_enabled;
    _discounts.clear();
    _page = 1;
    _getDiscounts();
    print('Refreshing...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Chọn mã giảm giá',
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
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Skeletonizer(
          enabled: _enabled,
          child: ListView.builder(
            itemBuilder: _buidItemDiscount,
            itemCount: _discounts.length,
          ),
        ),
      ),
    );
  }

  Widget _buidItemDiscount(BuildContext context, int index) {
      return Container(
        margin: const EdgeInsets.all(10),
        child: CouponCard(
          curveAxis: Axis.vertical,
          firstChild: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Giảm giá ${_discounts[index].value!}%',
                  textAlign:TextAlign.center,
                  style: const TextStyle(
                      fontFamily: 'NunitoSans',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xff303030)),
                ),
              ),Container(
                height: 2,
                width: 50,
                color: const Color(0xffF0F0F0),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextButton(
                  onPressed: (){
                    Navigator.pop(context, _discounts[index]);
                  },
                  child: const Text(
                    'Áp dụng',
                    textAlign:TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xff33FF33)),
                  ),
                ),
              )

            ],
          ),
          secondChild: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 20,),
                  child: Text(
                    _discounts[index].nameDiscount!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xff303030)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 20,),
                  child: RichText(
                    text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Sản phẩm áp dụng: ',
                            style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xff808080)),
                          ),
                          TextSpan(
                            text: _discounts[index].nameProduct!,
                            style: const TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Color(0xff808080)),
                          ),
                        ]
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 20,),
                  child: RichText(
                    text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Thời gian hiệu lực: ',
                            style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xff808080)),
                          ),
                          TextSpan(
                            text: 'Từ ${DateFormat('dd/MM/yyyy').format(DateTime.parse(_discounts[index].dayStart!))}'
                                ' đến ${DateFormat('dd/MM/yyyy').format(DateTime.parse(_discounts[index].dayEnd!))}',
                            style: const TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Color(0xff808080)),
                          ),
                        ]
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          shadow:  const BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0),
              blurRadius: 6.0),),
      );
  }

}