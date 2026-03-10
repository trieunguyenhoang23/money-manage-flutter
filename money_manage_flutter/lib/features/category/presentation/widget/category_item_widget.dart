import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/router.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';
import '../../data/model/local/category_local_model.dart';

class CategoryItemWidget extends StatelessWidget {
  final CategoryLocalModel item;

  const CategoryItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigatorRouter.pushNamed(
          context,
          CategoryRoutes.editCateName,
          extra: item,
        );
      },
      child: LayoutBuilder(
        builder: (context, cc) {
          return Container(
            decoration: BoxDecoration(
              color: ColorConstant.neutral200,
              borderRadius: BorderRadius.all(
                Radius.circular(cc.maxHeight * 0.1),
              ),
              boxShadow: [shadowStyle(Colors.black12, const Offset(0, 2), 5)],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: cc.maxHeight * 0.05,
                horizontal: cc.maxWidth * 0.025,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextGGStyle(
                            item.name ?? '',
                            cc.maxWidth * 0.05,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextGGStyle(
                          item.type?.displayTitle(context) ?? '',
                          cc.maxWidth * 0.035,
                          color: item.type?.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextGGStyle(
                        item.description ?? '',
                        cc.maxWidth * 0.035,
                        color: ColorConstant.neutral400,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextGGStyle(
                      '${context.lang.created_at} ${item.createdAt.formatFull(context)}',
                      cc.maxWidth * 0.035,
                      color: ColorConstant.neutral400,
                      maxLines: 2,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextGGStyle(
                      '${context.lang.updated_at} ${item.updatedAt.formatFull(context)}',
                      cc.maxWidth * 0.035,
                      color: ColorConstant.neutral400,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
