package com.torusresearch.torusdirect.interfaces;

import android.content.Context;

import com.torusresearch.torusdirect.types.LoginWindowResponse;
import com.torusresearch.torusdirect.types.TorusVerifierResponse;

import java8.util.concurrent.CompletableFuture;

public interface ILoginHandler {
    CompletableFuture<TorusVerifierResponse> getUserInfo(LoginWindowResponse params);

    CompletableFuture<LoginWindowResponse> handleLoginWindow(Context context);

    void setResponse(String response);

    String getFinalUrl();

}
