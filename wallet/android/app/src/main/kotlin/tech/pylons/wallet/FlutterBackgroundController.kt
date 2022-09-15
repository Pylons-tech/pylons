package tech.pylons.wallet

import android.content.Context
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister
import io.flutter.view.FlutterCallbackInformation
import kotlinx.coroutines.*
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import android.content.SharedPreferences
import javax.inject.Inject
import javax.inject.Singleton
import tech.pylons.wallet.AndroidPreferences

@Singleton
class FlutterBackgroundController @Inject constructor(
    private val context: Context,
    private val androidPreferences: AndroidPreferences,
    //private val backgroundFlutterSubcomponentFactory: BackgroundFlutterSubcomponent.Factory
) {
    private val mutex = Mutex()
    private var engine: FlutterEngine? = null

    fun getBackgroundFlutterEngine(): FlutterEngine? {
        engine?.let { return it }

//        mutex.withLock {
            val currentEngine = engine
            if (currentEngine != null) {
                return currentEngine
            }

            engine = initEngine()
            return engine
//        }
    }

    private fun initEngine(): FlutterEngine? {//= withContext(Dispatchers.Main.immediate) {
        // Flutter must be initialized on the main thread
        val KEY_FLUTTER_BACKGROUND_HANDLE = "FlutterBackgroundHandle"

        //val preferences = context.getSharedPreferences("android", Context.MODE_PRIVATE)

        val backgroundEndpointMethodHandle = androidPreferences.backgroundEndpoint
            ?: return null//return@withContext null

//        if (backgroundEndpointMethodHandleNullable==null) {
//            return
//        }


//        val backgroundEndpointMethodHandle = androidPreferences.backgroundEndpoint
//            ?: return@withContext null

        val callbackInformation: FlutterCallbackInformation = try {
            FlutterCallbackInformation
                .lookupCallbackInformation(backgroundEndpointMethodHandle)
        } catch (e: NullPointerException) {
            // Even though this method is marked as @NonNull, it can still return null which
            // confuses Kotlin runtime and crashes the app.

            // Catch this exception here and treat this error
            // as if set method handle is invalid.
            //return@withContext null
            return null
        }

        val bundlePath = FlutterInjector.instance().flutterLoader().findAppBundlePath()

        val callback = DartExecutor.DartCallback(
            context.assets,
            bundlePath,
            callbackInformation
        )

        val flutterEngine = FlutterEngine(context)

        flutterEngine.localizationPlugin.sendLocalesToFlutter(context.resources.configuration)

        return flutterEngine
    }
}