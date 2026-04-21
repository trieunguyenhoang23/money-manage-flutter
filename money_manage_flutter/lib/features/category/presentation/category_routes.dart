import 'package:money_manage_flutter/export/router.dart';
import '../data/model/local/category_local_model.dart';
import 'screen/create_category_screen.dart';
import 'screen/edit_category_screen.dart';

class CategoryRoutes {
  static const categoryPath = '/category';
  static const categoryName = 'category';

  static const createNewCatePath = 'createNewCatePath';
  static const createNewCateName = 'createNewCateName';

  static const editCatePath = 'editCategoryPath';
  static const editCateName = 'editCategoryName';

  static final routes = [
    GoRoute(
      path: categoryPath,
      name: categoryName,
      builder: (context, state) => const CategoryScreen(),
      routes: [
        GoRoute(
          path: createNewCatePath,
          name: createNewCateName,
          builder: (context, state) => const CreateCategoryScreen(),
        ),
        GoRoute(
          path: editCatePath,
          name: editCateName,
          builder: (context, state) {
            final category = state.extra as CategoryLocalModel;
            return EditCategoryScreen(item: category);
          },
        ),
      ],
    ),
  ];
}
