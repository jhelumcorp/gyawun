String getEnhancedImage(String imageUrl,
    {String quality = 'high', double? width}) {
  if (width != null) {
    return imageUrl
        .trim()
        .replaceAll('http:', 'https:')
        .replaceAll('50x50', '${width.toInt()}x${width.toInt()}')
        .replaceAll('150x150', '${width.toInt()}x${width.toInt()}')
        .replaceAll('w60-h60', 'w${width.toInt()}-h${width.toInt()}')
        .replaceAll('sddefault', 'mqdefault');
  }
  switch (quality) {
    case 'high':
      return imageUrl
          .trim()
          .replaceAll('http:', 'https:')
          .replaceAll('50x50', '500x500')
          .replaceAll('150x150', '500x500')
          .replaceAll('w60-h60', 'w500-h500')
          .replaceAll('sddefault', 'mqdefault');
    case 'medium':
      return imageUrl
          .trim()
          .replaceAll('http:', 'https:')
          .replaceAll('50x50', '300x300')
          .replaceAll('500x500', '300x300')
          .replaceAll('w60-h60', 'w300-h300')
          .replaceAll('sddefault', 'mqdefault');
    case 'low':
      return imageUrl
          .trim()
          .replaceAll('http:', 'https:')
          .replaceAll('150x150', '50x50')
          .replaceAll('500x500', '50x50');
    default:
      return imageUrl
          .trim()
          .replaceAll('http:', 'https:')
          .replaceAll('50x50', '500x500')
          .replaceAll('60x60', '500x500')
          .replaceAll('150x150', '500x500')
          .replaceAll('sddefault', 'maxresdefault');
  }
}
