library ytmusic;

import 'mixins/browsing.dart';
import 'mixins/library.dart';
import 'mixins/search.dart';
import 'mixins/user.dart';
import 'yt_service_provider.dart';

class YTMusic extends YTMusicServices
    with BrowsingMixin, SearchMixin, LibraryMixin, UserMixin {}
