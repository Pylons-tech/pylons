# testapp-flutter

This repository contains the Flutter project corresponding to the BlockSlayer demo game for the Pylons SDK, 
available on Google Play [here](https://play.google.com/store/apps/details?id=tech.pylons.testapp_flutter).

Feel free to peruse it to get an idea of what a very, very minimal set of game mechanics built on the Pylons
tools might look like, or use it as a starting point for your own projects!

## Getting Started

testapp-flutter is just a normal Flutter project; no surprises here. Clone it and build it like any other
Flutter app. Note, though, that at present this application *only* supports mobile platforms, and has only been
adequately tested on Android.

If you're using this project as a base for
your own, change all occurrences of the BlockSlayer package ID (tech.pylons.testapp_flutter) to your own in the 
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
