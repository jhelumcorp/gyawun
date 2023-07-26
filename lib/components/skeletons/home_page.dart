import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class HomePageSkeleton extends StatelessWidget {
  const HomePageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SkeletonItem(
                  child: SkeletonParagraph(
                style: const SkeletonParagraphStyle(
                    padding: EdgeInsets.zero,
                    spacing: 0,
                    lines: 1,
                    lineStyle: SkeletonLineStyle(
                      height: 22,
                    )),
              )),
            ),
            SizedBox(
              height: 191,
              child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return SkeletonItem(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SkeletonParagraph(
                                style: const SkeletonParagraphStyle(
                                    padding: EdgeInsets.zero,
                                    spacing: 0,
                                    lines: 10,
                                    lineStyle: SkeletonLineStyle(
                                      height: 15,
                                      borderRadius: BorderRadius.zero,
                                    )),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 150,
                            height: 32,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SkeletonParagraph(
                                style: const SkeletonParagraphStyle(
                                    padding: EdgeInsets.zero,
                                    spacing: 0,
                                    lines: 2,
                                    lineStyle: SkeletonLineStyle(
                                      height: 15,
                                      borderRadius: BorderRadius.zero,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemCount: 5),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}
