package com.honsoncooky.flat_on_fire

import androidx.annotation.NonNull
import com.google.firebase.appcheck.FirebaseAppCheck
import com.google.firebase.appcheck.debug.DebugAppCheckProviderFactory
import com.google.firebase.appcheck.safetynet.SafetyNetAppCheckProviderFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "honsoncooky.flutter.dev/appcheck"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {

        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                val firebaseAppCheck = FirebaseAppCheck.getInstance()
                when (call.method) {
                    "installDebug" -> {
                        firebaseAppCheck.installAppCheckProviderFactory(
                            DebugAppCheckProviderFactory.getInstance()
                        )
                        result.success(1)
                    }
                    "installRelease" -> {
                        firebaseAppCheck.installAppCheckProviderFactory(
                            SafetyNetAppCheckProviderFactory.getInstance()
                        )
                        result.success(1)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }
}
