package tech.pylons.easel.service

import kotlinx.coroutines.Deferred
import okhttp3.MultipartBody
import retrofit2.Response
import retrofit2.http.*
import tech.pylons.easel.BuildConfig

import tech.pylons.easel.service.model.ImgurPicUploadResp
import java.util.*

interface ImgurApiClient {
    @Headers(
        "Authorization: Client-ID " + BuildConfig.IMGUR_CLIENT_ID
    )
    @Multipart
    @POST("/3/image")
        fun uploadImageToImgur(
            @Part image: MultipartBody.Part
    ): Deferred<Response<ImgurPicUploadResp>>
}

