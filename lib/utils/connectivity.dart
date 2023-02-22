import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> isConnectivity() async {
  final ConnectivityResult connectivity =
      await Connectivity().checkConnectivity();
  return connectivity == ConnectivityResult.mobile ||
      connectivity == ConnectivityResult.wifi;
}
