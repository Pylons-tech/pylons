package tech.pylons.easel.service.model

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class ImgurPicUploadResp(
    @Json(name = "data")
    val upload: Upload,
    @Json(name = "status")
    val status: Int,
    @Json(name = "success")
    val success: Boolean
)

@JsonClass(generateAdapter = true)
data class Upload(
    @Json(name = "link")
    val link: String
)