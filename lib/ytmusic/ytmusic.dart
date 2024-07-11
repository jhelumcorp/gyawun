library ytmusic;

import 'package:gyawun_beta/ytmusic/mixins/library.dart';
import 'mixins/browsing.dart';
import 'mixins/search.dart';
import 'mixins/user.dart';
import 'yt_service_provider.dart';

class YTMusic extends YTMusicServices
    with BrowsingMixin, SearchMixin, LibraryMixin, UserMixin {
  YTMusic() {
    checkLogged();
  }
}
