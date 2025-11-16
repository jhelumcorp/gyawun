import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/widgets/tiles/section_column_title.dart';
import 'package:gyawun_music/features/services/yt_music/search/cubit/suggestion_cubit.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';
import 'package:ytmusic/ytmusic.dart';

class YTSuggestionsScreen extends StatelessWidget {
  const YTSuggestionsScreen({super.key, this.query});
  final String? query;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SuggestionCubit(sl<YTMusic>())..fetchSuggestions(query),
      child: YTSuggestionsPage(query: query),
    );
  }
}

class YTSuggestionsPage extends StatefulWidget {
  const YTSuggestionsPage({super.key, this.query});
  final String? query;

  @override
  State<YTSuggestionsPage> createState() => _YTSuggestionsPageState();
}

class _YTSuggestionsPageState extends State<YTSuggestionsPage> {
  String? query;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    query = widget.query;
    controller = TextEditingController(text: widget.query);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Hero(
          tag: "searchBar",

          child: SearchBar(
            elevation: const WidgetStatePropertyAll(0),
            controller: controller,
            autoFocus: true,
            hintText: 'songs, artists, albums...',
            onChanged: (value) {
              setState(() {
                query = value.isEmpty ? null : value;
              });
              if (value.isNotEmpty) {
                context.read<SuggestionCubit>().fetchSuggestions(value);
              }
            },
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            trailing: query == null
                ? null
                : [
                    IconButton(
                      onPressed: () {
                        query = null;
                        controller.text = '';
                        setState(() {});
                      },
                      icon: const Icon(FluentIcons.dismiss_24_filled),
                    ),
                  ],
            onSubmitted: (value) {
              Navigator.pop(context, value);
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<SuggestionCubit, SuggestionState>(
          builder: (context, state) {
            if (state is SuggestionLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SuggestionError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            if (state is SuggestionSuccess) {
              return CustomScrollView(
                slivers: [
                  if (state.data.sectionItems.isNotEmpty)
                    SliverList.separated(
                      itemCount: state.data.sectionItems.length,
                      itemBuilder: (context, index) {
                        final item = state.data.sectionItems[index];
                        return SectionColumnTile(
                          item: item,
                          isFirst: state.data.sectionItems.indexOf(item) == 0,
                          isLast:
                              state.data.sectionItems.indexOf(item) ==
                              state.data.sectionItems.length - 1,
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 2),
                    ),
                  if (state.data.textItems.isNotEmpty)
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  if (state.data.textItems.isNotEmpty)
                    SliverList.separated(
                      itemCount: state.data.textItems.length,
                      itemBuilder: (context, index) {
                        final item = state.data.textItems[index];
                        return SettingTile(
                          title: item,
                          leading: const Icon(FluentIcons.search_24_regular),
                          isFirst: state.data.textItems.indexOf(item) == 0,
                          isLast:
                              state.data.textItems.indexOf(item) == state.data.textItems.length - 1,
                          onTap: () {
                            Navigator.pop(context, state.data.textItems[index]);
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 2),
                    ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
