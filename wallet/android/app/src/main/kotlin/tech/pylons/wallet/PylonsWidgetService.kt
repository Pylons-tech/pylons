package tech.pylons.wallet

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import androidx.core.net.toUri
import android.content.SharedPreferences
import tech.pylons.wallet.AndroidPreferences


import tech.pylons.wallet.R
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger


class PylonsWidgetService : RemoteViewsService() {

//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//    }

    //private var flutterEngine = FlutterEngine.
//    val flutterBackgroundController = FlutterBackgroundController(this.applicationContext, AndroidPreferences(this.applicationContext))
//
//    val flutterEngine = flutterBackgroundController.getBackgroundFlutterEngine()
//
//
//    private var collectionsApi: Pigeon.CollectionsApi = Pigeon.CollectionsApi(flutterEngine?.dartExecutor?.binaryMessenger
//        ?: null
//    )

    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return GridRemoteViewsFactory(this.applicationContext, intent)//, collectionsApi)
    }
}

class GridRemoteViewsFactory(
    private val context: Context,
    intent: Intent,
   // private val collectionsApi: Pigeon.CollectionsApi
) : RemoteViewsService.RemoteViewsFactory {
    private var count: Int = 6

    private lateinit var widgetItems: List<Int>

    override fun onCreate() {
//        var listening: Pigeon.CollectionsApi? = null
       //collectionsApi.getCollection(){
//           if (listening == null) {
//               val flutterEngine = flutterBackgroundController.getBackgroundFlutterEngine()
//               if (flutterEngine != null) {
//                   Pigeon.MessageUtils.setup(
//                       flutterEngine.dartExecutor.binaryMessenger)
//                   listening = Pigeon.CollectionsApi(flutterEngine.dartExecutor.binaryMessenger)
//               }
////           }
//           result -> widgetItems=result
//       }
        widgetItems = listOf(R.drawable.sunflowers, R.drawable.sunflowers, R.drawable.sunflowers, R.drawable.sunflowers, R.drawable.sunflowers, R.drawable.sunflowers, R.drawable.sunflowers)

    }

    override fun getViewAt(position: Int): RemoteViews {

        return RemoteViews(context.packageName, R.layout.nft_image).apply {
            //setImageViewUri(R.id.nft, widgetItems[position].toUri())
            setImageViewResource(R.id.nft, widgetItems[position])
        }
    }

    override fun getLoadingView(): RemoteViews? {
        return null
    }

    override fun getViewTypeCount(): Int {
        return 1
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun hasStableIds(): Boolean {
        return true
    }

    override fun onDataSetChanged() {
    }

    override fun onDestroy() {
    }

    override fun getCount(): Int {
        return count
    }


// See the RemoteViewsFactory API reference for the full list of methods to
// implement.

}
