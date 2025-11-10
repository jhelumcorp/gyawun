import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

Future<int?> extractDominantColor(String imageUrl) async {
  try {
    final uri = Uri.parse(imageUrl);
    final resp = await http.get(uri);
    if (resp.statusCode != 200) return null;

    final bytes = resp.bodyBytes;
    final image = img.decodeImage(bytes);
    if (image == null) return null;

    const int step = 4;

    int rSum = 0;
    int gSum = 0;
    int bSum = 0;
    int count = 0;

    final int width = image.width;
    final int height = image.height;

    for (int y = 0; y < height; y += step) {
      for (int x = 0; x < width; x += step) {
        final pixel = image.getPixelSafe(x, y); // Pixel object
        final int a = pixel.a.toInt();
        if (a == 0) continue; // skip transparent pixels

        rSum += pixel.r.toInt();
        gSum += pixel.g.toInt();
        bSum += pixel.b.toInt();
        count++;
      }
    }

    if (count == 0) return null;

    final int rAvg = (rSum / count).round();
    final int gAvg = (gSum / count).round();
    final int bAvg = (bSum / count).round();

    // Return opaque ARGB color
    return (0xFF << 24) | (rAvg << 16) | (gAvg << 8) | bAvg;
  } catch (e) {
    return null;
  }
}
