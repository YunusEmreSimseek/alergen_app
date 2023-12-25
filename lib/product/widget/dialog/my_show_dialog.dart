import 'package:alergen_app/product/widget/text/sub_title_text.dart';
import 'package:alergen_app/product/widget/text/title_text.dart';
import 'package:flutter/material.dart';

class MyShowDialog {
  static Future<dynamic> newMethod(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              title: TitleText(title: 'Kayıt Başarılı'),
              content: SubtitleText(title: 'Kaydınız başarıyla yapılmıştır birazdan ana sayfaya yönlendirileceksiniz.'),
              actions: [],
            ));
  }
}
