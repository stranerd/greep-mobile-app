import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrCode extends StatefulWidget {
  const ScanQrCode({Key? key}) : super(key: key);

  @override
  _ScanQrCodeState createState() => _ScanQrCodeState();
}

class _ScanQrCodeState extends State<ScanQrCode> {


  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color(0x7F001726),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.r),
          child: Column(
            children: [
              SizedBox(height: 24.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BackIcon(isArrow: true,color: kWhiteColor),
                  Column(
                    children: [
                      TextWidget("Confirm delivery",fontSize: 18.sp,weight: FontWeight.bold,color: Colors.white,),
                      const TextWidget("Scan customer QR code",color: Colors.white,),
                    ],
                  ),
                  const Visibility(visible: false
                    ,child: BackIcon(),)
                ],
              ),
              SizedBox(height: 100.h,),
              Container(
                height: 311.r,
                width: 311.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r,),

                ),
                child: MobileScanner(
                    controller: cameraController,
                    // allowDuplicates: false,
                    onDetect: (barcode,) {
                      if (barcode.barcodes.first.rawValue == null) {
                        Fluttertoast.showToast(msg: "Invalid QR Code");
                        debugPrint('Failed to scan Barcode');
                      } else {
                        final String code = barcode.barcodes.first
                            .rawValue!;
                        debugPrint('Barcode found! $code');
                      }
                    }),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
