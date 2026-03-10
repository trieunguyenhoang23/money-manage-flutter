import 'package:flutter/material.dart';

class GridViewBuilder extends StatelessWidget {
  final int crossAxisCount;
  final int itemCount;
  final ScrollController? scrollController;
  final IndexedWidgetBuilder itemBuilder;
  final double childAspectRatio;
  final bool isScrollHorizontal;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  const GridViewBuilder({
    super.key,
    required this.crossAxisCount,
    required this.itemCount,
    this.scrollController,
    required this.itemBuilder,
    required this.childAspectRatio,
    this.isScrollHorizontal = false,
    this.mainAxisSpacing = 20,
    this.crossAxisSpacing = 20,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // cacheExtent: double.infinity,
      scrollDirection: isScrollHorizontal ? Axis.horizontal : Axis.vertical,
      controller: scrollController,
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: itemBuilder,
      itemCount: itemCount,
    );
  }
}
