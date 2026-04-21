import 'package:flutter/material.dart';

typedef LoadMoreCallBack = Future<void> Function();

void updateAnimationLastItem(List previous, List next,
    {required ScrollController scrollController}) {
  final prevLength = previous.length;
  final nextLength = next.length;

  if (nextLength > prevLength) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      final max = scrollController.position.maxScrollExtent;
      final pos = scrollController.position.pixels;

      final hasMoreData = (max - pos) > 100;

      if (hasMoreData) {
        const double nudge = 100.0;
        final target = (pos + nudge).clamp(0.0, max);
        Future.delayed(const Duration(microseconds: 500),(){
          scrollController.animateTo(target,
              duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
        });
      }
    });
  }
}
