<!--
order: 1
-->


#Pylons Quickstart:

Get connected to the Pylons network and integrate blockchain technology into your application.

Integrating Pylons into your app is as easy as three steps:

Add the pylons_flutter dependency directly into your project without needing to write a config file to connect to the Pylons chain.

Enable deep links for both Android and iOS to enable cross-platform development.

Import the Pylons SDK and create test request to ensure everything is ready to go.

##Step 1: Add pylons_flutter dependency

Open pubspec.yaml file within the app folder and add pylons_flutter: path: [TO BE UPDATED ON LAUNCH] under dependencies. You should have something similar to the following example:

pubspec.yaml

```
dependencies:
    flutter:
        sdk: flutter

    cupertino_icons: ^1.0.2

    pylons_flutter:
        path: ../
```

##Step 2: Enable deep links for Android and iOS

Android and iOS require deep links permission within their respectful config files in order to connect to the blockchain.

###For Android:

You need to declare the following intent filters in android/app/src/main/AndroidManifest.xml:

AndroidManifest.xml

```
<manifest ...>

<application ...> <activity ...>

  <!-- Pylons Links -->
  <intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <!-- Accepts URIs that begin with YOUR_SCHEME://YOUR_HOST -->
    <data
      android:scheme="pylons"
      android:host="[YOUR_HOST]" />
  </intent-filter>

</activity>
```

The android:host attribute variable is the one you need and it must be as unique as possible. We recommend you make this your app name!

###For iOS:

We are currently waiting for developer approval. In the meantime, you can read about Custom URL Schemes, which we will be using for the Flutter integration.

Uni Links - iOS Flutter Development

##Step 3: Import Pylons into your application

Before you run your application, make sure you initialize the Pylons SDK in main.dart file.

main.dart

```
void main() {
    WidgetsFlutterBinding.ensureInitialized();

    PylonsWallet.setup(mode: PylonsMode.prod, host: 'YOUR_APP_NAME');

    runApp(const MyApp());
}
```

It’s important that you allow the SDK to initialize prior to the build of your application. To test this, include an override function to check the wallet has been initialized like the example below.

main.dart

```
@override
void initState() {
    super.initState();
    PylonsWallet.instance.exists().then((value){
    log('WALLET Existence $value');
    });
}
```

Check your console log and you should see this:

```
r/flutter: WALLET Existence true
```

Got it? You’re now ready to start developing with Pylons! 