import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:grip/presentation/auth/home/auth_home.dart';
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
  bool alignLeft;

  Slide(
      {required this.image,
      required this.text,
      required this.alignLeft,
      required this.title});
}

class OnboardingSlides extends StatefulWidget {
  const OnboardingSlides({Key? key}) : super(key: key);

  @override
  createState() => OnboardingSlidesStateController();
}

class OnboardingSlidesStateController extends State<OnboardingSlides> {
  late PageController pageController;
  int currentPage = 0;



  var slides = <Slide>[
    Slide(
        image: "assets/images/first_cone_onboarding.png",
        text: "With a good perspective on history, "
            "we can have a better understanding of the past and present, "
            "and thus a clear vision of the future.",
        alignLeft: true,
        title: "Get a Greep"),
    Slide(
        image: "assets/images/second_cone_onboarding.png",
        text: "With a good perspective on history, "
            "we can have a better understanding of the past and present,"
            " and thus a clear vision of the future.",
        alignLeft: false,
        title: "If it’s Worth Recording"),
    Slide(
        image: "assets/images/last_onboarding.png",
        text: "With a good perspective on history,"
            " we can have a better understanding of the past and present,"
            " and thus a clear vision of the future.",
        alignLeft: true,
        title: "Greep It."),

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
        debugPrint("end of slide");
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
  build(context) => OnboardingSlidesWidgetView(this);

  void getStarted() async{
    var pref = await SharedPreferences.getInstance();
    pref.setBool("FirstRun", false);
    Get.offAll(() => const AuthHomeScreen());
  }
}
