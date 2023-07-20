String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

  String newHours = duration.inHours > 0 ? '${duration.inHours}:' : '';
  String newMinutes = int.parse(twoDigitMinutes) > 0 ? '$twoDigitMinutes:' : '';

  return "$newHours$newMinutes$twoDigitSeconds";
}
