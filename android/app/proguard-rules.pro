# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers

## Keep Razorpay classes and member
-keep class com.razorpay.** { *; }
-keep class com.razorpay.Razorpay** { *; }
-keep class com.razorpay.**$* { *; }

## Keep other necessary classes
-dontwarn com.razorpay.**

-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/
-keepclasseswithmembers class * {
  public void onPayment*(...);
}