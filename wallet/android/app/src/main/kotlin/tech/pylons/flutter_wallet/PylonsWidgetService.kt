package tech.pylons.wallet

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import androidx.core.net.toUri
import io.flutter.embedding.engine.FlutterEngine
import java.util.List
//import tech.pylons.wallet.Pigeon
import io.flutter.embedding.android.FlutterActivity
import tech.pylons.flutter_wallet.MainActivity


class PylonsWidgetService : RemoteViewsService() {
    
    //private var collectionsApi: Pigeon.CollectionsApi = MainActivity

    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return GridRemoteViewsFactory(this.applicationContext, intent)//, collectionsApi)
    }
}

class GridRemoteViewsFactory(
    private val context: Context,
    intent: Intent,
    //collectionsApi: Pigeon.CollectionsApi
) : RemoteViewsService.RemoteViewsFactory {
    private var count: Int = 6

    //private var collectionsApi: Pigeon.CollectionsApi = Pigeon.CollectionsApi(flutterEngine.dartExecutor.binaryMessenger)

    //private lateinit var widgetItems: List

    private var widgetItems = listOf<String>("san-antonio-tx-flowers-on-the-porch-joanne-beecham")

    override fun onCreate() {
        // In onCreate() you setup any connections / cursors to your data
        // source. Heavy lifting, for example downloading or creating content
        // etc, should be deferred to onDataSetChanged() or getViewAt(). Taking
        // more than 20 seconds in this call will result in an ANR.
        //widgetItems = collectionsApi.getCollections()
        //widgetItems = List(REMOTE_VIEW_COUNT) { index -> WidgetItem("$index!") }
        //widgetItems = listOf("san-antonio-tx-flowers-on-the-porch-joanne-beecham")
    }

    override fun getViewAt(position: Int): RemoteViews {
        // Construct a remote views item based on the widget item XML file,
        // and set the text based on the position.
        return RemoteViews(context.packageName, R.layout.nft_image).apply {
            setImageViewUri(R.id.nft, widgetItems[position].toUri())//.imageUrl.toUri())
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
        // This is triggered when you call AppWidgetManager notifyAppWidgetViewDataChanged
        // on the collection view corresponding to this factory. You can do heaving lifting in
        // here, synchronously. For example, if you need to process an image, fetch something
        // from the network, etc., it is ok to do it here, synchronously. The widget will remain
        // in its current state while work is being done here, so you don't need to worry about
        // locking up the widget.
    }

    override fun onDestroy() {
        // In onDestroy() you should tear down anything that was setup for your data source,
        // eg. cursors, connections, etc.
        //widgetItems.clear()
    }

    override fun getCount(): Int {
        return count
    }


// See the RemoteViewsFactory API reference for the full list of methods to
// implement.

}
