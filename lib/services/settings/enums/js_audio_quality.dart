enum JSAudioQuality {
  high(320),
  medium(160),
  low(96);

  const JSAudioQuality(this.bitrate);

  /// Bitrate in kbps
  final int bitrate;

  /// Create from bitrate value (METHOD 1 - Recommended)
  static JSAudioQuality fromBitrate(int bitrate) {
    return JSAudioQuality.values.firstWhere(
      (q) => q.bitrate == bitrate,
      orElse: () => JSAudioQuality.medium,
    );
  }

  /// Create from enum index (METHOD 2)
  static JSAudioQuality fromIndex(int index) {
    if (index >= 0 && index < JSAudioQuality.values.length) {
      return JSAudioQuality.values[index];
    }
    return JSAudioQuality.medium; // default
  }
}
