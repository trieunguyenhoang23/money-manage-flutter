import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../provider/profile_provider.dart';

class ProfileLoggedInScreen extends ConsumerWidget {
  const ProfileLoggedInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(
      profileProvider.select((s) => s.value?.userLocalModel),
    );

    double icSize = 0.25.sw.clamp(75, 150);
    double textSize = 0.05.sw.clamp(15, 25);

    return user != null
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ThumbnailNetworkWidget(
                w: icSize,
                h: icSize,
                imgUrl: user.avatarUrl!,
                radius: icSize / 2,
              ),
              const SizedBox(height: 10),
              TextGGStyle(
                user.displayName!,
                textSize,
                fontWeight: FontWeight.w600,
              ),
            ],
          )
        : const SizedBox();
  }
}
