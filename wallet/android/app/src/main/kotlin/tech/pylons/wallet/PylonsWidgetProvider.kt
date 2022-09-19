package tech.pylons.wallet

//import android.R
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews


class PylonsWidgetProvider : AppWidgetProvider() {

//    fun updateAppWidget(
//        context: Context, appWidgetManager: AppWidgetManager,
//        appWidgetId: Int
//    ) {
//
//        val views = RemoteViews(context.packageName, R.layout.pylons_widget_layout)
//
//        appWidgetManager.updateAppWidget(appWidgetId, views)
//    }


    override fun onReceive(context: Context?, intent: Intent) {
        val mgr = AppWidgetManager.getInstance(context)
//        if (intent.action == TOAST_ACTION) {
//            val appWidgetId = intent.getIntExtra(
//                AppWidgetManager.EXTRA_APPWIDGET_ID,
//                AppWidgetManager.INVALID_APPWIDGET_ID
//            )
//            val viewIndex = intent.getIntExtra(EXTRA_ITEM, 0)
//        }
        super.onReceive(context, intent)
    }


    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
//        for (appWidgetId in appWidgetIds) {
//            updateAppWidget(context, appWidgetManager, appWidgetId)
//        }
//        appWidgetIds.forEach { appWidgetId ->
//
//            val intent = Intent(context, PylonsWidgetService::class.java).apply {
//                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
//                data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
//            }
//            val views = RemoteViews(context.packageName, R.layout.pylons_widget_layout).apply {
//                setRemoteAdapter(R.id.grid_view, intent)
//
//                setEmptyView(R.id.grid_view, R.id.empty_view)
//            }
//
//            appWidgetManager.updateAppWidget(appWidgetId, views)
//
//        }
//
//        super.onUpdate(context, appWidgetManager, appWidgetIds)
//    }
        for (i in appWidgetIds) {
            // Here we setup the intent which points to the StackViewService which will
            // provide the views for this collection.
            val intent = Intent(context, PylonsWidgetService::class.java)
            intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetIds[i])
            // When intents are compared, the extras are ignored, so we need to embed the extras
            // into the data so that the extras will not be ignored.
            intent.setData(Uri.parse(intent.toUri(Intent.URI_INTENT_SCHEME)))
            val rv = RemoteViews(context.packageName, R.layout.pylons_widget_layout)
            rv.setRemoteAdapter(R.id.grid_view, intent)
            // The empty view is displayed when the collection has no items. It should be a sibling
            // of the collection view.
            rv.setEmptyView(R.id.grid_view, R.id.empty_view);
            // Here we setup the a pending intent template. Individuals items of a collection
            // cannot setup their own pending intents, instead, the collection as a whole can
            // setup a pending intent template, and the individual items can set a fillInIntent
            // to create unique before on an item to item basis.

            intent.setData(Uri.parse(intent.toUri(Intent.URI_INTENT_SCHEME)));

            appWidgetManager.updateAppWidget(appWidgetIds[i], rv);
        }
        super.onUpdate(context, appWidgetManager, appWidgetIds);
    }




}


