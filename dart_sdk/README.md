# Pylons Dart SDK

A Flutter plugin project to connect any app with the Pylons blockchain.

Note: In order to be able to connect to the Pylons blockchain, you must already have a Pylons wallet installed on your mobile device. This package does not presently support desktop platforms.

## **Installation**

<br>

### **Add the pylons_flutter dependency**

Open your pubspec.yaml file within the app folder and add:

```
dependencies:
    pylons_sdk: ^0.1.2
```

<br>

### **Enable deep links**

**Permissions**  
Android and iOS must declare link permissions in a configuration file.

Feel free to examine the example app in the example directory for Deep Links (Android) and Custom URL schemes (iOS).

The following steps are platform-specific:

<br>

**For Android:**

You need to declare the following intent filters in `android/app/src/main/AndroidManifest.xml:`

```
<manifest ...>
    <!-- ... other tags -->
    <queries>
        <package android:name="tech.pylons.wallet" />
    </queries>

    <application ...>
        <activity ...>
        <!-- ... other tags -->

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
    </application>
</manifest>
```

**You** are responsible for setting the value of the `android:host` attribute. Note that it should be as unique as possible.

<br>

**For IOS:**  
You need to declare the following in `ios/Runner/Info.plist`:

```
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLName</key>
			<string>[Put your bundle id here]</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>pylons-[YOUR_HOST]</string>
			</array>
		</dict>
	</array>
    <key>LSApplicationQueriesSchemes</key>
    <array>
        <string>pylons-wallet</string>
    </array>
```

Note: Don't put any underscores in the host name, or the iOS system will not send a response from the wallet to your app.

<br>

### **Import the Pylons SDK and send a test request**

**In `main.dart`**

Initialise the SDK before running the app:

```
void main(){
    WidgetsFlutterBinding.ensureInitialized();

    PylonsWallet.setup(mode: PylonsMode.prod, host: 'example');

    runApp(const MyApp());
}
```

Your host here should be as in the following files:

- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`
