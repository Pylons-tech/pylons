package tech.pylons.easel.ui.dashboard

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import tech.pylons.droidwallet.WalletHandler
import tech.pylons.lib.types.tx.recipe.*

class DashboardViewModel : ViewModel() {
    val createdNfts: LiveData<MutableList<Recipe>>

    init {
        createdNfts = MutableLiveData()
        createdNfts.value = WalletHandler.getUserNfts()
    }
}