import 'package:money_manage_flutter/core/utils/size_app_utils.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';
import '../../../data/model/overview_analytics_model.dart';
import '../../provider/overview_analytics_provider.dart';
import 'overview_item_widget.dart';

class OverviewGirdViewWidget extends ConsumerWidget {
  const OverviewGirdViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewGraphState = ref.watch(overviewGraphProvider);

    return overviewGraphState.when(
      loading: () => const LoadingWidget(),
      error: (err, _) => Center(child: TextGGStyle("Error: $err", 14)),
      data: (data) {
        if (data.overViewAnalytics == null) return const SizedBox.shrink();
        OverviewAnalytics overviewAnalytics = data.overViewAnalytics!;
        return GridViewBuilder(
          crossAxisCount: SizeAppUtils().isTablet ? 3 : 2,
          itemCount: overviewAnalytics.points.length,
          itemBuilder: (context, index) {
            OverviewPoint item = overviewAnalytics.points[index];

            return OverviewItemWidget(item: item);
          },
          childAspectRatio: 2,
        );
      },
    );
  }
}
