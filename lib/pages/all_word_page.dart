import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/english_today.dart';
import 'package:flutter_application_1/values/app_assets.dart';
import 'package:flutter_application_1/values/app_color.dart';
import 'package:flutter_application_1/values/app_style.dart';

class AllWordPage extends StatelessWidget {
  final List<EnglishToday> words;
  const AllWordPage({Key? key, required this.words}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.secondColor,
        title: Text(
          'English today',
          textAlign: TextAlign.center,
          style: AppStyles.h3.copyWith(color: AppColor.textColor, fontSize: 36),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(AppAssets.leftArrow),
        ),
      ),
      body: Container(
        child: GridView.count(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children:
              words
                  .map(
                    (e) => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.blackGray.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: AutoSizeText(
                        e.noun ?? '',
                        style: AppStyles.h3.copyWith(
                          shadows: [
                            BoxShadow(
                              color: Colors.black38,
                              offset: Offset(3, 6),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
