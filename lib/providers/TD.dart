library chunked_downloader;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

/// Progress Callback
/// [progress] is the current progress in bytes
/// [total] is the total size of the file in bytes
typedef ProgressCallback = void Function(int progress, int total, double speed);

/// On Done Callback
/// [file] is the downloaded file
typedef OnDoneCallback = void Function(File file);

/// On Error Callback
/// [error] is the error that occured
typedef OnErrorCallback = void Function(dynamic error);

/// Custom Downloader with ChunkSize
///
/// [chunkSize] is the size of each chunk in bytes
///
/// [onProgress] is the callback function that will be called when the download is in progress
///
/// [onDone] is the callback function that will be called when the download is done
///
/// [onError] is the callback function that will be called when the download is failed
///
/// [onCancel] is the callback function that will be called when the download is canceled
///
/// [onPause] is the callback function that will be called when the download is paused
///
/// [onResume] is the callback function that will be called when the download is resumed
///
class ChunkedDownloader {
  final String url;
  final String path;
  final String title;
  final String extension;
  final int chunkSize;
  final ProgressCallback? onProgress;
  final OnDoneCallback? onDone;
  final OnErrorCallback? onError;
  final Function? onCancel;
  final Function? onPause;
  final Function? onResume;
  StreamSubscription<StreamedResponse>? stream;
  ChunkedStreamReader<int>? reader;
  Map<String, String>? headers;
  double speed = 0;
  bool paused = false;
  bool done = false;
  static const bool kDebugMode = false;

  ChunkedDownloader({
    required this.url,
    required this.path,
    required this.title,
    this.extension = 'mp3',
    this.headers,
    this.chunkSize = 1024 * 1024, // 1 MB
    this.onProgress,
    this.onDone,
    this.onError,
    this.onCancel,
    this.onPause,
    this.onResume,
  });

  /// Start the download
  /// @result {Future<ChunkedDownloader>} the current instance of the downloader
  Future<ChunkedDownloader> start() async {
    // Download file
    try {
      int offset = 0;
      var httpClient = http.Client();
      var request = http.Request('GET', Uri.parse(url));
      // Set headers
      if (headers != null) {
        request.headers.addAll(headers!);
      }
      var response = httpClient.send(request);

      // Open file
      File file = File('$path/$title.$extension');

      stream = response.asStream().listen(null);
      stream?.onData((http.StreamedResponse r) async {
        // Get file size
        int fileSize = int.tryParse(r.headers['content-length'] ?? '-1') ?? -1;
        reader = ChunkedStreamReader(r.stream);
        try {
          Uint8List buffer;
          do {
            while (paused) {
              await Future.delayed(const Duration(milliseconds: 500));
            }
            // Set start time for speed calculation
            int startTime = DateTime.now().millisecondsSinceEpoch;

            // Read chunk
            buffer = await reader!.readBytes(chunkSize);

            // Calculate speed
            int endTime = DateTime.now().millisecondsSinceEpoch;
            int timeDiff = endTime - startTime;
            if (timeDiff > 0) {
              speed = (buffer.length / timeDiff) * 1000;
            }

            // Add buffer to chunks list
            offset += buffer.length;
            if (kDebugMode) {
              print('Downloading ${offset ~/ 1024 ~/ 1024}MB '
                  'Speed: ${speed ~/ 1024 ~/ 1024}MB/s');
            }
            if (onProgress != null) {
              onProgress!(offset, fileSize, speed);
            }
            // Write buffer to disk
            await file.writeAsBytes(buffer, mode: FileMode.append);
          } while (buffer.length == chunkSize);

          // Rename file from .tmp to non-tmp extension

          // Send done callback
          done = true;
          if (onDone != null) {
            onDone!(file);
          }
          if (kDebugMode) {
            print('Downloaded file.');
          }
        } catch (error) {
          if (kDebugMode) {
            print('Error downloading: $error');
          }
          if (onError != null) {
            onError!(error);
          }
        } finally {
          reader?.cancel();
          stream?.cancel();
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error downloading: $error');
      }
      if (onError != null) {
        onError!(error);
      }
    }
    return this;
  }

  /// Stop the download
  void stop() {
    stream?.cancel();
    reader?.cancel();
    if (onCancel != null) {
      onCancel!();
    }
  }

  /// Pause the download
  void pause() {
    paused = true;
    if (onPause != null) {
      onPause!();
    }
  }

  /// Resume the download
  void resume() {
    paused = false;
    if (onResume != null) {
      onResume!();
    }
  }
}
