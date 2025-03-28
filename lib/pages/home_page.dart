import 'package:flutter/material.dart';
import 'package:flutter_application_1/values/app_assets.dart';
import 'package:flutter_application_1/values/app_color.dart';
import 'package:flutter_application_1/values/app_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.8);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.secondColor,
      appBar: AppBar(
        backgroundColor: AppColor.secondColor,
        title: Text(
          'English today',
          textAlign: TextAlign.center,
          style: AppStyles.h3.copyWith(color: AppColor.textColor, fontSize: 36),
        ),
        leading: InkWell(onTap: () {}, child: Image.asset(AppAssets.menu)),
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
                '"It is a mazing how complete the delution that beauty is goodness . "',
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
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(3, 6),
                            blurRadius: 6,
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            child: Image.asset(
                              AppAssets.heart,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: 'B',
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
                                  text: 'eautiful',
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
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              '"Think of all the beauty still left around you and be happy."',
                              style: AppStyles.h4.copyWith(
                                letterSpacing: 1,
                                color: AppColor.textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // indicator
            Container(
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
          print('exchange');
        },
        child: Image.asset(AppAssets.exchange),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return Container(
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
}
