package "tech.pylons.wallet"

import java.util.ArrayList;
import java.util.List;
import android.appwidget.AppWidgetManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.widget.RemoteViews;
import android.widget.RemoteViewsService;

class PylonsWidgetService : RemoteViewsService() {

    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return GridRemoteViewsFactory(this.applicationContext, intent)
    }
}

class GridRemoteViewsFactory(
    private val context: Context,
    intent: Intent
) : RemoteViewsService.RemoteViewsFactory {

    private lateinit var collectionsApi: CollectionsApi = CollectionsApi();

    private lateinit var widgetItems: List<NFT>

    override fun onCreate() {
        // In onCreate() you setup any connections / cursors to your data
        // source. Heavy lifting, for example downloading or creating content
        // etc, should be deferred to onDataSetChanged() or getViewAt(). Taking
        // more than 20 seconds in this call will result in an ANR.
        widgetItems = collectionsApi.getCollections();
        //widgetItems = List(REMOTE_VIEW_COUNT) { index -> WidgetItem("$index!") }
        ...
    }

    override fun getViewAt(position: Int): RemoteViews {
        // Construct a remote views item based on the widget item XML file,
        // and set the text based on the position.
        return RemoteViews(context.packageName, R.layout.widget_item).apply {
            setTextViewText(R.id.widget_item, widgetItems[position].text)
        }
    }



// See the RemoteViewsFactory API reference for the full list of methods to
// implement.

}
