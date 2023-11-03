import 'package:flutter/material.dart';
import 'package:furniture_mcommerce_app/models/states/provider_animationaddtocart.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class AnimationAddToCart extends StatefulWidget {
  const AnimationAddToCart({super.key});

  @override
  State<StatefulWidget> createState() {
    return AnimationAddToCartState();
  }
}

class AnimationAddToCartState extends State<AnimationAddToCart> with TickerProviderStateMixin {

  late final AnimationController _controllerAnimation;


  @override
  void initState() {
    _controllerAnimation = AnimationController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final animationAddToCartState = Provider.of<ProviderAnimationAddToCart>(context, listen: true);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.6),
              ],
            )),
        child: Lottie.asset(
            'assets/animations/addtocart_animation.json',
            width: 100,
            height: 100,
            controller: _controllerAnimation,
            onLoaded: (composition) {
              _controllerAnimation
                ..duration = composition.duration
                ..reset()
                ..forward().whenComplete(() => {
                  animationAddToCartState.changeStateAnimation(),
                });
            },
            alignment: const Alignment(0, 0)
        ),
      ),
    );
  }

}