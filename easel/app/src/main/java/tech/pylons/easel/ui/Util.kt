package tech.pylons.easel.ui

import android.app.NotificationChannel
import android.content.Context
import androidx.appcompat.app.AlertDialog
import tech.pylons.easel.R


object UI {

    fun displayLoading(context: Context, message: String): AlertDialog {
        with(context) {
            val dialogBuilder =
                AlertDialog.Builder(this)
            dialogBuilder.setMessage(
                message
            )
                .setCancelable(false)
                .setView(R.layout.view_loading)
            val alert = dialogBuilder.create()

            alert.show()

            return alert
        }
    }

    fun displayMessage(
        context: Context,
        message: String,
        callbackOK: (() -> Unit)? = null
    ): AlertDialog {
        with(context) {
            val dialogBuilder =
                AlertDialog.Builder(this)
            dialogBuilder.setMessage(
                message
            )
                .setCancelable(false)
                .setPositiveButton("OK") { _, _ ->
                    if (callbackOK != null)
                        callbackOK?.invoke()
                }
            val alert = dialogBuilder.create()
            alert.show()

            return alert
        }
    }

    fun displayConfirm(
        context: Context,
        message: String,
        callbackOK: (() -> Unit)?,
        callbackCancel:(() -> Unit)?
    ): AlertDialog {
        with(context) {
            val dialogBuilder =
                AlertDialog.Builder(this)
            dialogBuilder.setMessage(
                message
            )
                .setCancelable(false)
                .setPositiveButton("OK") { _, _ ->
                    if (callbackOK != null)
                        callbackOK?.invoke()
                }.setNegativeButton("CANCEL") {_,_->
                    if (callbackCancel != null)
                        callbackCancel?.invoke()
                }
            val alert = dialogBuilder.create()
            alert.show()

            return alert
        }
    }
}