import 'package:coffie_shop/core/constants/image_constiant.dart';
import 'package:flutter/material.dart';

class MyHomeBanner extends StatelessWidget {
  const MyHomeBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Image.asset(MyAppImage.banner),

    );
  }
}