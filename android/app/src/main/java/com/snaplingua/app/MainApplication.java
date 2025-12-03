package com.snaplingua.app;

import android.util.Log;

import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;

import io.flutter.app.FlutterApplication;

/**
 * Initializes the Facebook SDK early so plugin registration in background isolates succeeds.
 */
public class MainApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        try {
            FacebookSdk.sdkInitialize(getApplicationContext());
            FacebookSdk.setAutoInitEnabled(true);
            FacebookSdk.fullyInitialize();
            AppEventsLogger.activateApp(this);
        } catch (Exception e) {
            Log.e("MainApplication", "Failed to initialize Facebook SDK", e);
        }
    }
}
