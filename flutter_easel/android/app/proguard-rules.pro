#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.* { *; }
-keep class io.flutter.util.* { *; }
-keep class io.flutter.view.* { *; }
-keep class io.flutter.* { *; }
-keep class io.flutter.plugins.* { *; }

-dontwarn com.yalantis.ucrop**
-keep class com.yalantis.ucrop** { *; }
-keep interface com.yalantis.ucrop** { *; }
-keep class androidx.appcompat.** { *; }

-dontwarn org.xmlpull.v1.XmlPullParser
-dontwarn org.xmlpull.v1.XmlSerializer
-keep class org.xmlpull.v1.* {*;}

-keep class * implements android.os.Parcelable {
   public static final android.os.Parcelable$Creator *;
}