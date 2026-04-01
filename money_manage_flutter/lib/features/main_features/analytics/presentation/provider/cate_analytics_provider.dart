import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/enum/transaction_type.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../export/ui_external.dart';
import '../../domain/usecase/get_categories_analytics_usecase.dart';

class AnalyticsParam {
  final TransactionType type;
  final DateTime startDate;
  final DateTime endDate;

  AnalyticsParam({
    required this.type,
    required this.startDate,
    required this.endDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyticsParam &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          startDate == other.startDate &&
          endDate == other.endDate;

  @override
  int get hashCode => type.hashCode ^ startDate.hashCode ^ endDate.hashCode;
}

final cateAnalyticsProvider = FutureProvider.family
    .autoDispose<List<PieChartSectionData>, TransactionType>((ref, type) async {
      final useCase = getIt<GetCategoriesAnalyticsUseCase>();

      final result = await useCase.execute(type);

      return await result.fold(
        (error) {
          throw error.message;
        },
        (data) {
          final totalSum = data.fold<double>(
            0,
            (sum, item) => sum + item.totalAmount,
          );

          List<PieChartSectionData> pieChartData = data.map((item) {
            final percentage = (item.totalAmount / totalSum) * 100;
            return PieChartSectionData(
              color: generateUniqueColorById(item.id),
              value: item.totalAmount,
              title: '${item.name} \n ${percentage.toStringAsFixed(1)}%',
              radius: 50,
              titleStyle: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList();

          return pieChartData;
        },
      );
    });
