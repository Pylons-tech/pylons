package tech.pylons.easel

import android.content.Context
import android.util.Log
import android.widget.Toast
import androidx.startup.Initializer
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import tech.pylons.droidwallet.WalletHandler
import tech.pylons.lib.Wallet

class WalletInitializer : Initializer<Wallet>, WalletHandler.WalletCallback {

    lateinit var mContext: Context

    override fun onWalletConnectFailed() {
        Toast.makeText(mContext, "Failed to connect Wallet app.", Toast.LENGTH_SHORT).show()
    }

    override fun onWalletConnected() {
        CoroutineScope(Dispatchers.IO).launch {
            if (WalletHandler.getUserProfile() == null) {
                //testCreateNft(context)
                WalletHandler.fetchProfile(mContext, null) {
                    when (it) {
                        true -> {
                            //retrieved profile
                            Log.d("Easel", "profile fetched!")
                        }
                        false -> {
                            //no profile
                            Log.d("Easel", "No profile")
                        }
                    }
                }

            }
        }
    }

    override fun create(context: Context): Wallet {
        mContext = context
        WalletHandler.setup(context, BuildConfig.APPLICATION_ID, BuildConfig.APP_NAME, this)
        return WalletHandler.getWallet()
    }

    override fun dependencies(): List<Class<out Initializer<*>>> {
        return emptyList()
    }
}