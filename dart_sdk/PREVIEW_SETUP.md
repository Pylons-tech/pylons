## Quick setup (preview edition)

You are advised to clone an existing repository instead of trying to set up a project from scratch using this SDK. **This is a preview release**, so keep that in mind. In the near future, we'll provide an actual template project you can use and some scripts to make that quick and painless: in the mean time it's totally fine to clone testapp. You'll just need to replace a few package names to get started.

Change all occurences of testapp's package (tech.pylons.testapp_flutter) to your own in the following files:

* `android/app/src/main/AndroidManifest.xml`
* `android/app/src/profile/AndroidManifest.xml`
* `android/app/build.gradle`
* `ios/Runner/Info.plist`

(You should also go ahead and set the app names in the `AndroidManifest` and the `Info.plist` as appropriate.)

Move `android/app/src/main/kotlin/tech/pylons/testapp_flutter/MainActivity.kt` to a path corresponding to your package name.

It's also probably advisable to set the name/description in your `pubspec.yaml` to something sensible and rename the root directory of your project accordingly.
