package tech.pylons.easel.ui.createNft

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Matrix
import android.net.Uri
import android.os.Bundle
import android.provider.MediaStore
import android.util.Base64
import android.util.Base64.DEFAULT
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContract
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import com.google.android.material.bottomsheet.BottomSheetDialog
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.MultipartBody
import tech.pylons.easel.R
import tech.pylons.easel.databinding.BottomSheetDialogBinding
import tech.pylons.easel.databinding.FragmentCreateNftLocationBinding
import tech.pylons.easel.service.RetrofitClient
import tech.pylons.easel.service.model.ImgurPicUploadResp
import tech.pylons.easel.ui.UI

import android.os.Build
import android.graphics.BitmapFactory
import android.os.Environment
import androidx.exifinterface.media.ExifInterface
import java.io.*
import java.nio.ByteBuffer
import java.text.SimpleDateFormat
import java.util.*
import android.content.ContentValues
import tech.pylons.droidwallet.WalletHandler

class CreateNftLocationFragment : Fragment() {
    private lateinit var binding: FragmentCreateNftLocationBinding
    private val viewModel: CreateNftViewModel by viewModels(ownerProducer = {
        requireParentFragment()
    })

    //private var uri: Uri? = null
    private var imagePhoto: Bitmap? = null

    companion object {
        var uri: Uri? = null
    }


    private var cameraLauncher = registerForActivityResult(
        TakePictureContract()
    ) { photo ->
       val img = getImage(uri)
        println("Easel Uri: " + uri.toString())
        if(img != null){
            var rot_photo = rotateImageIfRequired(img!!)


            imagePhoto = rot_photo
            binding.imageViewUpload.setImageBitmap(rot_photo)
            if(rot_photo != null){
                viewModel.imageWidth.value = rot_photo.width
                viewModel.imageHeight.value = rot_photo.height
            }

            uploadPhoto(getMultipartBody(rot_photo!!))
        } else {
            Toast.makeText(requireContext(), "Picture not taken.", Toast.LENGTH_SHORT).show()
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = DataBindingUtil.inflate(
            inflater,
            R.layout.fragment_create_nft_location,
            container,
            false
        )
        binding.createViewModel = viewModel
        binding.lifecycleOwner = requireParentFragment()
        binding.locationButtonNext.isEnabled = false

        viewModel.mBtnLocationNextMediator.observe(viewLifecycleOwner, { validationResult ->
            binding.locationButtonNext.isEnabled = validationResult
        })


        binding.imageViewUpload.setOnClickListener {
            uri = genUri()
            println("Easel genuri: " + uri.toString())
            cameraLauncher.launch(uri)
        }

        binding.iconUrlInfo.setOnClickListener {
            val view: BottomSheetDialogBinding = DataBindingUtil.inflate(
                inflater, R.layout.bottom_sheet_dialog, container, false
            )
            view.dialogTitle.text = getString(R.string.nft_url_info_title)
            view.dialogText1.text = getString(R.string.nft_url_info_text)
            view.dialogText2.text = getString(R.string.nft_url_info_guide)
            val dialog = BottomSheetDialog(requireContext())
            dialog.setContentView(view.root)
            dialog.show()
        }

        binding.btnRefresh.visibility = View.INVISIBLE

        binding.btnRefresh.setOnClickListener {
            if (imagePhoto != null) {
                uploadPhoto(getMultipartBody(imagePhoto!!))
            }
        }

        enableControls(false)
        val userCookbook = WalletHandler.getLiveUserCookbook().value
        WalletHandler.listCookbooks(requireContext()){
            when(it){
                null -> {
                    CoroutineScope(Dispatchers.IO).launch {
                        withContext(Dispatchers.Main){
                            callCreateAutoCookbook()
                        }
                    }
                }
            }
        }

        //this called twice from second run
        WalletHandler.getLiveUserCookbook().observe(viewLifecycleOwner) { cookbook ->
            when (cookbook) {
                null -> {
                    enableControls(false)
                }
                else -> {
                    enableControls(true)
                }
            }
        }

        return binding.root
    }

    override fun onDestroyView() {
        super.onDestroyView()
        WalletHandler.getLiveUserCookbook().removeObserver {

        }
    }


    private fun enableControls(enable: Boolean) {
        when (enable) {
            false -> {
                binding.iconUrlInfo.isEnabled = false
                binding.btnRefresh.isEnabled = false
                binding.imageViewUpload.isEnabled = false
                binding.nftUrl.isEnabled = false
            }
            true -> {
                binding.iconUrlInfo.isEnabled = true
                binding.btnRefresh.isEnabled = true
                binding.imageViewUpload.isEnabled = true
                binding.nftUrl.isEnabled = true
            }
        }

    }

    private fun callCreateAutoCookbook() {
        val loading = UI.displayLoading(requireContext(), "Check your notifications.\nCreating AutoCookbook ...")

        CoroutineScope(Dispatchers.IO).launch {
            WalletHandler.createAutoCookbook(
                requireContext(),
                WalletHandler.getUserProfile()
            ) { ret ->
                CoroutineScope(Dispatchers.IO).launch {
                    loading.dismiss()
                    when (ret) {
                        true -> {
                            //cookbook created
                            WalletHandler.listCookbooks(requireContext())
                        }
                        false -> {
                            withContext(Dispatchers.Main) {
                                //cookbook creation failed
                                UI.displayConfirm(requireContext(),
                                    "Insufficient pylons to create a Portfolio.\r\nWill you retry Portfolio Creation?",
                                    callbackOK = {
                                        callCreateAutoCookbook()
                                    },
                                    callbackCancel = {

                                    }
                                )
                            }
                        }
                    }
                }
            }
        }

    }


    private fun uploadPhoto(imagePart: MultipartBody.Part) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                // Execute web request through coroutine call adapter & retrofit
                val apiResponse =
                    RetrofitClient.imgurApi.uploadImageToImgur(imagePart).await()
                if (apiResponse.isSuccessful) {
                    val url: ImgurPicUploadResp? = apiResponse.body()
                    if (url != null) {
                        Log.d(tag, url.toString())
                        // Imgur API generated picture link
                        withContext(Dispatchers.Main){
                            binding.nftUrl.setText(url.upload.link)
                        }
                    }
                } else {
                    Log.e(tag, "Error $apiResponse")
                    withContext(Dispatchers.Main){
                        Toast.makeText(
                            requireContext(),
                            "Error, please try again",
                            Toast.LENGTH_LONG
                        ).show()

                        binding.btnRefresh.visibility = View.VISIBLE
                    }
                }
            } catch (e: IOException) {
                Log.e(tag, "Exception " + e.printStackTrace())
                withContext(Dispatchers.Main) {
                    Toast.makeText(requireContext(), "Exception ${e.message}", Toast.LENGTH_LONG)
                        .show()
                }
            }
        }
    }

    //TODO move to a util package
    private fun getMultipartBody(bmp: Bitmap): MultipartBody.Part {
        val baos = ByteArrayOutputStream()
        bmp.compress(Bitmap.CompressFormat.JPEG, 100, baos)
        val byteImage = baos.toByteArray()
        val dataImage: String = Base64.encodeToString(byteImage, DEFAULT)
        return MultipartBody.Part.createFormData("image", dataImage)
    }

    fun getImage(uri:Uri?): Bitmap?{
        val MAX_HEIGHT = 1024
        val MAX_WIDTH = 1024
        if(uri == null) {
            return null
        }

        println("Easel URI: " + uri.toString())

        // First decode with inJustDecodeBounds=true to check dimensions

        // First decode with inJustDecodeBounds=true to check dimensions
        val options = BitmapFactory.Options()
        options.inJustDecodeBounds = true
        var imageStream = requireContext().contentResolver.openInputStream(uri!!)
        BitmapFactory.decodeStream(imageStream, null, options)
        imageStream!!.close()

        // Calculate inSampleSize

        // Calculate inSampleSize
        options.inSampleSize = calculateInSampleSize(options, MAX_WIDTH, MAX_HEIGHT)

        // Decode bitmap with inSampleSize set

        // Decode bitmap with inSampleSize set
        options.inJustDecodeBounds = false
        imageStream = requireContext().contentResolver.openInputStream(uri!!)
        val img = BitmapFactory.decodeStream(imageStream, null, options)
        return img
    }

    fun getExifInterface(context: Context, uri: Uri): ExifInterface? {
        try {
            val path = uri.toString()
            if (path.startsWith("file:/")) {

                val _path = uri.getEncodedPath()
                return ExifInterface(_path!!)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                if (path.startsWith("content:/")) {
                    val inputStream = context.contentResolver.openInputStream(uri)
                    return ExifInterface(inputStream!!)
                }
            }
        } catch (e: IOException) {
            e.printStackTrace()
        }
        return null
    }


    private fun rotateImage(img: Bitmap, degree: Float): Bitmap? {
        val matrix = Matrix()
        matrix.postRotate(degree)
        val rotatedImg = Bitmap.createBitmap(img, 0, 0, img.width, img.height, matrix, true)
        img.recycle()
        return rotatedImg
    }

    /**
     * Calculate an inSampleSize for use in a [BitmapFactory.Options] object when decoding
     * bitmaps using the decode* methods from [BitmapFactory]. This implementation calculates
     * the closest inSampleSize that will result in the final decoded bitmap having a width and
     * height equal to or larger than the requested width and height. This implementation does not
     * ensure a power of 2 is returned for inSampleSize which can be faster when decoding but
     * results in a larger bitmap which isn't as useful for caching purposes.
     *
     * @param options   An options object with out* params already populated (run through a decode*
     * method with inJustDecodeBounds==true
     * @param reqWidth  The requested width of the resulting bitmap
     * @param reqHeight The requested height of the resulting bitmap
     * @return The value to be used for inSampleSize
     */
    private fun calculateInSampleSize(
        options: BitmapFactory.Options,
        reqWidth: Int, reqHeight: Int
    ): Int {
        // Raw height and width of image
        val height = options.outHeight
        val width = options.outWidth
        var inSampleSize = 1
        if (height > reqHeight || width > reqWidth) {

            // Calculate ratios of height and width to requested height and width
            val heightRatio = Math.round(height.toFloat() / reqHeight.toFloat())
            val widthRatio = Math.round(width.toFloat() / reqWidth.toFloat())

            // Choose the smallest ratio as inSampleSize value, this will guarantee a final image
            // with both dimensions larger than or equal to the requested height and width.
            inSampleSize = if (heightRatio < widthRatio) heightRatio else widthRatio

            // This offers some additional logic in case the image has a strange
            // aspect ratio. For example, a panorama may have a much larger
            // width than height. In these cases the total pixels might still
            // end up being too large to fit comfortably in memory, so we should
            // be more aggressive with sample down the image (=larger inSampleSize).
            val totalPixels = (width * height).toFloat()

            // Anything more than 2x the requested pixels we'll sample down further
            val totalReqPixelsCap = (reqWidth * reqHeight * 2).toFloat()
            while (totalPixels / (inSampleSize * inSampleSize) > totalReqPixelsCap) {
                inSampleSize++
            }
        }
        return inSampleSize
    }

    /**
     * Rotate an image if required.
     *
     * @param img           The image bitmap
     * @param selectedImage Image URI
     * @return The resulted Bitmap after manipulation
     */

    private fun rotateImageIfRequired(img: Bitmap): Bitmap? {

        val byteSize = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            img.allocationByteCount
        } else {
            img.byteCount
        }
        val byteBuffer: ByteBuffer = ByteBuffer.allocate(byteSize)
        img.copyPixelsToBuffer(byteBuffer)
        val byteArray: ByteArray = byteBuffer.array()

        val bs = ByteArrayInputStream(byteArray)
        val ei = getExifInterface(requireContext(), uri!!)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            //val ei = ExifInterface(uri?.path.toString())
            val orientation: Int =
                ei?.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL)!!

            println("orienttation: ${orientation}")
            return when (orientation) {
                ExifInterface.ORIENTATION_ROTATE_90 -> rotateImage(img, 90.0f)
                ExifInterface.ORIENTATION_ROTATE_180 -> rotateImage(img, 180.0f)
                ExifInterface.ORIENTATION_ROTATE_270 -> rotateImage(img, 270.0f)
                else -> img
            }
        }

        return img

    }

    private fun genUri(): Uri? {
        val timeStamp: String = SimpleDateFormat("yyyyMMdd_HHmmss").format(Date())
        val filename = "image_${timeStamp}.jpg"

        var uri: Uri? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val values = ContentValues()
            values.put(MediaStore.Images.Media.DISPLAY_NAME, filename)
            values.put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
            values.put(MediaStore.Images.Media.RELATIVE_PATH, Environment.DIRECTORY_PICTURES)
            requireContext().contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)!!
        } else {
            val imagesDir =
                Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
                    .toString()
            val image = File(imagesDir, filename)
            Uri.fromFile(image)
        }
        return uri
    }

    class TakePictureContract() : ActivityResultContract<Uri?, Bitmap?>() {

        override fun createIntent(context: Context, input: Uri?): Intent {
            //var i = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
            var i = Intent(MediaStore.ACTION_IMAGE_CAPTURE_SECURE )
            i.putExtra(MediaStore.EXTRA_OUTPUT, input)
            return i

        }

        override fun parseResult(resultCode: Int, result: Intent?): Bitmap? {
            return if (resultCode != Activity.RESULT_OK || result == null || !result.hasExtra("data")) {
                null
            } else result.extras!!.get("data") as Bitmap
        }
    }

}
