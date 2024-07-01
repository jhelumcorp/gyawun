import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../generated/l10n.dart';
import '../../themes/colors.dart';
import '../../ytmusic/ytmusic.dart';
import 'section_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final YTMusic ytMusic = GetIt.I<YTMusic>();
  late ScrollController _scrollController;
  late List chips = [];
  late List sections = [];
  int page = 0;
  String? continuation;
  bool initialLoading = true;
  bool nextLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    fetchHome();
  }

  _scrollListener() async {
    if (initialLoading || nextLoading || continuation == null) {
      return;
    }

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      await fetchNext();
    }
  }

  fetchHome() async {
    setState(() {
      initialLoading = true;
      nextLoading = false;
    });
    Map<String, dynamic> home = await ytMusic.browse();
    // pprint(home);
    if (mounted) {
      setState(() {
        initialLoading = false;
        nextLoading = false;
        chips = home['chips'];
        sections = home['sections'];
        continuation = home['continuation'];
      });
    }
    // pprint(home['sections'][1]['contents']);
    // await fetchNext();
  }

  refresh() async {
    if (initialLoading) return;
    Map<String, dynamic> home = await ytMusic.browse();
    if (mounted) {
      setState(() {
        initialLoading = false;
        nextLoading = false;
        chips = home['chips'];
        sections = home['sections'];
        continuation = home['continuation'];
      });
    }
  }

  fetchNext() async {
    if (continuation == null) return;
    setState(() {
      nextLoading = true;
    });
    Map<String, dynamic> home =
        await ytMusic.browseContinuation(additionalParams: continuation!);
    List<Map<String, dynamic>> secs =
        home['sections'].cast<Map<String, dynamic>>();
    if (mounted) {
      setState(() {
        sections.addAll(secs);
        continuation = home['continuation'];
        nextLoading = false;
      });
    }
  }

  Widget _horizontalChipsRow(List data) {
    var list = <Widget>[const SizedBox(width: 16)];
    for (var element in data) {
      list.add(InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: () => context.go('/chip', extra: element),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              color: darkGreyColor.withAlpha(100),
              borderRadius: BorderRadius.circular(10)),
          child: Text(element['title']),
        ),
      ));
      list.add(const SizedBox(
        width: 8,
      ));
    }
    list.add(const SizedBox(
      width: 8,
    ));
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: LayoutBuilder(builder: (context, constraints) {
          return AppBar(
            title: Hero(
              tag: "SearchField",
              child: Material(
                color: Colors.transparent,
                child: SizedBox(
                  width: constraints.maxWidth > 400 ? 350 : null,
                  child: TextField(
                    onTap: () => context.go('/search'),
                    readOnly: true,
                    decoration: InputDecoration(
                      fillColor: darkGreyColor.withAlpha(100),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: BorderSide.none,
                      ),
                      hintText: S.of(context).searchGyawun,
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
            centerTitle: false,
          );
        }),
      ),
      body: initialLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => refresh(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                controller: _scrollController,
                child: SafeArea(
                  child: Column(
                    children: [
                      _horizontalChipsRow(chips),
                      Column(
                        children: [
                          ...sections.map((section) {
                            return SectionItem(section: section);
                          }),
                          if (!nextLoading && continuation != null)
                            const SizedBox(height: 50),
                          if (nextLoading) const CircularProgressIndicator(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
