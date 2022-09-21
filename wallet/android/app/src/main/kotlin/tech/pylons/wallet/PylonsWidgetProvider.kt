
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
import java.io.File

class PylonsWidgetProvider : HomeWidgetProvider() {
//    override fun onUpdate(
//        context: Context,
//        appWidgetManager: AppWidgetManager,
//        appWidgetIds: IntArray,
//        widgetData: SharedPreferences
//    ) {
//        appWidgetIds.forEach { widgetId ->
//            try {
//                val views = RemoteViews(context.packageName, R.layout.example_layout).apply {
//                    val file = File(widgetData.getString("image", "").toString());
//                    val bitmap: Bitmap = BitmapFactory.decodeFile(file.path)
//                    setImageViewBitmap(R.id.imageView, bitmap)
//                }
//                appWidgetManager.updateAppWidget(widgetId, views)
//
//            } catch (e: Exception){
//                println(e)
//            }
//        }
//    }


    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->


            try {
                val views = RemoteViews(context.packageName, R.layout.pylons_widget_layout).apply {

                    println("Widget data got")
                    println(widgetData.getString("image", ""))




                    println("Jawad ${Uri.parse(widgetData.getString("image", ""))}")


//                val imageLayout = RemoteViews(context.packageName, R.layout.image_layout);
//                imageLayout.setImageViewUri(R.id.imageView, Uri.parse(widgetData.getString("image", "")))


//                addView(R.id.widget_container, imageLayout)

                    val file = File(widgetData.getString("image", "").toString());

//                    val uri = FileProvider.getUriForFile(context, BuildConfig.APPLICATION_ID + ".provider", file)


                    val bitmap: Bitmap = BitmapFactory.decodeFile(file.path)
//                    setImageViewResource(R.id.imageView, R.drawable.test_image)


                    println(file.exists())

                    setImageViewBitmap(R.id.imageView, bitmap)

//                    setImageViewUri(R.id.imageView, uri)

//                    setImageViewUri(R.id.imageView, Uri.parse(widgetData.getString("image", "")))


//                // Open App on Widget Click
                    val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java
                    )
                    setOnClickPendingIntent(R.id.widget_container, pendingIntent)
//
//                // Swap Title Text by calling Dart Code in the Background
//                setTextViewText(R.id.widget_title, widgetData.getString("title", null)
//                        ?: "No Title Set")
                    val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
                        context,
                        Uri.parse("homeWidgetExample://titleClicked")
                    )
                    setOnClickPendingIntent(R.id.imageView, backgroundIntent)
//
//                val message = widgetData.getString("message", null)
//                setTextViewText(R.id.widget_message, message
//                        ?: "No Message Set")
//                // Detect App opened via Click inside Flutter
//                val pendingIntentWithData = HomeWidgetLaunchIntent.getActivity(
//                        context,
//                        MainActivity::class.java,
//                        Uri.parse("homeWidgetExample://message?message=$message"))
//                setOnClickPendingIntent(R.id.widget_message, pendingIntentWithData)
                }

                appWidgetManager.updateAppWidget(widgetId, views)

            } catch (e: Exception) {
                println(e)
            }
        }
    }


}

