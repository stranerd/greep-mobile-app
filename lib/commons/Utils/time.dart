

String date(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return "${date.day.toString()}/${date.month.toString()}/${date.year.toString()}";
}

String datetime(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return "${date.day.toString()}/${date.month.toString()}/${(date.year).toString()} ${date.hour < 10 ? ('0' + date.hour.toString()) : date.hour.toString()}:${date.minute < 10 ? '0' + date.minute.toString() : date.minute.toString()}";
}

List<int> duration(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return [
    date.year - 1970,
    date.month,
    date.day,
    date.hour,
    date.minute,
    date.second
  ];
}

String when(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var now = DateTime.now();
  if (now.difference(date).inDays > 1) {
    var weekday =
        ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][date.weekday - 1];
    var month = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ][date.month - 1];
    return "$weekday, ${date.day} $month";
  } else if (now.difference(date).inDays == 1) {
    return "yesterday";
  } else {
    return "";
  }
}
