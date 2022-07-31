class Funcs {
  String removeTrailingZero(double theNumber) {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

    String s = theNumber.toString().replaceAll(regex, '');
    return s;
  }
}
