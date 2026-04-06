# uCrop (image_cropper) rules
-keep class com.yalantis.ucrop.** { *; }
-keep interface com.yalantis.ucrop.** { *; }

# OkHttp3 rules (Giải quyết lỗi Missing class okhttp3...)
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# Nếu vẫn báo thiếu okio thì thêm dòng này
-keep class okio.** { *; }