import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:greep/presentation/auth/home/auth_home.dart';
import 'package:greep/presentation/auth/onboarding/OnboardingSlidesWidgetView2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'OnboardingSlidesWidgetView.dart';

//class Slide {
//  final String image;
//  final String text;
//  bool isActive;
//
//  Slide(this.image, this.text, this.isActive);
//}

class Slide {
  final String image;
  final String text;
  final String title;
  final String image2;
  bool alignLeft;

  Slide(
      {required this.image,
      required this.text,
        required this.image2,
      required this.alignLeft,
      required this.title});
}

class OnboardingSlides2 extends StatefulWidget {
  const OnboardingSlides2({Key? key}) : super(key: key);

  @override
  createState() => OnboardingSlidesStateController2();
}

class OnboardingSlidesStateController2 extends State<OnboardingSlides2> {
  late PageController pageController;
  int currentPage = 0;

  var slides = <Slide>[
    Slide(
        image: "assets/images/onboarding_book.png",
        image2: "assets/images/first_onboarding_screenshot.png",
        text: "A simple method for tracking taxi business financial activities.",
        alignLeft: true,
        title: "Book Keeping Made Easy"),
    Slide(
        image: "assets/images/onboarding_connect.png",
        image2: "assets/images/second_onboarding_screenshot.png",
        text: "Track transactions recorded by your employees or partners in real time.",
        alignLeft: false,
        title: "Oversee Your Colleagues"),
    Slide(
        image: "assets/images/onboarding_tailor.png",
        image2: "assets/images/third2_onboarding_sceenshot.png",
        text: "Interfaces and record formats that have been carefully tailored for your company.",
        alignLeft: true,
        title: "Tailored Experience"),

  ];

  void nextSlide() async {
    setState(() {
      double currPage = pageController.page??0;
      currentPage = currPage.toInt();
    });
    if (pageController.page! < (slides.length - 1)) {
      await pageController.nextPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
      didChangeSlide(pageController.page!.toInt());
    } else
      {
      }


  }

  void didChangeSlide(int index) {
    setState(() {
      slides.forEach((element) => element.alignLeft = false);
      slides[index].alignLeft = true;
    });
  }
  @override
  void initState() {
   pageController = PageController()..addListener(() {
       setState(() {
         double currPage = pageController.page??0;
         currentPage = currPage.toInt();
     });
   });
    super.initState();
  }

  @override
  build(context) => OnboardingSlidesWidgetView2(this);

  void getStarted() async{
    var pref = await SharedPreferences.getInstance();
    pref.setBool("FirstRun", false);
    Get.offAll(() => const AuthHomeScreen());
  }
}
