package com.solutelabs.flutter_plugin

import android.app.Activity
import android.content.ContentValues
import android.database.Cursor
import android.net.Uri
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.reactivex.Observable
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.schedulers.Schedulers

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
        when {
            call.method == "getContent" -> {
                val uri = call.argument<String>("uri")
                val projection = call.argument<Array<String>>("arguments")
                val selection = call.argument<String>("selection")
                val selectionArguments = call.argument<Array<String>>("selectionArguments")
                val sortOrder = call.argument<String>("sortOrder")
                var query: Cursor? = null
                Observable.fromCallable {
                    query = activity?.contentResolver?.query(Uri.parse(uri), projection, selection, selectionArguments, sortOrder)
                    query
                }.subscribeOn(Schedulers.newThread())
                        .observeOn(AndroidSchedulers.mainThread())
                        .subscribe({
                            result.success(it)
                            query?.close()
                        }, {
                            it.printStackTrace()
                            query?.close()
                        })
            }

            call.method == "insertContent" -> {
                val uri = call.argument<String>("uri")
                Observable.fromCallable {
                    activity?.contentResolver?.insert(Uri.parse(uri), getContentValues(call, result))
                }.subscribeOn(Schedulers.newThread())
                        .observeOn(AndroidSchedulers.mainThread())
                        .subscribe({
                            result.success(it)
                        }, {
                            it.printStackTrace()
                        })

            }

            call.method == "updateContent" -> {
                val uri = call.argument<String>("uri")
                val where = call.argument<String>("where")
                val whereArgs = call.argument<Array<String>>("whereArgs")

                Observable.fromCallable {
                    activity?.contentResolver?.update(Uri.parse(uri), getContentValues(call, result), where, whereArgs)
                }.subscribeOn(Schedulers.newThread())
                        .observeOn(AndroidSchedulers.mainThread())
                        .subscribe({
                            result.success(it)
                        }, {
                            it.printStackTrace()
                        })
            }

            call.method == "deleteContent" -> {
                val uri = call.argument<String>("uri")
                val where = call.argument<String>("where")
                val selectionArgs = call.argument<Array<String>>("selectionArgs")
                Observable.fromCallable {
                    activity?.contentResolver?.delete(Uri.parse(uri), where, selectionArgs)
                }.subscribeOn(Schedulers.newThread())
                        .observeOn(AndroidSchedulers.mainThread())
                        .subscribe({
                            result.success(it)
                        }, {
                            it.printStackTrace()
                        })
            }
            else -> result.notImplemented()
        }
    }

    private fun getContentValues(call: MethodCall, result: Result): ContentValues {
        val values = call.argument<HashMap<String, Any>>("contentValues")
        val contentValues = ContentValues()

        values?.forEach {
            val value = it.value
            when (value) {
                is String -> contentValues.put(it.key, value)
                is Byte -> contentValues.put(it.key, value)
                is Short -> contentValues.put(it.key, value)
                is Int -> contentValues.put(it.key, value)
                is Long -> contentValues.put(it.key, value)
                is Float -> contentValues.put(it.key, value)
                is Double -> contentValues.put(it.key, value)
                is Boolean -> contentValues.put(it.key, value)
                is ByteArray -> contentValues.put(it.key, value)
                else -> result.error("unknown type", "", "")
            }
        }
        return contentValues
    }

}
