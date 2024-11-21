library ytmusic;

import 'package:gyawun/ytmusic/mixins/library.dart';

import 'mixins/browsing.dart';
import 'mixins/search.dart';
import 'yt_service_provider.dart';

class YTMusic extends YTMusicServices
    with BrowsingMixin, LibraryMixin, SearchMixin {}
