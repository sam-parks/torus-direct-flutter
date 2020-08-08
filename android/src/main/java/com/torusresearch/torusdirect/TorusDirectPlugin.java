package com.torusresearch.torusdirect;

import android.app.Activity;
import android.util.Log;

import android.content.Context;
import androidx.annotation.NonNull;
import java.util.HashMap;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

import com.torusresearch.torusdirect.TorusDirectSdk;
import com.torusresearch.torusdirect.types.LoginType;
import com.torusresearch.torusdirect.types.SubVerifierDetails;
import com.torusresearch.torusdirect.types.Auth0ClientOptions;
import com.torusresearch.torusdirect.types.TorusLoginResponse;
import com.torusresearch.torusdirect.types.DirectSdkArgs;
import com.torusresearch.torusdirect.types.TorusNetwork;

import java8.util.concurrent.CompletableFuture;
import android.content.Context;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executors;

/** TorusDirect */
public class TorusDirectPlugin implements FlutterPlugin, MethodCallHandler,  ActivityAware  {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private Context context;
  private Activity activity;
  private MethodChannel channel;
  private TorusDirectSdk torusDirectSDK;
  private SubVerifierDetails subVerifierDetails;

  public void  onDetachedFromActivity() {

  }

  public void  onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {

  }

  public void onAttachedToActivity(ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  public void onDetachedFromActivityForConfigChanges() {

  }


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "torus.flutter.dev/torus-direct");
    this.context = flutterPluginBinding.getApplicationContext();
    channel.setMethodCallHandler(this);
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "torus.flutter.dev/torus-direct");

    channel.setMethodCallHandler(new TorusDirectPlugin());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "setVerifierDetails": 
          System.out.println(call.arguments);
        HashMap<String, String> args = (HashMap<String, String> ) call.arguments;
          String verifierTypeString  =  args.get("verifierType");
          String loginProviderString =  args.get("loginProvider");
          String clientId   =  args.get("clientId");
          String verifierName   = args.get("verifierName");
          String redirectURL  =  args.get("redirectURL");

        Log.d(TorusDirectPlugin.class.getSimpleName(), "Verifier Type: " + verifierTypeString);


          this.subVerifierDetails = new SubVerifierDetails(
                  LoginType.valueOf(loginProviderString.toUpperCase()),
                                                  clientId,
                  verifierName,
                  new Auth0ClientOptions.Auth0ClientOptionsBuilder("").build());

        DirectSdkArgs directSdkArgs = new DirectSdkArgs(redirectURL, TorusNetwork.TESTNET, "0x4023d2a0D330bF11426B12C6144Cfb96B7fa6183");
          this.torusDirectSDK  = new TorusDirectSdk(directSdkArgs, this.context);


      case "triggerLogin":
        try{
          CompletableFuture<TorusLoginResponse> torusLoginResponseCompletableFuture =  this.torusDirectSDK.triggerLogin(this.subVerifierDetails);
          TorusLoginResponse torusLoginResponse = torusLoginResponseCompletableFuture.get();
          Log.d(TorusDirectPlugin.class.getSimpleName(), "Private Key: " + torusLoginResponse.getPrivateKey());
          Log.d(TorusDirectPlugin.class.getSimpleName(), "Public Address: " + torusLoginResponse.getPublicAddress());
        }
        catch (ExecutionException | InterruptedException e) {
          e.printStackTrace();

        }
      }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
