import 'dart:math';

class StringUtils {
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  static String getRandomString(int length) {
    return String.fromCharCodes(Iterable.generate(length, (_) {
      Random _rnd = Random();
      return _chars.codeUnitAt(_rnd.nextInt(_chars.length));
    }));
  }
}
