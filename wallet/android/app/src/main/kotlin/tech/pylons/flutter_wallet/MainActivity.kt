package tech.pylons.flutter_wallet

import io.flutter.embedding.android.FlutterActivity
import tech.pylons.wallet.Pigeon
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    lateinit var collectionsApi: Pigeon.CollectionsApi

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        collectionsApi = Pigeon.CollectionsApi(flutterEngine.dartExecutor.binaryMessenger)
    }

}
