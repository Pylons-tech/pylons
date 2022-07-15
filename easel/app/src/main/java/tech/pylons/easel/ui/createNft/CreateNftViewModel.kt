package tech.pylons.easel.ui.createNft

import android.app.Application
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MediatorLiveData
import androidx.lifecycle.MutableLiveData
import tech.pylons.lib.types.Profile
import java.io.IOException
import java.net.URL

class CreateNftViewModel(application: Application) : AndroidViewModel(application) {

    private var _item = MutableLiveData(0)
    val item: LiveData<Int>
        get() = _item

    private var _swipeEnabled = MutableLiveData(false)
    val swipeEnabled: LiveData<Boolean>
        get() = _swipeEnabled

    val nftUrl = MutableLiveData<String>()
    val nftName = MutableLiveData<String>()
    val nftDescription = MutableLiveData<String>()
    val nftQty = MutableLiveData<String>()
    val nftPrice = MutableLiveData<String>()
    val nftCurrency = MutableLiveData<Int>()
    val nftRoyalty = MutableLiveData<String>()
    val imageWidth = MutableLiveData<Int>()
    val imageHeight = MutableLiveData<Int>()

    val CreateNftResult = MutableLiveData<Boolean>()

    val mBtnLocationNextMediator = MediatorLiveData<Boolean>()
    val mBtnNextMediator = MediatorLiveData<Boolean>()
    val mBtnCreateMediator = MediatorLiveData<Boolean>()


    val userProfile = MutableLiveData<Profile?>()

    init {
        mBtnLocationNextMediator.addSource(nftUrl) { validateLocationBtnNext() }
        mBtnNextMediator.addSource(nftName) { validateBtnNext() }
        mBtnNextMediator.addSource(nftUrl) { validateBtnNext() }
        mBtnNextMediator.addSource(nftDescription) { validateBtnNext() }
        mBtnCreateMediator.addSource(nftQty) { validateBtnCreate() }
        mBtnCreateMediator.addSource(nftPrice) { validateBtnCreate() }
        mBtnCreateMediator.addSource(nftCurrency) {validateBtnCreate() }
        mBtnCreateMediator.addSource(nftRoyalty) { validateBtnCreate() }
    }

    private fun validateLocationBtnNext() {
        mBtnLocationNextMediator.value = !(nftUrl.value.isNullOrEmpty())
    }

    private fun validateBtnNext() {
        var descriptionValid : Boolean = (!(nftDescription.value.isNullOrEmpty()) && nftDescription.value?.length!! > 20)
        mBtnNextMediator.value = !(nftName.value.isNullOrEmpty()) && (descriptionValid)
    }

    private fun validateBtnCreate() {
        mBtnCreateMediator.value = !(nftQty.value.isNullOrEmpty()) && !(nftPrice.value.isNullOrEmpty()) && !(nftRoyalty.value.isNullOrEmpty())
    }

    private fun validateCookbook() {

    }

    fun onNftUrlChanged(editable: android.text.Editable){
    }

    override fun onCleared() {
        mBtnLocationNextMediator.removeSource(nftUrl)
        mBtnNextMediator.removeSource(nftName)
        mBtnNextMediator.removeSource(nftDescription)
        mBtnCreateMediator.removeSource(nftQty)
        mBtnCreateMediator.removeSource(nftPrice)
        mBtnCreateMediator.removeSource(nftCurrency)
        mBtnCreateMediator.removeSource(nftRoyalty)
    }

    fun onNext(page: Int){
        _item.value = page + 1
        _swipeEnabled.value = true
    }

//    fun onCreateNft(){
//        WalletNftService().createNft(
//            context = getApplication(),
//            name= nftName.value.toString(),
//            price = nftPrice.value.toString(),
//            royalty = nftRoyalty.value.toString(),
//            quantity = nftQty.value!!.toLong(),
//            url = nftUrl.value.toString(),
//            description = nftDescription.value.toString()
//        )
//       // clear()
//    }

//    private fun clear(){
//        nftName.value = ""
//        nftPrice.value = ""
//        nftRoyalty.value = ""
//        nftQty.value = ""
//        nftUrl.value = ""
//        nftDescription.value = ""
//    }
}
