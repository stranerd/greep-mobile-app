import 'package:timeago/timeago.dart';

class MyCustomMessages implements LookupMessages {
  @override String prefixAgo() => '';
  @override String prefixFromNow() => '';
  @override String suffixAgo() => '';
  @override String suffixFromNow() => '';
  @override String lessThanOneMinute(int seconds) => '0 mins';
  @override String aboutAMinute(int minutes) => '${minutes}mins';
  @override String minutes(int minutes) => '${minutes}mins';
  @override String aboutAnHour(int minutes) => '${minutes}mins';
  @override String hours(int hours) => '${hours}hr';
  @override String aDay(int hours) => '${hours}hr';
  @override String days(int days) => '${days}days';
  @override String aboutAMonth(int days) => '${days}days';
  @override String months(int months) => '${months}mo';
  @override String aboutAYear(int year) => '${year}yr';
  @override String years(int years) => '${years}yr';
  @override String wordSeparator() => ' ';
}
