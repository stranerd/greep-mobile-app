import 'package:intl/intl.dart';

extension NairaExtension on num {
  String toNairaValue(){
    var format = NumberFormat.simpleCurrency(name: 'NGN');
    return "${format.currencySymbol}" +
        NumberFormat.simpleCurrency()
            .format(this)
            .replaceFirst("\$", "");
  }


}