//package tech.pylons.wallet
//
//
//import android.appwidget.AppWidgetManager
//import android.content.Context
//import android.content.Intent
//import android.widget.RemoteViews
//import android.widget.RemoteViewsService
//import android.os.Bundle
//
//
//class PylonsWidgetService : RemoteViewsService() {
//
////    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
////        super.configureFlutterEngine(flutterEngine)
////    }
//
//    //private var flutterEngine = FlutterEngine.
////    val flutterBackgroundController = FlutterBackgroundController(this.applicationContext, AndroidPreferences(this.applicationContext))
////
////    val flutterEngine = flutterBackgroundController.getBackgroundFlutterEngine()
////
////
////    private var collectionsApi: Pigeon.CollectionsApi = Pigeon.CollectionsApi(flutterEngine?.dartExecutor?.binaryMessenger
////        ?: null
////    )
//
//    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
//        return GridRemoteViewsFactory(this.applicationContext, intent)//, collectionsApi)
//    }
//}
//
//class GridRemoteViewsFactory(
//    private val context: Context,
//    intent: Intent,
//    //mAppWidgetId: Int,
//   // private val collectionsApi: Pigeon.CollectionsApi
//) : RemoteViewsService.RemoteViewsFactory {
//    private var mContext = context
//    private var mAppWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID,
//        AppWidgetManager.INVALID_APPWIDGET_ID)
//    private var count: Int = 6
//    private lateinit var widgetItems: List<Int>
//
//    override fun onCreate() {
////        var listening: Pigeon.CollectionsApi? = null
//       //collectionsApi.getCollection(){
////           if (listening == null) {
////               val flutterEngine = flutterBackgroundController.getBackgroundFlutterEngine()
////               if (flutterEngine != null) {
////                   Pigeon.MessageUtils.setup(
////                       flutterEngine.dartExecutor.binaryMessenger)
////                   listening = Pigeon.CollectionsApi(flutterEngine.dartExecutor.binaryMessenger)
////               }
//////           }
////           result -> widgetItems=result
////       }
//        widgetItems = listOf(R.drawable.sunflowers, R.drawable.sunflowers, R.drawable.sunflowers, R.drawable.sunflowers, R.drawable.sunflowers, R.drawable.sunflowers, R.drawable.sunflowers)
//
//    }
//
//    override fun getViewAt(position: Int): RemoteViews {
//
////        return RemoteViews(context.packageName, R.layout.nft_image).apply {
//            //setImageViewUri(R.id.nft, widgetItems[position].toUri())
////            setImageViewResource(R.id.nft, widgetItems[position])
////        }
//
//        // position will always range from 0 to getCount() - 1.
//        // We construct a remote views item based on our widget item xml file, and set the
//        // text based on the position.
//        // position will always range from 0 to getCount() - 1.
//        // We construct a remote views item based on our widget item xml file, and set the
//        // text based on the position.
//        val rv = RemoteViews(mContext.packageName, R.layout.nft_image)
//        //rv.setTextViewText(R.id.widget_item, mWidgetItems.get(position).text)
//        rv.setImageViewResource(R.id.nft, widgetItems[position])
//        // Next, we set a fill-intent which will be used to fill-in the pending intent template
//        // which is set on the collection view in StackWidgetProvider.
//        // Next, we set a fill-intent which will be used to fill-in the pending intent template
//        // which is set on the collection view in StackWidgetProvider.
////        val extras = Bundle()
////        extras.putInt(PylonsWidgetProvider., position)
////        val fillInIntent = Intent()
////        fillInIntent.putExtras(extras)
////        rv.setOnClickFillInIntent(R.id.nft, fillInIntent)
//        // You can do heaving lifting in here, synchronously. For example, if you need to
//        // process an image, fetch something from the network, etc., it is ok to do it here,
//        // synchronously. A loading view will show up in lieu of the actual contents in the
//        // interim.
//        // You can do heaving lifting in here, synchronously. For example, if you need to
//        // process an image, fetch something from the network, etc., it is ok to do it here,
//        // synchronously. A loading view will show up in lieu of the actual contents in the
//        // interim.
//        try {
//            System.out.println("Loading view $position")
//            Thread.sleep(500)
//        } catch (e: InterruptedException) {
//            e.printStackTrace()
//        }
//        // Return the remote views object.
//        // Return the remote views object.
//        return rv
//
//    }
//
//    override fun getLoadingView(): RemoteViews? {
//        return null
//    }
//
//    override fun getViewTypeCount(): Int {
//        return 1
//    }
//
//    override fun getItemId(position: Int): Long {
//        return position.toLong()
//    }
//
//    override fun hasStableIds(): Boolean {
//        return true
//    }
//
//    override fun onDataSetChanged() {
//    }
//
//    override fun onDestroy() {
//    }
//
//    override fun getCount(): Int {
//        return count
//    }
//
//
//// See the RemoteViewsFactory API reference for the full list of methods to
//// implement.
//
//}
