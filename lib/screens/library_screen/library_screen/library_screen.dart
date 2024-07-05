import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../generated/l10n.dart';
import '../../../services/yt_account.dart';
import 'local_library.dart';
import 'ytm_library.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: GetIt.I<YTAccount>().isLogged,
        builder: (context, isLogged, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).Library),
              centerTitle: true,
              bottom: isLogged
                  ? TabBar(
                      controller: _tabController,
                      labelColor: Theme.of(context).colorScheme.primary,
                      unselectedLabelColor:
                          Theme.of(context).colorScheme.primary.withAlpha(100),
                      tabs: const [
                        Tab(
                          text: 'Local',
                        ),
                        Tab(
                          text: 'YT Music',
                        ),
                      ],
                      dividerColor:
                          Theme.of(context).colorScheme.primary.withAlpha(100),
                    )
                  : null,
            ),
            body: isLogged
                ? TabBarView(
                    controller: _tabController,
                    children: const [
                      LocalLibrary(),
                      YTMLibraryScreen(),
                    ],
                  )
                : const LocalLibrary(),
          );
        });
  }
}
