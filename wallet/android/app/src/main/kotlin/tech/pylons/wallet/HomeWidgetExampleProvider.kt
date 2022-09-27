package tech.pylons.wallet

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.widget.RemoteViews
import androidx.core.content.FileProvider
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import tech.pylons.wallet.R
import java.io.File


class HomeWidgetExampleProvider : HomeWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->


            try {
                val views = RemoteViews(context.packageName, R.layout.example_layout).apply {

                    println("Widget data got")
                    println(widgetData.getString("image", ""))




                    println("Jawad ${Uri.parse(widgetData.getString("image", ""))}")




                    val file = File(widgetData.getString("image", "").toString());



                    val bitmap: Bitmap = BitmapFactory.decodeFile(file.path)



                    println(file.exists())

                    setImageViewBitmap(R.id.imageView, bitmap)




                    val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                            context,
                            MainActivity::class.java)
                    setOnClickPendingIntent(R.id.widget_container, pendingIntent)

                    val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
                            context,
                            Uri.parse("homeWidgetExample://titleClicked")
                    )
                    setOnClickPendingIntent(R.id.imageView, backgroundIntent)

                }

                appWidgetManager.updateAppWidget(widgetId, views)

            } catch (e: Exception){
                println(e)
            }
        }
    }
}