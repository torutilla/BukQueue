import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/logoMain.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/background.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      body: BackgroundWithColor(
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                height: 500,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      colors: [Colors.black, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(
                        Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.dstIn,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Opacity(
                        opacity: 0.4,
                        child: Image.asset(
                          'assets/images/bajaj-re-front-angle-low-view-229993-white.jpg',
                          width: constraints.maxWidth,
                          height: constraints.maxHeight * 0.85,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/cctlogo.png',
                      height: 50,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/scslogo.png',
                      height: 50,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          // child: MainLogo(logoHeight: 70, logoWidth: 70),
                          child: MainLogo(logoHeight: 160, logoWidth: 160),
                        ),
                        TextTitle(
                            maxLines: 3,
                            text:
                                'Mobile Booking Application for Bukyo Transportation in Tagaytay City')
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          textAlign: TextAlign.justify,
                          'This study explores the development of a mobile booking application designed to improve transportation services in Tagaytay City, specifically for the Tricycle Operators and Drivers Association (TODA) consisting of Bukyo and Tricycles. Mobile booking applications have transformed how people arrange travel, offering convenience, efficiency, and a user-friendly interface for booking services such as transportation, dining, and entertainment. The research emphasizes the need for enhanced transportation options in Tagaytay, especially for students and workers relying on jeepneys, which have limited schedules and coverage. By integrating mobile booking features into TODA services, the study aims to improve commuter experience through easy booking, real-time fare estimation, and simplified navigation. Additionally, the application seeks to benefit drivers by increasing income opportunities and reducing issues like overpricing and illegal operations. Designed using Flutter and Dart, the mobile application incorporates essential features such as user-friendly interfaces, fare transparency, and safety ratings, ultimately providing a reliable and efficient transportation solution. Rated "Excellent" by users, the app enhances the commuting experience in Tagaytay, ensuring greater convenience for both commuters and drivers while contributing to the development of the local transport infrastructure.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      TextTitle(text: 'THE TEAM'),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CarouselSlider.builder(
                            itemCount: 4,
                            itemBuilder: (context, index1, index2) {
                              List<String> names = [
                                'Marknel Asia',
                                'Angelo Aliga',
                                'Glenn Jan Calvo',
                                'Christian John Torres',
                              ];
                              List<String> photos = [
                                'assets/images/430624598_688394186838855_1480725030385754492_n.jpg',
                                'assets/images/462574930_1076470367290577_2972342709839922756_n.jpg',
                                'assets/images/462558481_2996945477126587_2655230778748790816_n.jpg',
                                'assets/images/TORRES, CHRISTIAN JOHN.jpg',
                              ];
                              List<String> roles = [
                                'Documentation',
                                'Documentation',
                                'Documentation',
                                'Main Programmer',
                              ];
                              List<String> emails = [
                                'nickasia12@gmail.com',
                                'jelloaliga06@gmail.com',
                                'calvoglennjan@gmail.com',
                                'christiantorres0418@gmail.com',
                              ];
                              return Card(
                                clipBehavior: Clip.antiAlias,
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  return Column(
                                    children: [
                                      Stack(
                                        alignment: Alignment.topCenter,
                                        children: [
                                          SizedBox(
                                              height:
                                                  constraints.maxHeight * 0.5,
                                              child: BackgroundWithColor()),
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: Opacity(
                                              opacity: 0.5,
                                              child: SvgPicture.asset(
                                                'assets/images/Bukyo.svg',
                                                height:
                                                    constraints.maxHeight * 0.4,
                                                colorFilter: ColorFilter.mode(
                                                    secondaryColor,
                                                    BlendMode.srcIn),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: CircleAvatar(
                                              radius: 64,
                                              foregroundImage:
                                                  AssetImage(photos[index1]),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.5,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                TextTitle(
                                                  text: names[index1],
                                                  textColor: primaryColor,
                                                ),
                                                Text(roles[index1]),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0),
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        secondaryColor,
                                                    child: Icon(
                                                      Icons.email,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  emails[index1],
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0),
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        accentColor,
                                                    child: Icon(Icons.school),
                                                  ),
                                                ),
                                                Text(
                                                  'BS in Information Technology',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              );
                            },
                            options: CarouselOptions(
                              aspectRatio: 3 / 3,
                              enlargeCenterPage: true,
                              autoPlayInterval: Duration(seconds: 5),
                              autoPlay: true,
                              scrollDirection: Axis.horizontal,
                            )),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
