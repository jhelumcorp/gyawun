import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:gyawun_beta/utils/bottom_modals.dart';
import 'package:gyawun_beta/ytmusic/ytmusic.dart';

import '../ytmusic/modals/user.dart';

class YTAccount {
  ValueNotifier<bool> isLogged = GetIt.I<YTMusic>().isLogged;
  ValueNotifier<User?> user = ValueNotifier(null);

  YTAccount() {
    _initialize();
  }
  _initialize() async {
    user.value = await GetIt.I<YTMusic>().getUserInfo();
  }

  Future<List> fetchLibraryPlaylists() async {
    if (!isLogged.value) {
      return List.empty();
    }
    return await GetIt.I<YTMusic>().getLibraryPlaylists();
  }

  login(context) async {
    bool loggedIn = await GetIt.I<YTMusic>().toggleLogin(context);

    if (loggedIn) {
      Modals.showCenterLoadingModal(context);
      await GetIt.I<YTMusic>().refreshHeaders();
      user.value = await GetIt.I<YTMusic>().getUserInfo();
      Navigator.pop(context);
    }
  }

  logOut(context) async {
    await GetIt.I<YTMusic>().toggleLogin(context);
    await GetIt.I<YTMusic>().refreshHeaders();
    isLogged.value = false;
    user.value = null;
  }
}
