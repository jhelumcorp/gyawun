import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import '../ytmusic/modals/user.dart';
import '../ytmusic/ytmusic.dart';

class YTAccount {
  ValueNotifier<bool> isLogged = GetIt.I<YTMusic>().isLogged;
  ValueNotifier<User?> user = ValueNotifier(null);

  YTAccount() {
    _initialize();
  }
  _initialize() async {
    user.value = await GetIt.I<YTMusic>().getUserInfo();
    GetIt.I<YTMusic>().isLogged.addListener(() async {
      await GetIt.I<YTMusic>().refreshHeaders();
      isLogged.value = GetIt.I<YTMusic>().isLogged.value;
      user.value = await GetIt.I<YTMusic>().getUserInfo();
    });
  }

  login(context) async {
    await GetIt.I<YTMusic>().toggleLogin(context);
    await GetIt.I<YTMusic>().refreshHeaders();
  }

  logOut(context) async {
    await GetIt.I<YTMusic>().toggleLogin(context);
    await GetIt.I<YTMusic>().refreshHeaders();
  }
}
