import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';

mixin ScaffoldMessengerService<K extends StatefulWidget> on State<K> {
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  set error(String? error) {
    if (error != null && error != "") {
      scaffoldMessengerKey.currentState!
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
          width: Get.width * 0.85,
          backgroundColor: Colors.grey.shade100,
          shape: const BeveledRectangleBorder(),
          padding: const EdgeInsets.all(kDefaultSpacing * 0.75),
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              const Icon(Icons.cancel, color: kErrorColor),
              kHorizontalSpaceTiny,
              FittedBox(
                child: Text(
                  error,
                  style: kDefaultTextStyle.copyWith(
                    fontSize: 13
                  ),
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ));
    }
  }

  set success(String? message) {
    if (message != null && message != "") {
      scaffoldMessengerKey.currentState!
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
          width: 250,
          backgroundColor: Colors.grey.shade200,
          shape: const BeveledRectangleBorder(),
          padding: const EdgeInsets.all(kDefaultSpacing * 0.75),
          behavior: SnackBarBehavior.floating,
          content: SizedBox(
            width: 245,
            child: Row(
              children: [
                const Icon(Icons.check, color: kPrimaryColor),
                kHorizontalSpaceTiny,
                Expanded(
                  child: Text(
                    message,
                    style: kDefaultTextStyle.copyWith(
                        fontSize: 13
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ));
    }
  }

  set loading(bool showLoading) {
    if (showLoading) {
      scaffoldMessengerKey.currentState!
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
            backgroundColor: const Color(0xff303030),
            content: Row(children: const [
              Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Loading",
                  ))
            ]),
            duration: const Duration(days: 365)));
    }
  }

  set warning(String? message) {
    if (message != null && message != "") {
      scaffoldMessengerKey.currentState!
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: const EdgeInsets.symmetric(
              vertical: kDefaultSpacing, horizontal: kDefaultSpacing * 0.5),
          padding: const EdgeInsets.all(kDefaultSpacing),
          backgroundColor: kErrorColor,
          content: Text(
            message,
            style: kWhiteTextStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ));
    }
  }

  Future<bool?> confirm(
      {String yesText = "Yes",
      String noText = "No",
      IconData icon = Icons.info,
      String title = "Confirm",
      String body = "Please confirm this action."}) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(icon),
                ),
                Text(title)
              ]),
              content: Text(body),
              actions: [
                ElevatedButton(
                  child: Text(yesText),
                  onPressed: () => Navigator.pop(context, true),
                ),
                TextButton(
                  child: Text(noText,
                      style: const TextStyle(color: kPrimaryColor)),
                  onPressed: () => Navigator.pop(context, false),
                )
              ]);
        });
  }
}
