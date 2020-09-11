package com.torusresearch.torusdirect;

import android.app.Activity;
import android.util.Log;
import android.content.Context;
import androidx.annotation.NonNull;
import android.os.Bundle;

import java.util.HashMap;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

import com.torusresearch.torusdirect.handlers.HandlerFactory;
import com.torusresearch.torusdirect.interfaces.ILoginHandler;
import com.torusresearch.torusdirect.types.CreateHandlerParams;
import com.torusresearch.torusdirect.types.LoginType;
import com.torusresearch.torusdirect.types.LoginWindowResponse;
import com.torusresearch.torusdirect.types.SubVerifierDetails;
import com.torusresearch.torusdirect.types.Auth0ClientOptions;
import com.torusresearch.torusdirect.types.TorusKey;
import com.torusresearch.torusdirect.types.TorusLoginResponse;
import com.torusresearch.torusdirect.types.DirectSdkArgs;
import com.torusresearch.torusdirect.types.TorusNetwork;
import com.torusresearch.torusdirect.types.TorusVerifierResponse;
import com.torusresearch.torusdirect.types.TorusVerifierUnionResponse;

import com.torusresearch.torusdirect.R;
import com.torusresearch.torusdirect.utils.Helpers;

import androidx.appcompat.app.AppCompatActivity;
import java8.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executors;
import java.util.concurrent.ForkJoinPool;


/** TorusDirect */
public class TorusDirectPlugin  implements FlutterPlugin, MethodCallHandler, ActivityAware  {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private Context context;
  private Activity activity;
  private MethodChannel channel;
  private TorusDirectSdk torusDirectSDK;
  private SubVerifierDetails subVerifierDetails;
  private ILoginHandler handler;


  public void  onDetachedFromActivity() {
    System.out.println("onDetachedFromActivity called");
  }

  public void  onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    System.out.println("onReattachedToActivityForConfigChanges called");
  }

  public void onAttachedToActivity(ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  public void onDetachedFromActivityForConfigChanges() {
    System.out.println("onDetachedFromActivityForConfigChanges called");
  }


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    System.out.println("onAttachedToEngine called");
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
    System.out.println("registerWith called");
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

        DirectSdkArgs directSdkArgs = new DirectSdkArgs("torusapp://io.flutter.app.FlutterApplication/redirect", TorusNetwork.TESTNET, "0x4023d2a0D330bF11426B12C6144Cfb96B7fa6183");
          this.torusDirectSDK  = new TorusDirectSdk(directSdkArgs, this.context);
        result.success(true);

        // Create login handler and return final url to return to Flutter for Dart intent
      case "getLoginFinalURL":
       handler = HandlerFactory.createHandler(new CreateHandlerParams(subVerifierDetails.getClientId(), subVerifierDetails.getVerifier(),
              this.torusDirectSDK.directSdkArgs.getRedirectUri(), subVerifierDetails.getTypeOfLogin(), this.torusDirectSDK.directSdkArgs.getBrowserRedirectUri(), subVerifierDetails.getJwtParams()));
      result.success(handler.getFinalUrl());

      case "handleResponse":
      String response = (String) call.arguments;
      LoginWindowResponse loginWindowResponse = new LoginWindowResponse();
      loginWindowResponse.parseResponse(response);
      ForkJoinPool.commonPool().submit(()-> {
        TorusVerifierResponse torusVerifierResponse = handler.getUserInfo(loginWindowResponse).join();
        HashMap<String, Object> verifierParams = new HashMap<>();
        verifierParams.put("verifier_id", torusVerifierResponse.getVerifierId());
        TorusKey torusKey = this.torusDirectSDK.getTorusKey( subVerifierDetails.getVerifier(), torusVerifierResponse.getVerifierId(), verifierParams, !Helpers.isEmpty(loginWindowResponse.getIdToken()) ? loginWindowResponse.getIdToken() : loginWindowResponse.getAccessToken()).join();
        HashMap<String, String> torusLoginInfoMap = (HashMap<String, String> ) new HashMap<String,String>();
        torusLoginInfoMap.put("email",torusVerifierResponse.getEmail());
        torusLoginInfoMap.put("name",torusVerifierResponse.getName());
        torusLoginInfoMap.put("id",torusVerifierResponse.getVerifierId());
        torusLoginInfoMap.put("profileImage",torusVerifierResponse.getProfileImage());
        torusLoginInfoMap.put("privateKey", torusKey.getPrivateKey());
        torusLoginInfoMap.put("publicAddress", torusKey.getPublicAddress());


          result.success(torusLoginInfoMap);
        });



//      case "triggerLogin":
//        Executors.newFixedThreadPool(10).submit(() -> {
//          try {
//            CompletableFuture<TorusLoginResponse> torusLoginResponseCompletableFuture = this.torusDirectSDK.triggerLogin(new SubVerifierDetails(LoginType.GOOGLE,
//                    "google-lrc",
//                    "221898609709-obfn3p63741l5333093430j3qeiinaa8.apps.googleusercontent.com",
//                    new Auth0ClientOptions.Auth0ClientOptionsBuilder("").build()));
//            TorusLoginResponse torusLoginResponse = torusLoginResponseCompletableFuture.get();
//            TorusVerifierUnionResponse userInfo = torusLoginResponse.getUserInfo();
//            Log.d(TorusDirectPlugin.class.getSimpleName(), "Private Key: " + torusLoginResponse.getPrivateKey());
//            Log.d(TorusDirectPlugin.class.getSimpleName(), "Public Address: " + torusLoginResponse.getPublicAddress());
//            HashMap<String, String> torusLoginInfoMap = (HashMap<String, String> ) new HashMap<String,String>();
//            torusLoginInfoMap.put("email",userInfo.getEmail());
//            torusLoginInfoMap.put("name",userInfo.getName());
//            torusLoginInfoMap.put("id",userInfo.getVerifierId());
//            torusLoginInfoMap.put("profileImage",userInfo.getProfileImage());
//            torusLoginInfoMap.put("privateKey", torusLoginResponse.getPrivateKey());
//            torusLoginInfoMap.put("publicAddress", torusLoginResponse.getPublicAddress());
//
//            result.success(torusLoginInfoMap);
//
//
//          } catch (ExecutionException | InterruptedException e) {
//            e.printStackTrace();
//
//          }
//        });
      }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
