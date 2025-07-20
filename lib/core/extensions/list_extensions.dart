import 'package:ytmusic/ytmusic.dart';

extension FindByMinWidth on List<YTThumbnail> {
  YTThumbnail byWidth(int specifiedWidth) {
    for (final element in this) {
      final width = element.width;
      if (width >= specifiedWidth) {
        return element;
      }
    }
    return last;
  }
}
