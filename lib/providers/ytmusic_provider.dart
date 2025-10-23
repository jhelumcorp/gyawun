// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gyawun_music/providers/database_provider.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:ytmusic/ytmusic.dart';

// part 'ytmusic_provider.g.dart';

// @riverpod
// YTMusic ytmusic(Ref ref) {
//   return ref
//       .watch(ytMusicSettingsProvider)
//       .maybeWhen(
//         data: (settings) {
//           return YTMusic(
//             config: YTConfig(
//               visitorData: settings.visitorId ?? '',
//               language: settings.language.value,
//               location: settings.location.value,
//             ),
//           );
//         },
//         orElse: () => YTMusic(),
//       );
// }
