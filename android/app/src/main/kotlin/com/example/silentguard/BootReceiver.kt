package com.example.silentguard

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/**
 * BootReceiver - Restarts background schedule checking after device reboot.
 * Registered in AndroidManifest.xml for BOOT_COMPLETED action.
 */
class BootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED ||
            intent.action == Intent.ACTION_MY_PACKAGE_REPLACED ||
            intent.action == "android.intent.action.QUICKBOOT_POWERON") {

            // Workmanager will be re-initialized by Flutter when app starts
            // This receiver ensures the app is aware of boot for future scheduling
            // The actual WorkManager tasks are registered from Flutter side
        }
    }
}
