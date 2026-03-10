import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/router.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/features/category/presentation/widget/category_grid_view_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: context.lang.category,
        actionBtn: [
          BtnAppbarWidget(
            onTap: () {
              NavigatorRouter.pushNamed(
                context,
                CategoryRoutes.createNewCateName,
              );
            },
            widget: const Icon(Icons.add, color: ColorConstant.primary),
          ),
        ],
      ),
      body: const PaddingStyle(
        child: Column(children: [Expanded(child: CategoryGridViewWidget())]),
      ),
    );
  }
}
