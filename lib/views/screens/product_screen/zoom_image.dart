import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zoom_widget/zoom_widget.dart';

// ignore: must_be_immutable
class ZoomImage extends StatefulWidget {
  ZoomImage({super.key, required this.listImg});

  List<String> listImg;

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return ZoomImageState(listImg: listImg);
  }

}

class ZoomImageState extends State<ZoomImage> {
  ZoomImageState({required this.listImg});
  List<String> listImg;

  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 1.0, initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 150,
                  //height: 300,
                  child: PageView.builder(
                    itemCount: listImg.length,
                    pageSnapping: true,
                    controller: _pageController,
                    itemBuilder: (context, pagePosition) {
                      return Zoom(
                        initTotalZoomOut: true,
                        child: Center(
                          child: Image.network(listImg[pagePosition], width: MediaQuery.of(context).size.width,),
                        ),
                      );
                    },
                  )),
              const SizedBox(
                width: 10,
                height: 10,
              ),
              listImg.isEmpty ?
              const SizedBox(
                width: 10,
                height: 10,
              ) : SmoothPageIndicator(
                controller: _pageController,
                count: listImg.length,
                effect: const ExpandingDotsEffect(
                    dotHeight: 2,
                    dotWidth: 6,
                    dotColor: Color(0xff999999),
                    activeDotColor: Color(0xff303030)),
              ),
            ],
          ),
      ),
    );
  }
}