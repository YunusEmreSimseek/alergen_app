import 'package:alergen_app/product/model/product_model.dart';
import 'package:alergen_app/product/widget/text/bold_text.dart';
import 'package:alergen_app/product/widget/text/sub_title_text.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({super.key, required this.currentProduct});

  final ProductModel currentProduct;
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Image.network(
        currentProduct.imageUrl!,
        height: context.sized.dynamicHeight(.12),
        width: context.sized.dynamicWidth(.3),
        fit: BoxFit.contain,
      ),
      context.sized.emptySizedWidthBoxHigh,
      SizedBox(
        width: context.sized.dynamicWidth(.51),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoldText(title: currentProduct.name!),
            context.sized.emptySizedHeightBoxLow,
            SubtitleText(title: currentProduct.content!),
          ],
        ),
      )
    ]);
  }
}
