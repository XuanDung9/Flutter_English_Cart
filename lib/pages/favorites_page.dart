import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/english_today.dart';
import 'package:flutter_application_1/values/app_assets.dart';
import 'package:flutter_application_1/values/app_color.dart';
import 'package:flutter_application_1/values/app_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesWordPage extends StatefulWidget {
  const FavoritesWordPage({Key? key}) : super(key: key);

  @override
  _FavoritesWordPageState createState() => _FavoritesWordPageState();
}

class _FavoritesWordPageState extends State<FavoritesWordPage> {
  List<EnglishToday> favoriteWords = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteWords(); // Gọi hàm để lấy danh sách yêu thích
  }

  // 📝 Hàm lấy danh sách từ yêu thích từ SharedPreferences
  Future<void> _loadFavoriteWords() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? favoriteWordsJson = prefs.getStringList('favoriteWords');

    if (favoriteWordsJson == null) return;

    setState(() {
      favoriteWords =
          favoriteWordsJson
              .map((json) => EnglishToday.fromJson(jsonDecode(json)))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.lightBlue,
        title: Text(
          'Favorite words',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.textColor, fontSize: 36),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(AppAssets.leftArrow),
        ),
      ),
      body: Container(
        color: AppColor.lightBlue,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: favoriteWords.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color:
                      (index % 2) == 0
                          ? AppColor.primaryColor
                          : AppColor.secondColor,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),

                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  title: Text(
                    favoriteWords[index].noun!,
                    style:
                        (index % 2) == 0
                            ? AppStyles.h4
                            : AppStyles.h4.copyWith(color: AppColor.textColor),
                  ),
                  subtitle: Text(favoriteWords[index].quote ?? 'Not quote'),
                  leading: Icon(Icons.favorite, color: Colors.red),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
