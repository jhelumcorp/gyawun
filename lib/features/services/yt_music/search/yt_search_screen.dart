import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/features/services/yt_music/explore/yt_explore_screen.dart';
import 'package:gyawun_music/features/services/yt_music/search/cubit/search_cubit.dart';
import 'package:gyawun_music/features/services/yt_music/search/yt_search_result_screen.dart';
import 'package:ytmusic/yt_music_base.dart';

class YTSearchScreen extends StatelessWidget {
  const YTSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(sl<YTMusic>()),
      child: const YTSearchScreenView(),
    );
  }
}

class YTSearchScreenView extends StatefulWidget {
  const YTSearchScreenView({super.key});

  @override
  State<StatefulWidget> createState() => _YTSearchScreenViewState();
}

class _YTSearchScreenViewState extends State<YTSearchScreenView> {
  String? query;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 130,
              collapsedHeight: 75,
              flexibleSpace: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final appBarHeight = constraints.maxHeight;
                      const collapsedHeight = kToolbarHeight;
                      final isCollapsed = appBarHeight <= collapsedHeight;
                      const collapsedTop = (kToolbarHeight - 56) / 2;

                      return Stack(
                        children: [
                          // Title animated
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8, left: 8),
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: isCollapsed ? 0 : 1,
                                child: AnimatedSlide(
                                  duration: const Duration(milliseconds: 300),
                                  offset: isCollapsed ? const Offset(0, -0.2) : Offset.zero,
                                  child: Text(
                                    "Search",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: "paytoneOne",
                                      fontWeight: FontWeight.w300,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // SEARCH FIELD
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            top: isCollapsed ? collapsedTop : null,
                            child: Hero(
                              tag: "searchBar",
                              child: SearchBar(
                                readOnly: true,
                                hintText: query ?? 'songs, artists, albums...',
                                elevation: const WidgetStatePropertyAll(0),
                                backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).colorScheme.surfaceContainer,
                                ),
                                onTap: () async {
                                  final q = await context.push<String?>(
                                    '/ytmusic/search/suggestions?${query != null ? 'q=$query' : ''}',
                                  );
                                  if (q?.trim() != query?.trim()) {
                                    setState(() {
                                      query = q;
                                    });
                                    if (context.mounted) {
                                      context.read<SearchCubit>().search(query!);
                                    }
                                  }
                                },
                                trailing: query == null
                                    ? null
                                    : [
                                        IconButton(
                                          onPressed: () {
                                            query = null;
                                            setState(() {});
                                          },
                                          icon: const Icon(FluentIcons.dismiss_24_filled),
                                        ),
                                      ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ];
        },

        body: query == null ? const YTExploreScreen() : const YTSearchResultView(),
      ),
    );
  }
}
