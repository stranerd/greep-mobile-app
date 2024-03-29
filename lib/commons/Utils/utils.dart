import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils with ChangeNotifier {
  String randomNum = '';
  bool isExpanded = false;
  String fcmToken = '';
  bool isExpanded1 = true;
  bool isLoading = false;



  setLoading(value){
    isLoading = value;
    notifyListeners();
  }
  // static StreamTransformer transformer<T>(
  //         T Function(Map<String, dynamic> json) fromJson) =>
  //     StreamTransformer<QuerySnapshot, List<T>>.fromHandlers(
  //       handleData: (QuerySnapshot data, EventSink<List<T>> sink) {
  //         final snaps = data.docs.map((doc) => doc.data()).toList();
  //         final users = snaps.map((json) => fromJson(json)).toList();
  //         sink.add(users);
  //       },
  //     );


  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }

  String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    randomNum = String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    return randomNum;
  }

  setFCMToken(value) {
    fcmToken = value;
    notifyListeners();
  }

  compareDate(DateTime date) {
    if(date == null){
      return '...';
    }
    else if (date.difference(DateTime.now()).inHours.abs() <= 24) {
      var value = formatTime(date);
      return value;
    } else if (date.difference(DateTime.now()).inHours.abs() >= 24 &&
        date.difference(DateTime.now()).inHours.abs() <= 48) {
      return 'yesterday';
    } else {
      var value = formatYear(date);
      return value;
    }
  }


  compareDateChat(DateTime date) {
    if(date == null){
      return '...';
    }
    else if (date.difference(DateTime.now()).inHours.abs() <= 22) {
      var value = formatTime(date);
      return value;
    } else if (date.difference(DateTime.now()).inHours.abs() >= 22 &&
        date.difference(DateTime.now()).inHours.abs() <= 48) {
      var value = formatTime(date);
      return 'yesterday at $value';
    } else {
      var value = formatYear(date);
      return value;
    }
  }

  formatDate(DateTime now) {
    final DateFormat formatter = DateFormat('yyyy-MMMM-dd hh:mm');
    final String formatted = formatter.format(now);
    notifyListeners();
    return formatted;
  }

  formatTime(DateTime now) {
    final DateFormat formatter = DateFormat().add_jm();
    final String formatted = formatter.format(now);
    return formatted;
  }

  formatYear(DateTime now) {
    final DateFormat formatter = DateFormat('dd/M/yyyy');
    final String formatted = formatter.format(now==null?DateTime.now():now);
    return formatted;
  }

  formatYear2(DateTime now) {
    final DateFormat formatter = DateFormat('dd/MMMM/yyyy');
    final String formatted = formatter.format(now==null?DateTime.now():now);
    return formatted;
  }


  XFile? selectedImage;
  final picker = ImagePicker();
  Future selectimage({required ImageSource source, context}) async {
    var image = await picker.pickImage(source: source);
    selectedImage = image!;
    notifyListeners();
  }




  XFile? selectedImage2;

  Future selectimage2({required ImageSource source, context}) async {
    var images = await picker.pickImage(source: source);
    selectedImage2 = images!;

    notifyListeners();
  }



  late XFile ediproductImage;
  Future selectProductImage({required ImageSource source, context}) async {
    var images = await picker.pickImage(source: source);
    ediproductImage = images!;
    notifyListeners();
  }


  selectProductImagetoNull(){
//    ediproductImage = null;
    notifyListeners();
  }

  selectedImage2toNull(){
//selectedImage2 = null;
notifyListeners();
  }

  onExpansionChanged(bool val) {
    isExpanded = val;
  }

  onExpansionChanged1(bool val) {
    isExpanded1 = val;
  }

  Future storeData(String name, data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name, data);
  }

  Future storeDataInt(String name, data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(name, data);
  }

  Future getData(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString(name)!;
    return data;
  }

}

extension CapExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }

  String get capitalizeFirstOfEach =>
      this.split(" ").map((str) => str == "" ? "" : str.capitalize()).join(" ");
}

String formatCurrency(String country, double number) =>
    NumberFormat.simpleCurrency(name: country, decimalDigits: 2).format(number);

String formatDecimal(double number) =>
    NumberFormat('#########0.0').format(number);

String currencySymbol(String currencyCode) =>
    NumberFormat().simpleCurrencySymbol(currencyCode);

bool areDatesEqual(DateTime a, DateTime b){
  return (a.year == b.year &&
      a.month == b.month && a.day == b.day
  );
}
