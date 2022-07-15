package tech.pylons.easel.ui.splash_screen

import android.content.Intent
import android.os.Build
import android.os.Bundle
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import tech.pylons.droidwallet.WalletHandler
import tech.pylons.easel.MainActivity
import tech.pylons.easel.R
//import tech.pylons.ipc.WalletHandler

class SplashScreen : AppCompatActivity() {

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash_screen)

        //Initialize WalletInitializer after this activity has been created
        WalletHandler.getLiveUserProfile().observe(this) {
            if (it != null) {
                val intent = Intent(this, MainActivity::class.java)
                startActivity(intent)
                finish()
            }
        }
    }

}