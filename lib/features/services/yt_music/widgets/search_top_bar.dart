import 'package:flutter/material.dart';
import 'package:gyawun_music/features/services/yt_music/search/cubit/search_cubit.dart';

import 'section_column_tile.dart';

class SearchTopBar extends StatelessWidget {
  final void Function(String value)? onSubmit;
  final SearchCubit searchCubit;
  const SearchTopBar({super.key, this.onSubmit,required this.searchCubit});

  @override
  Widget build(BuildContext context,) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 150,
      collapsedHeight: 90,
      flexibleSpace: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final appBarHeight = constraints.maxHeight;
              final collapsedHeight = kToolbarHeight;
              final isCollapsed = appBarHeight <= collapsedHeight + 10;

              final double collapsedTop = (kToolbarHeight - 56) / 2;

              return Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isCollapsed ? 0 : 1,
                        child: AnimatedSlide(
                          duration: const Duration(milliseconds: 300),
                          offset: isCollapsed
                              ? const Offset(0, -0.2)
                              : Offset.zero,
                          child: Text(
                            "Search",
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: isCollapsed ? collapsedTop : null,
                    child: SearchAnchor(
                      builder: (context, controller) {
                        return SearchBar(
                          backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.primaryContainer,
                          ),
                          elevation: const WidgetStatePropertyAll(0),
                          controller: controller,
                          hintText: "songs, artists, albums...",
                          padding: const WidgetStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            if (value.trim().isEmpty) return;
                            if(onSubmit!=null){
                              onSubmit!(value);
                            }
                            controller.closeView(value);
                          },
                          onTap: () => controller.openView(),
                          leading: const Icon(Icons.search),
                        );
                      },
                      suggestionsBuilder: (context, controller) async {
                        final results = await searchCubit.searchSuggestions(controller.text);

                        return [
                          ...results.textItems.map(
                            (text) => ListTile(
                              title: Text(text),
                              onTap: () {
                                controller.closeView(text);
                                if (onSubmit != null) {
                                  onSubmit!(text);
                                }
                              },
                            ),
                          ),
                          ...results.sectionItems.map(
                            (e) => SectionColumnTile(
                              item: e,
                              onTap: () =>
                                  controller.closeView(controller.text),
                            ),
                          ),
                        ];
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
