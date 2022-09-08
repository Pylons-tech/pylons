package tech.pylons.wallet

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    lateinit var collectionsApi: Pigeon.CollectionsApi

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        collectionsApi = Pigeon.CollectionsApi(flutterEngine.dartExecutor.binaryMessenger)
    }

}
