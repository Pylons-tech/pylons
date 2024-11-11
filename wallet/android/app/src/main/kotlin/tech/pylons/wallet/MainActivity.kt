package tech.pylons.wallet

import io.flutter.embedding.android.FlutterFragmentActivity
import androidx.annotation.NonNull
import com.google.firebase.FirebaseApp
import com.google.firebase.appcheck.debug.DebugAppCheckProviderFactory
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "getFirebaseAppCheckTokenMethodChannel"
        ).setMethodCallHandler { call, result ->
            if (call.method == "getFirebaseAppCheckDebugToken") {
                FirebaseApp.initializeApp(this)
                result.success(true)
            }
        }
    }
}

