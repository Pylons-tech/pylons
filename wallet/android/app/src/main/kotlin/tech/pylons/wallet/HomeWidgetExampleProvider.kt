package tech.pylons.wallet

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.widget.RemoteViews
import androidx.core.net.toUri
import com.bumptech.glide.Glide
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class HomeWidgetExampleProvider : HomeWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->

            try {
                val views = RemoteViews(context.packageName, R.layout.example_layout).apply {

                    val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                            context,
                            MainActivity::class.java)
                    setOnClickPendingIntent(R.id.widget_container, pendingIntent)


                        try {
                            val bitmap: Bitmap = Glide.with(context)
                                .asBitmap()
                                .load(widgetData.getString("image", "")?.toUri())
                                .submit(512, 512)
                                .get()
                            setImageViewBitmap(R.id.imageView, bitmap)
                        } catch (e: java.lang.Exception) {
                            e.printStackTrace()
                        }


                }

                appWidgetManager.updateAppWidget(widgetId, views)

            } catch (e: Exception){
                println(e)
            }
        }
    }
}