class NumberFormatter {
  static String format(Duration text) {
    int d = text.inDays;
    int h = text.inHours - d * 24;
    int m = text.inMinutes - h * 60 - d * 24*60;
    return '$d d $h h $m m';
  }
}
