package com.mythichelm.gametime

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

import com.mythichelm.localnotifications.LocalNotificationsPlugin
import android.content.Intent


class MainActivity(): FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this);
  }

  override protected fun onNewIntent(intent: Intent) {
    LocalNotificationsPlugin.handleIntent(intent) // Add me for callbacks
  }
}
