package com.example.silentguard

import android.content.Context
import android.media.AudioManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "silentguard/sound"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager

            when (call.method) {
                "setSilentMode" -> {
                    try {
                        audioManager.ringerMode = AudioManager.RINGER_MODE_SILENT
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("SILENT_ERROR", e.message, null)
                    }
                }
                "setVibrateMode" -> {
                    try {
                        audioManager.ringerMode = AudioManager.RINGER_MODE_VIBRATE
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("VIBRATE_ERROR", e.message, null)
                    }
                }
                "setNormalMode" -> {
                    try {
                        audioManager.ringerMode = AudioManager.RINGER_MODE_NORMAL
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("NORMAL_ERROR", e.message, null)
                    }
                }
                "getCurrentMode" -> {
                    try {
                        val mode = when (audioManager.ringerMode) {
                            AudioManager.RINGER_MODE_SILENT -> "silent"
                            AudioManager.RINGER_MODE_VIBRATE -> "vibrate"
                            AudioManager.RINGER_MODE_NORMAL -> "normal"
                            else -> "unknown"
                        }
                        result.success(mode)
                    } catch (e: Exception) {
                        result.error("GET_MODE_ERROR", e.message, null)
                    }
                }
                "checkDndPermission" -> {
                    val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as android.app.NotificationManager
                    result.success(notificationManager.isNotificationPolicyAccessGranted)
                }
                "openDndSettings" -> {
                    val intent = android.content.Intent(android.provider.Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
                    startActivity(intent)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }
}
