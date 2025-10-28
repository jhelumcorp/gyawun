import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/features/services/yt_music/explore/yt_explore_screen.dart';
import 'package:gyawun_music/features/services/yt_music/search/cubit/search_cubit.dart';
import 'package:gyawun_music/features/services/yt_music/search/yt_search_result_screen.dart';
import 'package:gyawun_music/features/services/yt_music/widgets/search_top_bar.dart';
import 'package:ytmusic/yt_music_base.dart';

class YTSearchScreen extends StatelessWidget {
  const YTSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(sl<YTMusic>()),
      child: YTSearchScreenView(),
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
            SearchTopBar(
              onSubmit: (value) {
                setState(() {
                  query = value;
                  if(query!=null){
                    context.read<SearchCubit>().search(query!);
                  }
                });
              },
              searchCubit: context.read<SearchCubit>(),
            ),
          ];
        },

        body:query==null? YTExploreScreen(): YTSearchResultView(),
      ),
    );
  }
}
