package tech.pylons.wallet

import android.appwidget.AppWidgetManager
import android.content.Context
import android.net.Uri
import android.widget.RemoteViews
import android.content.Intent
import android.appwidget.AppWidgetProvider
import tech.pylons.wallet.R


class PylonsWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
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
}

