import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/commons/widget_view_pattern/WidgetView.dart';
import 'package:greep/presentation/auth/onboarding/OnboardingSlides2.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';

import 'OnboardingSlides.dart';

class OnboardingSlidesWidgetView2
    extends WidgetView<OnboardingSlides2, OnboardingSlidesStateController2> {
  OnboardingSlidesWidgetView2(state, {Key? key})
      : super(
          state,
          key: key,
        );

  @override
  build(context) => Scaffold(
        backgroundColor: state.currentPage == 0
            ? kWhiteColor
            : state.currentPage == 1
                ? kBlackColor
                : kWhiteColor,
        body: SafeArea(
          child: Container(
              height: Get.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(state.currentPage != 1
                          ? "assets/images/onboarding_bg2.png"
                          : "assets/images/onboarding_bg.png"))),
              width: Get.width,
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: PageView(
                        onPageChanged: state.didChangeSlide,
                        controller: state.pageController,
                        children: List.generate(
                          state.slides.length,
                          (index) => Stack(
                            children: [
                              Container(
                                width: Get.width,
                                decoration: const BoxDecoration(),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    kVerticalSpaceLarge,
                                    Container(
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 350.r,
                                          width: 350.r,
                                          padding: EdgeInsets.all(20.r),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: state.currentPage != 1
                                                ? Border.all(
                                                    color:
                                                        const Color(0xff999999))
                                                : null,
                                          ),
                                          child: Image.asset(
                                            state.slides[index].image,
                                            scale: 3,
                                          ),
                                        )),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 30.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: kDefaultSpacing),
                                            width: Get.width,
                                            child: TextWidget(
                                              state.slides[index].title,
                                              textAlign: TextAlign.center,
                                              style: kBoldTextStyle2.copyWith(
                                                color: index == 1
                                                    ? kWhiteColor
                                                    : kBlackColor,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          kVerticalSpaceRegular,
                                          Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 0.1.sw),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: kDefaultSpacing),
                                            width: Get.width,
                                            child: TextWidget(
                                              state.slides[index].text,
                                              textAlign: TextAlign.center,
                                              style: kDefaultTextStyle.copyWith(
                                                  color: index == 1
                                                      ? kWhiteColor
                                                      : kBlackColor,
                                                  fontSize: 15
//                                                backgroundColor: kBlackColor,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    kVerticalSpaceLarge,
                    SafeArea(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        // height: constraints.maxHeight * 0.2,
                        decoration: const BoxDecoration(),
                        padding: const EdgeInsets.all(kDefaultSpacing),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                state.slides.length,
                                (index) => Container(
                                  height: 7,
                                  width: state.slides[index].alignLeft
                                      ? 15 * 2
                                      : 15,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: kDefaultSpacing * 0.2),
                                  decoration: BoxDecoration(
                                      color: state.currentPage == 0 &&
                                              index == 0
                                          ? kBlackColor
                                          : state.currentPage == 1 && index == 1
                                              ? kGreenColor
                                              : state.currentPage == 2 &&
                                                      index == 2
                                                  ? kBlackColor
                                                  : Colors.grey,
                                      borderRadius: BorderRadius.circular(
                                          kDefaultSpacing * 0.25)),
                                ),
                              ),
                            ),
                            kVerticalSpaceLarge,
                            kVerticalSpaceLarge,
                            Container(
                              margin: EdgeInsets.only(bottom: 20.h),
                              child: SubmitButton(
                                borderRadius: kDefaultSpacing * 0.5,
                                backgroundColor:
                                    state.currentPage == 1 ? kGreenColor : null,
                                onSubmit: state.currentPage == 2
                                    ? state.getStarted
                                    : state.nextSlide,
                                text: state.currentPage == 2
                                    ? "Get Started"
                                    : "Next",
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              })),
        ),
      );
}
