package com.sys.escouniv;

import android.os.Bundle;

import com.facebook.FacebookSdk;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    FacebookSdk.sdkInitialize(getApplicationContext());
    super.onCreate(savedInstanceState);
   // FacebookSdk.sdkInitialize(this);
    GeneratedPluginRegistrant.registerWith(this);
  }
}
