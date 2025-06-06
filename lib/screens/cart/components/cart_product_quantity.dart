import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';

class CartProductQuantity extends StatelessWidget {
  const CartProductQuantity({
    super.key,
    required this.numOfItem,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int numOfItem;
  final VoidCallback onIncrement, onDecrement;

  @override
  Widget build(BuildContext context) {
    return 
        Row(
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: OutlinedButton(
                onPressed: onDecrement,
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(defaultPadding / 2)),
                child: SvgPicture.asset(
                  "assets/icons/Minus.svg",
                  height: 18,
                  color: Theme.of(context).iconTheme.color,

                ),
              ),
            ),
            SizedBox(
              width: 30,
              child: Center(
                child: Text(
                  numOfItem.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              height: 30,
              width: 30,
              child: OutlinedButton(
                onPressed: onIncrement,
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(defaultPadding / 2)),
                child: SvgPicture.asset(
                  "assets/icons/Plus1.svg",
                  height: 18,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
          ],
        );
    
  }
}
