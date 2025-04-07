package com.example.ewasteforme

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.google.firebase.FirebaseApp

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        FirebaseApp.initializeApp(this) // Ensure Firebase is initialized
    }
}
