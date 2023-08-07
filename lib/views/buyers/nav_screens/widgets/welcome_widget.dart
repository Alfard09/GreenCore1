import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Welcome extends StatelessWidget {
  const Welcome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          "assets/images/logo_1.png",
          width: 100,
        ),
        Container(
          child: SvgPicture.asset(
            'assets/icons/cart.svg',
          ),
        )
      ],
    );
  }
}
