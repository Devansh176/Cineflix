# Flutter-specific rules
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# Do not obfuscate any Retrofit or TMDB API-related classes
-keep class retrofit2.** { *; }
-keepattributes Signature
-keepattributes Annotation

# Retain data classes and keep Gson serialization/deserialization working
-keep class com.google.gson.** { *; }
-keep class com.google.gson.annotations.** { *; }

# OkHttp rules to prevent obfuscation
-dontwarn okhttp3.**
-keep class okhttp3.** { *; }
-keepclassmembers class okhttp3.** { *; }

# Prevent obfuscation of network-related code
-keep class org.apache.http.** { *; }
-keep class javax.net.ssl.** { *; }

# Prevent obfuscation of Flutter classes
-keep class io.flutter.** { *; }
-keepclassmembers class io.flutter.** { *; }

# Do not remove or rename methods/classes used by reflection
-keepattributes InnerClasses,EnclosingMethod
-keepclassmembers class ** {
    *;
}
-keepnames class * {
    *;
}

# Retain Firebase-related classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Razorpay-specific rules
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Do not strip out logging
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
    public static int w(...);
    public static int e(...);
}

# Optimize the rules for better performance
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*
