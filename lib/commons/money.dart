import 'package:intl/intl.dart';

extension MoneyExtension on num {
  String get toMoney {
    final oCcy = new NumberFormat("#,##0", "en_US");
    return oCcy.format(this);
}
}
