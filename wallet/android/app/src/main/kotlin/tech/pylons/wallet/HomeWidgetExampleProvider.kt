package tech.pylons.wallet

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.os.Build
import android.widget.RemoteViews
import androidx.annotation.RequiresApi
import androidx.core.net.toUri
import com.bumptech.glide.Glide
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider


class HomeWidgetExampleProvider : HomeWidgetProvider() {

//    //@Throws(FileNotFoundException::class, IOException::class)
//    fun getThumbnail(uri: Uri?, context: Context): Bitmap? {
//        var input: InputStream = uri?.let { context.getContentResolver().openInputStream(it) }!!
//        val onlyBoundsOptions: BitmapFactory.Options = BitmapFactory.Options()
//        onlyBoundsOptions.inJustDecodeBounds = true
//        onlyBoundsOptions.inDither = true //optional
//        onlyBoundsOptions.inPreferredConfig = Bitmap.Config.ARGB_8888 //optional
//        BitmapFactory.decodeStream(input, null, onlyBoundsOptions)
//        input.close()
//        if (onlyBoundsOptions.outWidth === -1 || onlyBoundsOptions.outHeight === -1) {
//            return null
//        }
//        val originalSize: Int =
//            if (onlyBoundsOptions.outHeight > onlyBoundsOptions.outWidth) onlyBoundsOptions.outHeight else onlyBoundsOptions.outWidth
//        val ratio = 1.0//if (originalSize > THUMBNAIL_SIZE) originalSize / THUMBNAIL_SIZE else 1.0
//        val bitmapOptions: BitmapFactory.Options = BitmapFactory.Options()
//        bitmapOptions.inSampleSize = getPowerOfTwoForSampleRatio(ratio)
//        bitmapOptions.inDither = true //optional
//        bitmapOptions.inPreferredConfig = Bitmap.Config.ARGB_8888 //
//        input = uri?.let { context.getContentResolver().openInputStream(it) }!!
//        val bitmap: Bitmap = BitmapFactory.decodeStream(input, null, bitmapOptions)!!
//        input.close()
//        return bitmap
//    }
//
//    private fun getPowerOfTwoForSampleRatio(ratio: Double): Int {
//        val k = Integer.highestOneBit(Math.floor(ratio).toInt())
//        return if (k == 0) 1 else k
//    }

    //@RequiresApi(Build.VERSION_CODES.P)
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->


            try {
                val views = RemoteViews(context.packageName, R.layout.example_layout).apply {

//                    println("Widget data got")
//                    println(widgetData.getString("image", ""))
//
//
//
//
//                    println("Jawad ${Uri.parse(widgetData.getString("image", ""))}")
//
//
//
//
//                    val file = File(widgetData.getString("image", "").toString());
//
//
//
//                    val bitmap: Bitmap = BitmapFactory.decodeFile(file.path)
//
//
//
//                    println(file.exists())
                    //val bitmap: Bitmap = BitmapFactory.decodeResource()
//
//                    setImageViewBitmap(R.id.imageView, bitmap)


//                    val bitmap: Bitmap =
//                        MediaStore.Images.Media.getBitmap(context.getContentResolver(), widgetData.getString("image", "")?.toUri() ?: null)
                   // val bitmap = getThumbnail( widgetData.getString("image", "")?.toUri() ?: null, context);
//                    val bitmap = ImageDecoder.decodeBitmap(ImageDecoder.createSource(context.contentResolver,
//                        (widgetData.getString("image", "")?.toUri() ?: null)!!
//                    ))
//                    setImageViewBitmap(R.id.imageView, bitmap)

                    println("hello");




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
                    //setImageViewResource(R.id.imageView, R.drawable.redditart)

                    //println("android got uri ${widgetData.getString("image", "")?.toUri()}");
//                    println("android got data ${widgetData.contains("image")}");
//                    val byteBuffer = widgetData.getAll()["image"]
//                    val bitmap = ImageDecoder.decodeBitmap(ImageDecoder.createSource(byteBuffer))
//                    setImageViewUri(R.id.imageView, Uri.parse(""));
//                    setImageViewUri(R.id.imageView, widgetData.getString("image", "")?.toUri() ?: null);
//                    val source = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
//                        ImageDecoder.createSource(context.contentResolver,
//                            (widgetData.getString("image", "")?.toUri() ?: null)!!
//                        )
//                    } else {
//                        MediaStore.Images.Media.getBitmap(context.contentResolver, (widgetData.getString("image", "")?.toUri() ?: null)!!)
//                    }
//                    println("source $source")
//                    val bitmap = ImageDecoder.decodeBitmap(source as ImageDecoder.Source);
//                    val bitmap = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
//                        print("high version")
//                        ImageDecoder.decodeBitmap(ImageDecoder.createSource(context.contentResolver., (widgetData.getString("image", "")?.toUri() ?: null)!!))
//                    } else {
//                        print("low version")
//                        MediaStore.Images.Media.getBitmap(context.contentResolver, (widgetData.getString("image", "")?.toUri() ?: null)!!)
//                    }
//                    println("android got uri ${widgetData.getString("image", "")?.toUri()}");
//                    val contentResolver = context.contentResolver
//                    println("content resolver $contentResolver")
//                    val stream = contentResolver.openInputStream((widgetData.getString("image", "")?.toUri() ?: null)!!)
//                    println("stream $stream")
//                    val bitmap = BitmapFactory.decodeStream(stream)
//
//                    println("bitamp $bitmap");
//                    setImageViewBitmap(R.id.imageView, bitmap)
//                    println("after image view set")


//                    val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
//                            context,
//                            Uri.parse("homeWidgetExample://widgetClicked")
//                    )
//                    setOnClickPendingIntent(R.id.imageView, backgroundIntent)

                }

                appWidgetManager.updateAppWidget(widgetId, views)

            } catch (e: Exception){
                println(e)
            }
        }
    }
}