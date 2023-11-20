import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/controllers/ratingandreview_controller.dart';
import 'package:furniture_mcommerce_app/models/rating.dart';
import 'package:furniture_mcommerce_app/views/screens/home_screen/list_category.dart';
import 'package:furniture_mcommerce_app/views/screens/rating_screen/write_review.dart';
import 'package:intl/intl.dart';

import '../../../local_store/db/account_handler.dart';

// ignore: must_be_immutable
class RatingScreen extends StatefulWidget {
  RatingScreen({super.key, required this.imgUrl, required this.idProduct, required this.nameProduct});
  String imgUrl;
  String idProduct;
  String nameProduct;

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return RatingScreenState(imgUrl: imgUrl, idProduct: idProduct, nameProduct: nameProduct);
  }
}

class RatingScreenState extends State<RatingScreen>{
  RatingScreenState({required this.imgUrl, required this.idProduct, required this.nameProduct});

  String imgUrl;
  String idProduct;
  String nameProduct;


  List<Review> _list = [];
  Ratings rating = Ratings();

  final ScrollController _controller = ScrollController();
  static const double _endReachedThreshold = 200;
  bool _loading = true;
  bool _canLoadMore = false;
  bool hide = false;
  int page = 1;
  int limit = 6;
  late int totalPage;

  String? idUser;

  @override
  void initState() {
    _controller.addListener(_onScroll);
    _getListReview();
    _getIdUser();
    _getRating();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _getIdUser() async {
    idUser = await AccountHandler.getIdUser();
  }

  void _getRating() {
    RatingAndReviewController.fetchRating(idProduct).then((dataFormServer) => {
      if(dataFormServer.errCode == 0){
        setState((){
          rating = dataFormServer.ratings!;
        })
      }
    });
  }

  void _getListReview() {
      _loading = true;
      RatingAndReviewController.fetchListReview(page, limit, idProduct).then((dataFromServer) => {
        setState((){
            if(dataFromServer.errCode == 0){
                _list.addAll(dataFromServer.reviews!);
                totalPage = dataFromServer.totalPage!;
                _loading = false;
                if(dataFromServer.totalPage! > 1){
                  _canLoadMore = true;
                }
                for(var item in dataFromServer.reviews!){
                    if(item.idUser == idUser){
                        hide = true;
                        return;
                    }
                }
            }
        }),
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
      if(page < totalPage){
        page++;
        _getListReview();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rating Screen',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Đánh giá sản phẩm',
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
        body: Stack(
          children: [
            (rating.numReviews ?? 0) > 0 ?
            CustomScrollView(
              controller: _controller,
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Stack(
                          children: [
                            Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.network(imgUrl, fit: BoxFit.contain,),
                            ),
                            Positioned(
                                top: 20,
                                left: 170,
                                child: Container(
                                  width: 160,
                                  child: Text(
                                      rating.nameProduct ?? '',
                                      style: const TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color(0xff242424)),
                                      softWrap: true,
                                      overflow: TextOverflow.clip,
                                  ),
                                )
                            ),
                            const Positioned(
                                top: 60,
                                left: 170,
                                child: Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 40,
                                )
                            ),
                            Positioned(
                                top: 65,
                                left: 220,
                                child: Text(
                                   rating.aVGPoint ?? '',
                                    style: const TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24,
                                        color: Color(0xff303030))),
                            ),
                            Positioned(
                                top: 110,
                                left: 170,
                                child: Container(
                                  width: 210,
                                  child: Text(
                                    '${rating.numReviews} đánh giá',
                                    style: const TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Color(0xff242424)),
                                    softWrap: true,
                                    overflow: TextOverflow.clip,
                                  ),
                                )
                            ),
                          ],
                      ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 1,
                    color: const Color(0xffF0F0F0),
                  ),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        _buildItemReview,
                        childCount: _list.length
                    ),
                ),
                SliverToBoxAdapter(
                  child: _canLoadMore
                      ? Container(
                        padding: const EdgeInsets.only(bottom: 16),
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                  )
                      : const SizedBox(),
                ),
              ],
            )
            : _buildNoteNoItem(context),
            hide == true ? const SizedBox() : Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: Size(MediaQuery.of(context).size.width, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text('Viết đánh giá',
                      style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 20)),
                  onPressed: () async {
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              WriteReviewScreen(idProduct: idProduct, nameProduct: nameProduct)));

                      print('Màn hình B đã được đóng!');
                      _getListReview();
                      _getRating();
                      page = 1;
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNoteNoItem(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.all(10),
              width: 100,
              height: 100,
              child: const SvgIcon(
                  icon: SvgIconData('assets/icons/icon_review.svg'))),
          Container(
            margin: const EdgeInsets.all(20),
            child: const Text(
              'Không có đáng giá nào.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Gelasio',
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: Color(0xff242424)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemReview(BuildContext context, int index) {
    return Stack(
      children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: 210,
              margin: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
              child:  Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ClipRRect(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(bottom: 6.0),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0),
                              blurRadius: 6.0)
                        ]),
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                    _list[index].fullName ?? '',
                                    style: const TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Color(0xff242424)),
                                ),
                              ),Text(
                                DateFormat('dd/MM/yyyy').format(DateTime.parse(_list[index].timeCreate!)),
                                style: const TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Color(0xff808080)),
                              )
                            ],
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: _buildStart(_list[index].point ?? 0)
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Text(
                                _list[index].comment ?? '',
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color(0xff242424)),
                              )
                          ),
                        ],
                      )
                    ),
                  ),
                ),
              ),
          ),
          Positioned(
              top: 10,
              left: MediaQuery.of(context).size.width/2 - 20,
              right: MediaQuery.of(context).size.width/2 - 20,
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircleAvatar(
                // ignore: unnecessary_null_comparison
                  backgroundImage: _list[index].avatar == null ? const AssetImage('assets/images/img_avatar.png') as ImageProvider
                      : NetworkImage(_list[index].avatar ?? '')
              ),
            ),
          )
      ],
    );
  }

  Widget _buildStart(int rating){
    return Row(
      children: [
          rating >= 1 ? const Icon(Icons.star, color: Colors.amber,) : const SizedBox(),
          rating >= 2 ? const Icon(Icons.star, color: Colors.amber,) : const SizedBox(),
          rating >= 3 ? const Icon(Icons.star, color: Colors.amber,) : const SizedBox(),
          rating >= 4 ? const Icon(Icons.star, color: Colors.amber,) : const SizedBox(),
          rating >= 5 ? const Icon(Icons.star, color: Colors.amber,) : const SizedBox(),
      ],
    );
  }

}