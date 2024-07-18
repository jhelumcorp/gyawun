String getEnhancedImage(String imageUrl,
    {String quality = 'high', double? width, double? dp}) {
  if (width != null) {
    int newWidth = ((dp ?? 1) * width).ceil();
    return imageUrl
        .trim()
        .replaceAll('w60-h60', 'w${newWidth.toInt()}-h${newWidth.toInt()}')
        .replaceAll('w226-h226', 'w${newWidth.toInt()}-h${newWidth.toInt()}')
        .replaceAll('w540-h225', 'w${newWidth.toInt()}-h${newWidth.toInt()}')
        .replaceAll('w544-h544', 'w${newWidth.toInt()}-h${newWidth.toInt()}')
        .replaceAll('=s192', '=s$newWidth')
        .replaceAll('=s1200', '=s$newWidth')
        .replaceAll('sddefault', 'mqdefault');
  }
  switch (quality) {
    case 'high':
      return imageUrl
          .trim()
          .replaceAll('w60-h60', 'w500-h500')
          .replaceAll('w226-h226', 'w500-h500')
          .replaceAll('w540-h225', 'w500-h500')
          .replaceAll('w544-h544', 'w500-h500')
          .replaceAll('sddefault', 'mqdefault');
    case 'medium':
      return imageUrl
          .trim()
          .replaceAll('w60-h60', 'w300-h300')
          .replaceAll('w226-h226', 'w300-h300')
          .replaceAll('w540-h225', 'w300-h300')
          .replaceAll('w544-h544', 'w300-h300')
          .replaceAll('sddefault', 'mqdefault');
    case 'low':
      return imageUrl
          .trim()
          .replaceAll('w60-h60', 'w100-h100')
          .replaceAll('w226-h226', 'w100-h100')
          .replaceAll('w540-h225', 'w100-h100')
          .replaceAll('w544-h544', 'w100-h100')
          .replaceAll('sddefault', 'mqdefault');

    default:
      return imageUrl.trim().replaceAll('sddefault', 'maxresdefault');
  }
}
