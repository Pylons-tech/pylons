package tech.pylons.wallet

//import android.R
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import tech.pylons.wallet.R


class PylonsWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
//        for (appWidgetId in appWidgetIds) {
//            updateAppWidget(context, appWidgetManager, appWidgetId)
//        }
        appWidgetIds.forEach { appWidgetId ->

            val intent = Intent(context, PylonsWidgetService::class.java).apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
            }
            val views = RemoteViews(context.packageName, R.layout.pylons_widget_layout).apply {
                setRemoteAdapter(R.id.grid_view, intent)

                setEmptyView(R.id.grid_view, R.id.empty_view)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)

        }

        super.onUpdate(context, appWidgetManager, appWidgetIds)
    }

//    private fun updateAppWidget(
//        context: Context, appWidgetManager: AppWidgetManager,
//        appWidgetId: Int
//    ) {
//
//        //val views = RemoteViews(context.packageName, R.layout.pylons_widget_layout)
//
//        appWidgetManager.updateAppWidget(appWidgetId, views)
//    }

}

