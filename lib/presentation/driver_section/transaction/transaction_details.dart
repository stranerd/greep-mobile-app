import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as g;
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/driver/drivers_cubit.dart';
import 'package:greep/application/geocoder/geocoder_cubit.dart';
import 'package:greep/application/geocoder/geocoder_state.dart';
import 'package:greep/application/transactions/transaction_trips_cubit.dart';
import 'package:greep/application/transactions/trip_direction_builder_cubit.dart';
import 'package:greep/application/transactions/user_transactions_cubit.dart';
import 'package:greep/application/user/utils/get_current_user.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/TransactionData.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/driver_section/widgets/transaction_list_card.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/transaction_balance_widget.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';

class TransactionDetails extends StatefulWidget {
  final Transaction transaction;

  const TransactionDetails({Key? key, required this.transaction})
      : super(key: key);

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails>
    with ScaffoldMessengerService {
  late Transaction transaction;
  Transaction? parentTransaction;
  late TransactionTripsCubit tripsCubit;
  ScreenshotController screenshotController = ScreenshotController();

  bool showTrips = true;

  String? googleApiKey;

  @override
  void initState() {
    transaction = widget.transaction;
    tripsCubit = getIt();
    dotenv.dotenv.load(fileName: ".env").then((e) {
      googleApiKey = dotenv.dotenv
              .env[Platform.isIOS ? 'GOOGLEIOSAPIKEY' : 'GOOGLEAPIKEY'] ??
          "";
    });
    var transactions =
        GetIt.I<UserTransactionsCubit>().getCurrentUserTransactions();
    if (transactions
        .any((element) => element.id == transaction.data.parentId)) {
      parentTransaction = transactions
          .firstWhere((element) => element.id == transaction.data.parentId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocProvider.value(
          value: tripsCubit..getTransactionTrips(transaction.id),
          child: BlocListener<UserTransactionsCubit, UserTransactionsState>(
              listener: (context, state) {
            if (state is UserTransactionsStateFetched) {
              if (state.userId == currentUser().id &&
                  state.transactions.any((element) => element == transaction)) {
                setState(
                  () {
                    transaction = state.transactions
                        .firstWhere((element) => element == transaction);
                  },
                );
              }
            }
          }, child: BlocBuilder<TransactionTripsCubit, TransactionTripsState>(
            builder: (context, tripState) {
              return Scaffold(
                backgroundColor: Colors.white,
                floatingActionButton: SafeArea(
                  child: SplashTap(
                    onTap: () async {
                      //   Share.share('''
                      // I would love to share this transaction to you
                      // at Greep.
                      //
                      // You can check it out at Greep https://play.google.com/store/apps/details?id=com.greepio.greep
                      //
                      // ''');
                      var status = await Permission.storage.status;
                      if (status.isDenied) {
                        await Permission.storage.request();
                        // We didn't ask for permission yet or the permission has been denied before but not permanently.
                      }

                      screenshotController
                          .capture(pixelRatio: 2)
                          .then((Uint8List? image) async {
                        // final directory = (await getApplicationDocumentsDirectory())
                        //     .path;
                        // File imgFile = File('$directory/screenshot.png');
                        // imgFile.writeAsBytes(image!);
                        print("File Saved to Gallery");
                        await Share.file(
                            "Anupam", "Greep - Transaction - ${transaction.timeAdded}.png", image!, "image/png");


                        // if (image != null) {
                        //   final result = await ImageGallerySaver.saveImage(
                        //       image,
                        //       quality: 100,
                        //       name:
                        //           "Greep - Transaction - ${DateTime.now()}.png");
                        //   var file = File.fromRawPath(image);
                        //   Share.shareFiles([file.path]);
                        //   print("file ${file.path} ");
                        //   // if ((result as Map)["isSuccess"] ?? false) {
                        //   //   Share.shareXFiles([XFile.fromData(image)]);
                        //   // }
                        //   // success = 'Image saved to gallery';
                        // }
                      }).catchError((onError) {
                        print(onError);
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(kDefaultSpacing * 0.5),
                      decoration: const BoxDecoration(),
                      child: const Icon(Icons.ios_share),
                    ),
                  ),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Screenshot(
                      controller: screenshotController,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              height: 220.h,
                              width: 1.sw,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      "assets/images/transaction_bg.png"),
                                  scale: 2,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: 18.w,
                                    bottom: 18.h,
                                    child: Image.asset(
                                      "assets/images/transaction_car.png",
                                      scale: 2,
                                    ),
                                  ),
                                  Positioned(
                                    top: 30.h,
                                    right: 18.w,
                                    child: Container(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          TextWidget(
                                            DateFormat(
                                                    "${DateFormat.ABBR_WEEKDAY}, ${DateFormat.ABBR_MONTH} ${DateFormat.DAY}, ${DateFormat.YEAR}")
                                                .format(widget
                                                    .transaction.timeAdded),
                                            fontSize: 12,
                                            weight: FontWeight.bold,
                                            letterSpacing: 1.3,
                                          ),
                                          TextWidget(
                                            DateFormat(
                                                    "hh:${DateFormat.MINUTE} a")
                                                .format(widget
                                                    .transaction.timeAdded),
                                            fontSize: 12,
                                            weight: FontWeight.bold,
                                            letterSpacing: 1.3,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 18.w,
                                    top: 60.h,
                                    child: Image.asset(
                                      "assets/images/transaction_greep.png",
                                      scale: 2,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  if (widget.transaction.data.transactionType !=
                                      TransactionType.expense)
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: Container(
                                        width: 230.w,
                                        height: 40.h,
                                        padding: EdgeInsets.only(left: 20.w),
                                        alignment: Alignment.centerLeft,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                "assets/images/transaction_name_bg.png",
                                              ),
                                              fit: BoxFit.cover,
                                              scale: 2),
                                        ),
                                        child: FittedBox(
                                          child: TextWidget(
                                            widget.transaction.data
                                                    .customerName ??
                                                "",
                                            color: kWhiteColor,
                                            weight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  Positioned(
                                    top: 5.h,
                                    left: 5.w,
                                    child: const BackIcon(isArrow: true,),
                                  )
                                ],
                              ),
                            ),
                            kVerticalSpaceRegular,
                            Column(
                              children: [
                                if (transaction.data.transactionType ==
                                    TransactionType.balance)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: kDefaultSpacing * 0.5),
                                    decoration: const BoxDecoration(),
                                    child: Column(
                                      children: [
                                        kVerticalSpaceRegular,
                                        if (parentTransaction != null)
                                          Stack(
                                            children: [
                                              TransactionListCard(
                                                padding:
                                                    (kDefaultSpacing * 0.5).r,
                                                transaction: parentTransaction!,
                                                withColor: true,
                                                withBorder: true,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            TransactionDetails(
                                                                transaction:
                                                                    parentTransaction!)),
                                                  );
                                                },
                                                child: Container(
                                                  height: 80.h,
                                                  width: 1.sw,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors
                                                              .transparent),
                                                ),
                                              )
                                            ],
                                          ),
                                        kVerticalSpaceRegular
                                      ],
                                    ),
                                  ),
                                Container(
                                  width: g.Get.width,
                                  margin:
                                      EdgeInsets.all((kDefaultSpacing * 0.5).r),
                                  padding:
                                      EdgeInsets.fromLTRB(16.r, 0, 16.r, 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          kDefaultSpacing)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const TextWidget(
                                            "Total",
                                            weight: FontWeight.bold,
                                            fontSize: 25,
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  TurkishSymbol(
                                                    width: 22.w,
                                                    height: 22.h,
                                                    color: AppTextStyles
                                                        .blackSize16.color,
                                                  ),
                                                  TextWidget(
                                                    transaction.amount
                                                        .abs()
                                                        .toMoney,
                                                    style: AppTextStyles
                                                        .blackSize16,
                                                    fontSize: 25,
                                                    weight: FontWeight.bold,
                                                  ),
                                                ],
                                              ),
                                              if (widget.transaction.data
                                                      .transactionType ==
                                                  TransactionType.trip)
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/transaction_status_tick.svg",
                                                      color: transaction
                                                                  .data.debt ==
                                                              0
                                                          ? kBlackColor
                                                          : (transaction.data
                                                                          .debt ??
                                                                      0) <
                                                                  0
                                                              ? AppColors.red
                                                              : AppColors.blue,
                                                    ),
                                                    kHorizontalSpaceTiny,
                                                    TextWidget(
                                                      transaction.data.debt == 0
                                                          ? "Balanced"
                                                          : (transaction.data
                                                                          .debt ??
                                                                      0) <
                                                                  0
                                                              ? "To Pay"
                                                              : "To Collect",
                                                      fontSize: 16,
                                                      color: transaction
                                                                  .data.debt ==
                                                              0
                                                          ? kBlackColor
                                                          : (transaction.data
                                                                          .debt ??
                                                                      0) <
                                                                  0
                                                              ? AppColors.red
                                                              : AppColors.blue,
                                                    )
                                                  ],
                                                ),
                                              if (widget.transaction.data
                                                      .transactionType ==
                                                  TransactionType.balance)
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/transaction_status_tick.svg",
                                                      color: parentTransaction
                                                                  ?.data.debt ==
                                                              0
                                                          ? kBlackColor
                                                          : (parentTransaction
                                                                          ?.data
                                                                          .debt ??
                                                                      0) <
                                                                  0
                                                              ? AppColors.red
                                                              : AppColors.blue,
                                                    ),
                                                    kHorizontalSpaceTiny,
                                                    TextWidget(
                                                      parentTransaction
                                                                  ?.data.debt ==
                                                              0
                                                          ? "Balanced"
                                                          : (parentTransaction
                                                                          ?.data
                                                                          .debt ??
                                                                      0) <
                                                                  0
                                                              ? "To Pay"
                                                              : "To Collect",
                                                      fontSize: 16,
                                                      color: parentTransaction
                                                                  ?.data.debt ==
                                                              0
                                                          ? kBlackColor
                                                          : (parentTransaction
                                                                          ?.data
                                                                          .debt ??
                                                                      0) <
                                                                  0
                                                              ? AppColors.red
                                                              : AppColors.blue,
                                                    )
                                                  ],
                                                )
                                            ],
                                          )
                                        ],
                                      ),
                                      kVerticalSpaceRegular,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const TextWidget(
                                            "Paid",
                                            weight: FontWeight.bold,
                                            fontSize: 22,
                                          ),
                                          Row(
                                            children: [
                                              TurkishSymbol(
                                                width: 19.w,
                                                height: 19.h,
                                                color: AppTextStyles
                                                    .blackSize16.color,
                                              ),
                                              TextWidget(
                                                "${transaction.data.paidAmount == null ? 0 : transaction.data.paidAmount!.abs().toMoney}",
                                                style:
                                                    AppTextStyles.blackSize16,
                                                fontSize: 22,
                                                weight: FontWeight.bold,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      kVerticalSpaceRegular,
                                      const Divider(
                                        color: AppColors.lightBlue,
                                      ),
                                      kVerticalSpaceRegular,
                                      if (widget.transaction.data
                                              .transactionType ==
                                          TransactionType.trip)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const TextWidget(
                                                  "Trip Information",
                                                  weight: FontWeight.bold,
                                                  fontSize: 22,
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        showTrips = !showTrips;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                        left: 40.w,
                                                      ),
                                                      child: Icon(showTrips
                                                          ? Icons.arrow_drop_up
                                                          : Icons
                                                              .arrow_drop_down),
                                                    ))
                                              ],
                                            ),
                                            if (showTrips)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  kVerticalSpaceMedium,
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 25.w,
                                                            alignment: Alignment
                                                                .center,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(
                                                              kDefaultSpacing *
                                                                  0.2,
                                                            ),
                                                            height: 25.w,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: AppColors
                                                                  .blue,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Image.asset(
                                                              "assets/icons/map_navigator.png",
                                                              color:
                                                                  kWhiteColor,
                                                              scale: 4.5,
                                                            ),
                                                          ),
                                                          kHorizontalSpaceSmall,
                                                          const TextWidget(
                                                              "Got a trip")
                                                        ],
                                                      ),
                                                      Flexible(
                                                        child: tripState
                                                                is TransactionTripsStateAvailable
                                                            ? Builder(builder:
                                                                (context) {
                                                                DirectionProgress?
                                                                    directionProgress =
                                                                    tripState
                                                                        .trip
                                                                        .gotDirection;

                                                                if (directionProgress ==
                                                                    null) {
                                                                  return const TextWidget(
                                                                    "No Data",
                                                                  );
                                                                }
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    MapsLauncher
                                                                        .launchCoordinates(
                                                                      directionProgress
                                                                          .location
                                                                          .latitude,
                                                                      directionProgress
                                                                          .location
                                                                          .longitude,
                                                                    );
                                                                  },
                                                                  child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Builder(builder:
                                                                            (context) {
                                                                          String address = directionProgress.location.address != null
                                                                              ? directionProgress.location.address?.isNotEmpty ?? false
                                                                                  ? directionProgress.location.address!
                                                                                  : ""
                                                                              : "";
                                                                          if (address
                                                                              .isNotEmpty) {
                                                                            return TextWidget(
                                                                              address,
                                                                              softWrap: true,
                                                                              textAlign: TextAlign.right,
                                                                              maxLines: 2,
                                                                              fontSize: 15,
                                                                              color: AppColors.veryLightGray,
                                                                            );
                                                                          }
                                                                          return BlocProvider
                                                                              .value(
                                                                            value: getIt<GeoCoderCubit>()
                                                                              ..fetchAddressFromLongAndLat(longitude: directionProgress.location.longitude, latitude: directionProgress.location.latitude),
                                                                            child:
                                                                                BlocBuilder<GeoCoderCubit, GeoCoderState>(
                                                                              builder: (context, geoState) {
                                                                                return TextWidget(
                                                                                  geoState is GeoCoderStateFetched
                                                                                      ? geoState.address.isEmpty
                                                                                          ? 'Loading address...'
                                                                                          : geoState.address
                                                                                      : 'Loading address...',
                                                                                  softWrap: true,
                                                                                  maxLines: 2,
                                                                                  fontSize: 15,
                                                                                  color: AppColors.veryLightGray,
                                                                                );
                                                                              },
                                                                            ),
                                                                          );
                                                                        }),
                                                                        kVerticalSpaceRegular,
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            TextWidget(
                                                                              "${directionProgress.speed.toStringAsFixed(3).toString()} km/h",
                                                                              fontSize: 14,
                                                                            ),
                                                                            kHorizontalSpaceSmall,
                                                                            Container(
                                                                              height: 5.r,
                                                                              width: 5.r,
                                                                              decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                                                                            ),
                                                                            kHorizontalSpaceSmall,
                                                                            TextWidget(
                                                                              "${directionProgress.distance.toStringAsFixed(3).toString()} km",
                                                                              fontSize: 14,
                                                                            ),
                                                                            kHorizontalSpaceSmall,
                                                                            Container(
                                                                              height: 5.r,
                                                                              width: 5.r,
                                                                              decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                                                                            ),
                                                                            kHorizontalSpaceSmall,
                                                                            const TextWidget(
                                                                              "0m",
                                                                              fontSize: 14,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        kVerticalSpaceRegular,
                                                                        TextWidget(
                                                                          DateFormat(DateFormat.HOUR24_MINUTE)
                                                                              .format(directionProgress.date),
                                                                          color:
                                                                              AppColors.veryLightGray,
                                                                        )
                                                                      ]),
                                                                );
                                                              })
                                                            : const TextWidget(
                                                                "No Data",
                                                              ),
                                                      )
                                                    ],
                                                  ),
                                                  kVerticalSpaceRegular,
                                                  const Divider(
                                                    color: AppColors.lightBlue,
                                                  ),
                                                  kVerticalSpaceRegular,
                                                  LayoutBuilder(builder:
                                                      (context, constraints) {
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 25.w,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                kDefaultSpacing *
                                                                    0.2,
                                                              ),
                                                              height: 25.w,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: AppColors
                                                                    .green,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child:
                                                                  Image.asset(
                                                                "assets/icons/map_navigator.png",
                                                                color:
                                                                    kWhiteColor,
                                                                scale: 4.5,
                                                              ),
                                                            ),
                                                            kHorizontalSpaceSmall,
                                                            const TextWidget(
                                                                "Start trip")
                                                          ],
                                                        ),
                                                        Flexible(
                                                          child: tripState
                                                                  is TransactionTripsStateAvailable
                                                              ? Builder(builder:
                                                                  (context) {
                                                                  DirectionProgress?
                                                                      directionProgress =
                                                                      tripState
                                                                          .trip
                                                                          .startDirection;

                                                                  if (directionProgress ==
                                                                      null) {
                                                                    return const TextWidget(
                                                                      "No Data",
                                                                    );
                                                                  }
                                                                  return GestureDetector(
                                                                    onTap: () {
                                                                      MapsLauncher
                                                                          .launchCoordinates(
                                                                        directionProgress
                                                                            .location
                                                                            .latitude,
                                                                        directionProgress
                                                                            .location
                                                                            .longitude,
                                                                      );
                                                                    },
                                                                    child: Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize
                                                                                .min,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Builder(builder:
                                                                              (context) {
                                                                            String address = directionProgress.location.address != null
                                                                                ? directionProgress.location.address?.isNotEmpty ?? false
                                                                                    ? directionProgress.location.address!
                                                                                    : ""
                                                                                : "";
                                                                            if (address.isNotEmpty) {
                                                                              return TextWidget(
                                                                                address,
                                                                                softWrap: true,
                                                                                textAlign: TextAlign.right,
                                                                                maxLines: 2,
                                                                                fontSize: 15,
                                                                                color: AppColors.veryLightGray,
                                                                              );
                                                                            }
                                                                            return BlocProvider.value(
                                                                              value: getIt<GeoCoderCubit>()..fetchAddressFromLongAndLat(longitude: directionProgress.location.longitude, latitude: directionProgress.location.latitude),
                                                                              child: BlocBuilder<GeoCoderCubit, GeoCoderState>(
                                                                                builder: (context, geoState) {
                                                                                  return TextWidget(
                                                                                    geoState is GeoCoderStateFetched
                                                                                        ? geoState.address.isEmpty
                                                                                            ? 'Loading address...'
                                                                                            : geoState.address
                                                                                        : 'Loading address...',
                                                                                    softWrap: true,
                                                                                    maxLines: 2,
                                                                                    fontSize: 15,
                                                                                    color: AppColors.veryLightGray,
                                                                                  );
                                                                                },
                                                                              ),
                                                                            );
                                                                          }),
                                                                          kVerticalSpaceRegular,
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              TextWidget(
                                                                                "${directionProgress.speed.toStringAsFixed(3).toString()} km/h",
                                                                                fontSize: 14,
                                                                              ),
                                                                              kHorizontalSpaceSmall,
                                                                              Container(
                                                                                height: 5.r,
                                                                                width: 5.r,
                                                                                decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                                                                              ),
                                                                              kHorizontalSpaceSmall,
                                                                              TextWidget(
                                                                                "${directionProgress.distance.toStringAsFixed(3).toString()} km",
                                                                                fontSize: 14,
                                                                              ),
                                                                              kHorizontalSpaceSmall,
                                                                              Container(
                                                                                height: 5.r,
                                                                                width: 5.r,
                                                                                decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                                                                              ),
                                                                              kHorizontalSpaceSmall,
                                                                              TextWidget(
                                                                                timeago.format(directionProgress.date.add(directionProgress.duration), clock: directionProgress.date, allowFromNow: true, locale: 'en_short'),
                                                                                fontSize: 14,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          kVerticalSpaceRegular,
                                                                          TextWidget(
                                                                            DateFormat(DateFormat.HOUR24_MINUTE).format(directionProgress.date),
                                                                            color:
                                                                                AppColors.veryLightGray,
                                                                          )
                                                                        ]),
                                                                  );
                                                                })
                                                              : const TextWidget(
                                                                  "No Data",
                                                                ),
                                                        )
                                                      ],
                                                    );
                                                  }),
                                                  kVerticalSpaceRegular,
                                                  const Divider(
                                                    color: AppColors.lightBlue,
                                                  ),
                                                  kVerticalSpaceRegular,
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 25.w,
                                                            alignment: Alignment
                                                                .center,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(
                                                              kDefaultSpacing *
                                                                  0.2,
                                                            ),
                                                            height: 25.w,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color:
                                                                  AppColors.red,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Image.asset(
                                                              "assets/icons/map_navigator.png",
                                                              color:
                                                                  kWhiteColor,
                                                              scale: 4.5,
                                                            ),
                                                          ),
                                                          kHorizontalSpaceSmall,
                                                          const TextWidget(
                                                              "End trip")
                                                        ],
                                                      ),
                                                      Flexible(
                                                        child: tripState
                                                                is TransactionTripsStateAvailable
                                                            ? Builder(builder:
                                                                (context) {
                                                                DirectionProgress?
                                                                    directionProgress =
                                                                    tripState
                                                                        .trip
                                                                        .endDirection;

                                                                if (directionProgress ==
                                                                    null) {
                                                                  return const TextWidget(
                                                                    "No Data",
                                                                  );
                                                                }
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    MapsLauncher
                                                                        .launchCoordinates(
                                                                      directionProgress
                                                                          .location
                                                                          .latitude,
                                                                      directionProgress
                                                                          .location
                                                                          .longitude,
                                                                    );
                                                                  },
                                                                  child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Builder(builder:
                                                                            (context) {
                                                                          String address = directionProgress.location.address != null
                                                                              ? directionProgress.location.address?.isNotEmpty ?? false
                                                                                  ? directionProgress.location.address!
                                                                                  : ""
                                                                              : "";
                                                                          if (address
                                                                              .isNotEmpty) {
                                                                            return TextWidget(
                                                                              address,
                                                                              softWrap: true,
                                                                              textAlign: TextAlign.right,
                                                                              maxLines: 2,
                                                                              fontSize: 15,
                                                                              color: AppColors.veryLightGray,
                                                                            );
                                                                          }
                                                                          return BlocProvider
                                                                              .value(
                                                                            value: getIt<GeoCoderCubit>()
                                                                              ..fetchAddressFromLongAndLat(longitude: directionProgress.location.longitude, latitude: directionProgress.location.latitude),
                                                                            child:
                                                                                BlocBuilder<GeoCoderCubit, GeoCoderState>(
                                                                              builder: (context, geoState) {
                                                                                return TextWidget(
                                                                                  geoState is GeoCoderStateFetched
                                                                                      ? geoState.address.isEmpty
                                                                                          ? 'Loading address...'
                                                                                          : geoState.address
                                                                                      : 'Loading address...',
                                                                                  softWrap: true,
                                                                                  maxLines: 2,
                                                                                  fontSize: 15,
                                                                                  color: AppColors.veryLightGray,
                                                                                );
                                                                              },
                                                                            ),
                                                                          );
                                                                        }),
                                                                        kVerticalSpaceRegular,
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            TextWidget(
                                                                              "${directionProgress.speed.toStringAsFixed(3)} km/h",
                                                                              fontSize: 14,
                                                                            ),
                                                                            kHorizontalSpaceSmall,
                                                                            Container(
                                                                              height: 5.r,
                                                                              width: 5.r,
                                                                              decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                                                                            ),
                                                                            kHorizontalSpaceSmall,
                                                                            TextWidget(
                                                                              "${directionProgress.distance.toStringAsFixed(3)} km",
                                                                              fontSize: 14,
                                                                            ),
                                                                            kHorizontalSpaceSmall,
                                                                            Container(
                                                                              height: 5.r,
                                                                              width: 5.r,
                                                                              decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                                                                            ),
                                                                            kHorizontalSpaceSmall,
                                                                            TextWidget(
                                                                              timeago.format(directionProgress.date, clock: directionProgress.date.add(directionProgress.duration), locale: "en_short"),
                                                                              fontSize: 14,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        kVerticalSpaceRegular,
                                                                        TextWidget(
                                                                          DateFormat(DateFormat.HOUR24_MINUTE)
                                                                              .format(directionProgress.date),
                                                                          color:
                                                                              AppColors.veryLightGray,
                                                                        )
                                                                      ]),
                                                                );
                                                              })
                                                            : const TextWidget(
                                                                "No Data",
                                                              ),
                                                      )
                                                    ],
                                                  ),
                                                  kVerticalSpaceRegular,
                                                  const Divider(
                                                    color: AppColors.lightBlue,
                                                  ),
                                                  kVerticalSpaceRegular,
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const TextWidget(
                                                        "Distance covered",
                                                        color: AppColors
                                                            .lightBlack,
                                                      ),
                                                      Builder(
                                                          builder: (context) {
                                                        if (tripState
                                                            is TransactionTripsStateAvailable) {
                                                          double distance = 0;
                                                          if (tripState.trip
                                                                  .startDirection !=
                                                              null) {
                                                            distance += tripState
                                                                    .trip
                                                                    .startDirection
                                                                    ?.distance ??
                                                                0;
                                                          }
                                                          if (tripState.trip
                                                                  .endDirection !=
                                                              null) {
                                                            distance += tripState
                                                                    .trip
                                                                    .endDirection
                                                                    ?.distance ??
                                                                0;
                                                          }

                                                          return TextWidget(
                                                            "$distance km",
                                                            color: AppColors
                                                                .veryLightGray,
                                                            fontSize: 18,
                                                          );
                                                        }
                                                        return const TextWidget(
                                                          "0km",
                                                          color: AppColors
                                                              .veryLightGray,
                                                          fontSize: 18,
                                                        );
                                                      })
                                                    ],
                                                  ),
                                                  kVerticalSpaceRegular,
                                                  const Divider(
                                                    color: AppColors.lightBlue,
                                                  ),
                                                  kVerticalSpaceRegular,
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const TextWidget(
                                                        "Trip duration",
                                                        color: AppColors
                                                            .lightBlack,
                                                      ),
                                                      Builder(
                                                          builder: (context) {
                                                        if (tripState
                                                            is TransactionTripsStateAvailable) {
                                                          int duration = 0;
                                                          if (tripState.trip
                                                                  .endDirection !=
                                                              null) {
                                                            duration += tripState
                                                                    .trip
                                                                    .endDirection
                                                                    ?.duration
                                                                    .inSeconds ??
                                                                0;
                                                          }

                                                          return TextWidget(
                                                            timeago.format(
                                                                DateTime.now(),
                                                                clock: DateTime
                                                                        .now()
                                                                    .add(Duration(
                                                                        seconds:
                                                                            duration)),
                                                                allowFromNow:
                                                                    true,
                                                                locale:
                                                                    'en_short'),
                                                            color: AppColors
                                                                .veryLightGray,
                                                            fontSize: 18,
                                                          );
                                                        }
                                                        return const TextWidget(
                                                          "No Data",
                                                          color: AppColors
                                                              .veryLightGray,
                                                          fontSize: 18,
                                                        );
                                                      })
                                                    ],
                                                  ),
                                                  kVerticalSpaceRegular,
                                                  const Divider(
                                                    color: AppColors.lightBlue,
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      kVerticalSpaceRegular,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const TextWidget(
                                            "Description",
                                            color: AppColors.lightBlack,
                                          ),
                                          TextWidget(
                                            widget.transaction.description,
                                            color: AppColors.veryLightGray,
                                            fontSize: 18,
                                            style: kDefaultTextStyle.copyWith(
                                                fontStyle: FontStyle.italic),
                                          )
                                        ],
                                      ),
                                      kVerticalSpaceRegular,
                                      const Divider(
                                        color: AppColors.lightBlue,
                                      ),
                                      kVerticalSpaceRegular,
                                      if (GetIt.I<DriversCubit>()
                                                  .selectedUser ==
                                              currentUser() &&
                                          transaction.data.transactionType ==
                                              TransactionType.trip &&
                                          transaction.debt != 0)
                                        TransactionBalanceWidget(
                                          transaction: transaction,
                                        ),
                                      if (GetIt.I<DriversCubit>()
                                                  .selectedUser ==
                                              currentUser() &&
                                          parentTransaction != null &&
                                          parentTransaction!.debt != 0)
                                        TransactionBalanceWidget(
                                          transaction: parentTransaction!,
                                        ),
                                      kVerticalSpaceMedium
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          )),
        );
      },
    );
  }
}
