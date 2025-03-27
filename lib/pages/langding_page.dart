import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/values/app_assets.dart';
import 'package:flutter_application_1/values/app_color.dart';
import 'package:flutter_application_1/values/app_style.dart';

class LangdingPage extends StatelessWidget {
  const LangdingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text('Welcome to', style: AppStyles.h3),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'English',
                      style: AppStyles.h2.copyWith(
                        color: AppColor.blackGray,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        'Quotes"',
                        textAlign: TextAlign.right,
                        style: AppStyles.h4.copyWith(height: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 76),
                child: RawMaterialButton(
                  shape: CircleBorder(),
                  fillColor: AppColor.lightBlue,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => HomePage()),
                      (router) => false,
                    );
                  },
                  child: Image.asset(
                    AppAssets.rightArrow,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
