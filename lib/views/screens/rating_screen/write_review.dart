import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/controllers/ratingandreview_controller.dart';

import '../../../local_store/db/account_handler.dart';
import '../../../shared_resources/share_string.dart';
import '../login_screen/login_screen.dart';

// ignore: must_be_immutable
class WriteReviewScreen extends StatefulWidget{
  WriteReviewScreen({super.key, required this.idProduct, required this.nameProduct});
  String idProduct;
  String nameProduct;

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return WriteReviewScreenState(idProduct: idProduct, nameProduct: nameProduct);
  }
}

class WriteReviewScreenState extends State<WriteReviewScreen> {

  WriteReviewScreenState({required this.idProduct, required this.nameProduct});
  String idProduct;
  String nameProduct;

  int rating = 0;
  String? _errorReview;
  String? review;

  String? idUser;

  void _getIdUser() async {
    idUser = await AccountHandler.getIdUser();
  }

  @override
  void initState() {
    _getIdUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Write Review Screen',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Viết đánh giá',
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
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
                child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                            text: 'Viết đánh giá cho sản phẩm: ',
                            style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xff808080)),
                        ),
                        TextSpan(
                          text: nameProduct ?? '',
                          style: const TextStyle(
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xff242424)),
                        )
                      ]
                    ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(left: 10, bottom: 20),
                child: const Text(
                    'Điểm đánh giá',
                    style: TextStyle(
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xff808080)),
                )
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSelectStar(1),
                      _buildSelectStar(2),
                      _buildSelectStar(3),
                      _buildSelectStar(4),
                      _buildSelectStar(5),
                    ],
                  )
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                  margin: const EdgeInsets.only(top: 40, left: 10, bottom: 20),
                  child: const Text(
                    'Viết đánh giá cho sản phẩm:',
                    style: TextStyle(
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xff808080)),
                  )
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    onChanged: (value){
                        setState(() {
                            review = value;
                        });
                    },
                    onSubmitted: (value){
                      setState(() {
                        review = value;
                      });
                    },
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    maxLength: 200,
                    maxLines: 8,
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
                      hintText: 'Viết đánh giá cho sản phẩm....',
                      errorText: _errorReview,
                      hintStyle: const TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                          color: Color(0xffE0E0E0),
                          fontSize: 16),

                    ),
                  )
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                child: Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(340, 60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: const Text('Thêm đánh giá',
                          style: TextStyle(
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 20)),
                      onPressed: () async {
                        if(review == null || review!.isEmpty){
                            setState(() {
                                _errorReview = 'Đánh giá sản phẩm không để trống!';
                            });
                        }else {
                          setState(() {
                            _errorReview = null;
                          });
                        }

                        RatingAndReviewController.createReview(idUser!, idProduct, rating, review!).then((dataFromServer) => {
                            showDialogBox("Thông báo", dataFromServer.errMessage!, ShareString.CLOSE_DIALOG)
                        });
                      }
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectStar(int num){
    return GestureDetector(
      onTap: () {
          setState(() {
            if(rating == 1 && num == 1){
              rating = 0;
            }else{
              rating = num;
            }
          });
      },
      child: rating >= num ? const Icon(Icons.star, color: Colors.amber, size: 40,)
          : const Icon(Icons.star_border_outlined, color: Colors.amber, size: 40),
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