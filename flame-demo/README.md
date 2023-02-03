# flame-demo

Simple demonstration app for Pylons integration with Flame Engine. Can be used as a reference,
or directly as a starting point for your own projects.

## Getting Started

flame-demo is just a normal Flutter project; no surprises here. Clone it and build it like any other
Flutter app. Note, though, that at present this application *only* supports Android.

If you're using this project as a base for
your own, change all occurrences of the demo package ID (tech.pylons.flame_demo) to your own in the 
following files:

* `android/app/src/main/AndroidManifest.xml`
* `android/app/src/profile/AndroidManifest.xml`
* `android/app/build.gradle`
* `ios/Runner/Info.plist`

(You should also go ahead and set the app names in the `AndroidManifest` and the `Info.plist` as appropriate.)

Move `android/app/src/main/kotlin/tech/pylons/testapp_flutter/MainActivity.kt` to a path corresponding to your 
package name.

It's also probably advisable to set the name/description in your `pubspec.yaml` to something sensible and rename the 
root directory of your project accordingly.
