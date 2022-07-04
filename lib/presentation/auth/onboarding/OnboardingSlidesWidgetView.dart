import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/commons/widget_view_pattern/WidgetView.dart';
import 'package:grip/presentation/widgets/submit_button.dart';

import 'OnboardingSlides.dart';

class OnboardingSlidesWidgetView
    extends WidgetView<OnboardingSlides, OnboardingSlidesStateController> {
  OnboardingSlidesWidgetView(state, {Key? key})
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
                : kGreenColor,
        body: SafeArea(
          child: Container(
              decoration: const BoxDecoration(),
              width: Get.width,
              child: Column(
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
                                              width: Get.width,
                                              alignment: state.currentPage == 2
                                                  ? Alignment.center
                                                  : null,
                                              height: 250,
                                              decoration: const BoxDecoration(),
                                              child: Stack(
                                                children: [
                                                  if (index == 0)
                                                    Positioned(
                                                      right: 0,
                                                      child: Image.asset(
                                                        state.slides[index]
                                                            .image,
                                                        alignment:
                                                            Alignment.topRight,
                                                        width: 250,
                                                        height: 250,
                                                      ),
                                                    ),
                                                  if (index == 1)
                                                    Positioned(
                                                      left: 0,
                                                      child: Image.asset(
                                                        state.slides[index]
                                                            .image,
                                                        alignment:
                                                            Alignment.topLeft,
                                                        width: 250,
                                                        height: 250,
                                                      ),
                                                    ),
                                                  if (index == 2)
                                                    Image.asset(
                                                      state.slides[index].image,
                                                      alignment:
                                                          Alignment.center,
                                                      width: 250,
                                                      height: 250,
                                                    ),
                                                ],
                                              ),
                                            ),
                                            kVerticalSpaceLarge,
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: index == 1
                                                    ? CrossAxisAlignment.start
                                                    : CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    alignment: index == 1
                                                        ? Alignment.centerRight
                                                        : Alignment.centerLeft,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal:
                                                            kDefaultSpacing),
                                                    width: Get.width,
                                                    child: Text(
                                                      state.slides[index].title,
                                                      textAlign: index != 1
                                                          ? TextAlign.left
                                                          : TextAlign.right,
                                                      style: kHeadingTextStyle
                                                          .copyWith(
                                                              color: index == 0
                                                                  ? kBlackColor
                                                                  : kWhiteColor),
                                                    ),
                                                  ),
                                                  kVerticalSpaceSmall,
                                                  Container(
                                                    alignment: index == 1
                                                        ? Alignment.centerRight
                                                        : Alignment.centerLeft,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal:
                                                            kDefaultSpacing),
                                                    width: Get.width,
                                                    child: Text(
                                                      state.slides[index].text,
                                                      textAlign: index != 1
                                                          ? TextAlign.left
                                                          : TextAlign.center,
                                                      style: kSubtitleTextStyle
                                                          .copyWith(
                                                        color: index == 0
                                                            ? kBlackColor
                                                            : kWhiteColor,

//                                                backgroundColor: kBlackColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            kVerticalSpaceLarge,
                                          ],
                                        ),
                                      ),
                                    ],
                                  )))),
                  SafeArea(
                    child: Container(
                      decoration: BoxDecoration(),
                      padding: const EdgeInsets.all(kDefaultSpacing),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              state.slides.length,
                              (index) => Container(
                                height: 7,
                                width:
                                    state.slides[index].alignLeft ? 15 * 2 : 15,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: kDefaultSpacing * 0.2),
                                decoration: BoxDecoration(
                                    color: index == 0
                                        ? kBlackColor
                                        : index == 1
                                            ? kBlueColor
                                            : kWhiteColor,
                                    borderRadius: BorderRadius.circular(
                                        kDefaultSpacing * 0.25)),
                              ),
                            ),
                          ),
                          Container(
                            child: GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: kDefaultSpacing,
                                    vertical: kDefaultSpacing * 0.5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      kDefaultSpacing * 0.5),
                                  color: state.currentPage == 0
                                      ? kBlackColor
                                      : state.currentPage == 1
                                          ? kBlueColor
                                          : kWhiteColor,
                                ),
                                child: Text(
                                  state.currentPage == 2 ? "Start" : "Next",
                                  style: kWhiteTextStyle.copyWith(
                                    color: state.currentPage == 2
                                        ? kBlackColor
                                        : kWhiteColor,
                                  ),
                                ),
                              ),
                              onTap: state.currentPage == 2
                                  ? state.getStarted
                                  : state.nextSlide,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ),
      );
}
