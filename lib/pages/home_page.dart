import 'dart:convert';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/english_today.dart';
import 'package:flutter_application_1/package/quote/quote.dart';
import 'package:flutter_application_1/package/quote/quote_model.dart';
import 'package:flutter_application_1/pages/all_word_page.dart';
import 'package:flutter_application_1/pages/control_page.dart';
import 'package:flutter_application_1/pages/favorites_page.dart';
import 'package:flutter_application_1/values/app_assets.dart';
import 'package:flutter_application_1/values/app_color.dart';
import 'package:flutter_application_1/values/app_style.dart';
import 'package:flutter_application_1/values/share_key.dart';
import 'package:flutter_application_1/widgets/app_button.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  List<EnglishToday> words = [];
  List<String> favoriteWordS = [];
  String? quote = Quotes().getRandom().content;

  List<int> fixedListRamdom({int len = 1, int max = 120, int min = 1}) {
    if (len > max || len < min) {
      return [];
    }
    List<int> newList = [];

    Random random = Random();
    int count = 1;
    while (count <= len) {
      int val = random.nextInt(max);
      if (newList.contains(val)) {
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  // get
  // Future<void> _loadFavoriteWords() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   List<String>? favoriteWordsJson = prefs.getStringList('favoriteWords');

  //   if (favoriteWordsJson == null) return;

  //   setState(() {
  //     favoriteWordS = favoriteWordsJson.toList();
  //   });
  // }

  Future<void> saveFavoriteWords(List<EnglishToday> words) async {
    final prefs = await SharedPreferences.getInstance();

    // 🔹 Lấy danh sách từ yêu thích đã lưu trước đó
    List<String>? oldFavoritesJson = prefs.getStringList('favoriteWords');
    List<EnglishToday> oldFavorites =
        oldFavoritesJson != null
            ? oldFavoritesJson
                .map((json) => EnglishToday.fromJson(jsonDecode(json)))
                .toList()
            : [];

    // 🔹 Lấy danh sách từ mới yêu thích
    List<EnglishToday> newFavorites =
        words.where((word) => word.isFavorite == true).toList();
    // xóa từ mới khi ko like nữa
    newFavorites =
        newFavorites
            .where(
              (oldWord) => words.any(
                (w) => w.noun == oldWord.noun && (w.isFavorite ?? false),
              ),
            )
            .toList();

    // 🔹 Thêm các từ mới vào danh sách cũ (tránh trùng lặp)
    for (var word in newFavorites) {
      if (!oldFavorites.any((oldWord) => oldWord.noun == word.noun)) {
        oldFavorites.add(word);
      }
    }

    // 🔹 Chuyển danh sách thành JSON để lưu trữ
    List<String> favoriteWordsJson =
        oldFavorites.map((word) => jsonEncode(word.toJson())).toList();

    await prefs.setStringList('favoriteWords', favoriteWordsJson);
  }

  getEnglishToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int len = prefs.getInt(ShareKeys.counter) ?? 5;
    List<String> newList = [];
    List<int> rans = fixedListRamdom(len: len, max: nouns.length);
    rans.forEach((index) {
      newList.add(nouns[index]);
    });

    setState(() {
      words = newList.map((e) => getQuote(e)).toList();
    });
  }

  EnglishToday getQuote(String noun) {
    Quote? quote;
    quote = Quotes.getByWord(noun);
    return EnglishToday(noun: noun, quote: quote?.content, id: quote?.id);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.8);
    // _loadFavoriteWords();

    getEnglishToday();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.secondColor,
      appBar: AppBar(
        backgroundColor: AppColor.secondColor,
        title: Text(
          'English today',
          textAlign: TextAlign.center,
          style: AppStyles.h3.copyWith(color: AppColor.textColor, fontSize: 36),
        ),
        leading: InkWell(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Image.asset(AppAssets.menu),
        ),
      ),

      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: size.height * 1 / 10,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              // margin: const EdgeInsets.symmetric(horizontal: 24),
              alignment: Alignment.centerLeft,
              child: Text(
                '"$quote"',
                style: AppStyles.h5.copyWith(
                  fontSize: 16,
                  color: AppColor.textColor,
                ),
              ),
            ),
            Container(
              height: size.height * 2 / 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: words.length,
                itemBuilder: (context, index) {
                  String firstLetter =
                      words[index].noun != null ? words[index].noun! : '';
                  firstLetter = firstLetter.substring(0, 1);

                  String leftLetter =
                      words[index].noun != null ? words[index].noun! : '';
                  leftLetter = leftLetter.substring(1, leftLetter.length);

                  String quoteDefault =
                      '"Think of all the beauty still left around you and be happy."';
                  String quote =
                      words[index].quote != null
                          ? words[index].quote!
                          : quoteDefault;

                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      color: AppColor.primaryColor,
                      elevation: 4,
                      child: InkWell(
                        onDoubleTap: () async {
                          setState(() {
                            words[index].isFavorite = !words[index].isFavorite!;
                          });
                          await saveFavoriteWords(words);
                        },
                        splashColor: Colors.black26,
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LikeButton(
                                onTap: (bool isLiked) async {
                                  setState(() {
                                    words[index].isFavorite = !isLiked;
                                  });
                                  await saveFavoriteWords(words);
                                  return !isLiked;
                                },
                                isLiked: words[index].isFavorite ?? false,
                                mainAxisAlignment: MainAxisAlignment.end,
                                size: 42,
                                circleColor: CircleColor(
                                  start: Color(0xff00ddff),
                                  end: Color(0xff0099cc),
                                ),
                                bubblesColor: BubblesColor(
                                  dotPrimaryColor: Color(0xff33b5e5),
                                  dotSecondaryColor: Color(0xff0099cc),
                                ),
                                likeBuilder: (bool isLiked) {
                                  return Image.asset(
                                    AppAssets.heart,
                                    color: isLiked ? Colors.red : Colors.white,
                                    width: 50,
                                    height: 50,
                                  );
                                },
                              ),
                              // Container(
                              //   alignment: Alignment.centerRight,
                              //   child: Image.asset(
                              //     AppAssets.heart,
                              //     color:
                              //         (words[index].isFavorite ?? false)
                              //             ? Colors.red
                              //             : Colors.white,
                              //     width: 50,
                              //     height: 50,
                              //   ),
                              // ),
                              RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  text: firstLetter,
                                  style: TextStyle(
                                    fontFamily: FontFamily.sen,
                                    fontSize: 89,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      BoxShadow(
                                        color: Colors.black38,
                                        offset: Offset(3, 6),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    TextSpan(
                                      text: leftLetter,
                                      style: TextStyle(
                                        fontFamily: FontFamily.sen,
                                        fontSize: 56,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          BoxShadow(
                                            color: Colors.black38,
                                            offset: Offset(3, 6),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: AutoSizeText(
                                  '"$quote"',
                                  maxFontSize: 26,
                                  style: AppStyles.h4.copyWith(
                                    letterSpacing: 1,
                                    color: AppColor.textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // indicator
            _currentIndex >= 5
                ? buildShowMore()
                : Container(
                  height: 12,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return buildIndicator(index == _currentIndex, size);
                    },
                  ),
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primaryColor,
        onPressed: () {
          setState(() {
            getEnglishToday();
            quote = Quotes().getRandom().content;
          });
          _pageController.animateToPage(
            Random().nextInt(words.length),
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        child: Image.asset(AppAssets.exchange),
      ),

      drawer: Drawer(
        child: Container(
          color: AppColor.lightBlue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Your mind',
                  style: AppStyles.h3.copyWith(color: AppColor.textColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppButton(
                  label: 'Favorites',
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => FavoritesWordPage()),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppButton(
                  label: 'Your control',
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ControlPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: isActive ? size.width * 1 / 5 : 24,
      decoration: BoxDecoration(
        color: isActive ? AppColor.lightBlue : AppColor.lightGray,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(color: Colors.black38, offset: Offset(2, 3), blurRadius: 3),
        ],
      ),
    );
  }

  Widget buildShowMore() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      alignment: Alignment.centerLeft,
      child: Material(
        color: AppColor.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(24)),
        elevation: 4,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllWordPage(words: words),
              ),
            );
          },
          splashColor: Colors.black38,
          borderRadius: BorderRadius.all(Radius.circular(24)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text('Show More ', style: AppStyles.h5),
          ),
        ),
      ),
    );
  }
}
