package tech.pylons.wallet

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import androidx.core.net.toUri
import tech.pylons.wallet.R


class PylonsWidgetService : RemoteViewsService() {
    
    private lateinit var collectionsApi: Pigeon.CollectionsApi

    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return GridRemoteViewsFactory(this.applicationContext, intent, collectionsApi)
    }
}

class GridRemoteViewsFactory(
    private val context: Context,
    intent: Intent,
    private val collectionsApi: Pigeon.CollectionsApi
) : RemoteViewsService.RemoteViewsFactory {
    private var count: Int = 6

    private lateinit var widgetItems: List<Pigeon.NFTMessage>

    override fun onCreate() {
        widgetItems = collectionsApi.getCollection()

    }

    override fun getViewAt(position: Int): RemoteViews {

        return RemoteViews(context.packageName, R.layout.nft_image).apply {
            setImageViewUri(R.id.nft, widgetItems[position].imageUrl.toUri())
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
