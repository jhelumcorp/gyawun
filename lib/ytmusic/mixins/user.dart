import '../helpers.dart';
import '../modals/user.dart';
import '../yt_service_provider.dart';

mixin UserMixin on YTMusicServices {
  Future<User?> getUserInfo() async {
    if (isLogged.value == false) return null;

    String endpoint = 'account/account_menu';
    var response = await sendRequest(endpoint, {});
    // pprint(response);
    Map? header = nav(response, [
      'actions',
      0,
      'openPopupAction',
      'popup',
      'multiPageMenuRenderer',
      'header',
      'activeAccountHeaderRenderer'
    ]);

    User user = User(
      name: nav(header, ['accountName', 'runs', 0, 'text']),
      photos: nav(header, ['accountPhoto', 'thumbnails']),
      channelHandle: nav(header, ['channelHandle', 'runs', 0, 'text']),
    );
    return user;
  }
}
