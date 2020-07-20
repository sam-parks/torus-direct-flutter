package org.torusresearch.torusdirectandroid;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import androidx.annotation.Nullable;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import androidx.browser.customtabs.CustomTabsClient;
import androidx.browser.customtabs.CustomTabsIntent;

import org.torusresearch.torusdirect.TorusDirectSdk;
import org.torusresearch.torusdirect.types.DirectSdkArgs;

public class MainActivity extends FlutterActivity {
    private static final Uri LAUNCH_URI =
            Uri.parse("https://google.com");
    private String providerName;
    private static final String CHANNEL = "torus.flutter.dev/direct-sdk";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
      new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
          .setMethodCallHandler(
            (call, result) -> {
        
            if (call.method.equals("triggerLogin")){
              DirectSdkArgs args = new DirectSdkArgs(call.argument("redirectUri"));
              args.setGoogleClientId(call.argument("googleClientId"));
              TorusDirectSdk sdk = new TorusDirectSdk(this, args);
              Intent intent = sdk.triggerLogin("google", "google");
              startActivityForResult(intent, 200);
              result.success();
            }
            }
          );
    }

    
/* 
    public void launch(View view) {
//        CustomTabsIntent intent = new CustomTabsIntent.Builder().build();
//        intent.intent.setPackage(providerName);
//        intent.intent.setData(LAUNCH_URI);
//        Log.d("result:torus", "Starting activity");
//        startActivityForResult(intent.intent, 200);
//        Log.d("result:torus", "Started activity");
        DirectSdkArgs args = new DirectSdkArgs("https://app.tor.us/redirect");
        args.setGoogleClientId("876733105116-i0hj3s53qiio5k95prpfmj0hp0gmgtor.apps.googleusercontent.com");
        TorusDirectSdk sdk = new TorusDirectSdk(this, args);
        Intent intent = sdk.triggerLogin("google", "google");
        startActivityForResult(intent, 200);
    } */
}