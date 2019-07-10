package com.solutelabs.flutter_plugin

import android.app.Activity
import android.widget.Toast
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class FlutterPlugin() : MethodCallHandler {
    var activity: Activity? = null
    var channel: MethodChannel? = null

    constructor(activity: Activity, channel: MethodChannel) : this() {
        this.activity = activity
        this.channel = channel
        this.channel?.setMethodCallHandler(this)
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutter_plugin")
            channel.setMethodCallHandler(FlutterPlugin(registrar.activity(), channel))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Your Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }
}
