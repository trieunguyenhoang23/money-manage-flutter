# uCrop
-keep class com.yalantis.ucrop.** { *; }
-keep interface com.yalantis.ucrop.** { *; }

# OkHttp3 & Okio
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-keep class okio.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# WorkManager
-keep class be.tramckrijte.workmanager.** { *; }
-keep class androidx.work.** { *; }

# Socket.io
-keep class io.socket.** { *; }
-dontwarn io.socket.**

# Isar
-keep class io.isar.** { *; }
-keep enum io.isar.** { *; }
-dontwarn io.isar.**