############################################
# Flutter
############################################
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

############################################
# Kotlin / Coroutines
############################################
-keep class kotlin.** { *; }
-dontwarn kotlin.**
-dontwarn kotlinx.coroutines.**

############################################
# CameraX (mobile_scanner dùng)
############################################
-keep class androidx.camera.** { *; }
-dontwarn androidx.camera.**

############################################
# MLKit Barcode
############################################
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_barcode.** { *; }
-dontwarn com.google.mlkit.**
-dontwarn com.google.android.gms.**

############################################
# Google Play Services (MLKit phụ thuộc)
############################################
-keep class com.google.android.gms.common.** { *; }
-dontwarn com.google.android.gms.common.**

############################################
# TensorFlow Lite (nếu có dùng)
############################################
-keep class org.tensorflow.lite.** { *; }
-dontwarn org.tensorflow.lite.**

############################################
# JSON Serialization (nếu có)
############################################
-keepattributes *Annotation*
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

############################################
# Google Play Core (Flutter Deferred Components)
############################################
-dontwarn com.google.android.play.core.**