package com.torusresearch.torusdirect.activity;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

import androidx.appcompat.app.AppCompatActivity;
import androidx.browser.customtabs.CustomTabsIntent;

import com.torusresearch.torusdirect.R;
import com.torusresearch.torusdirect.interfaces.ILoginHandler;

import java.util.Objects;
import java.util.concurrent.atomic.AtomicReference;

public class StartUpActivity extends AppCompatActivity {
    public static final String URL = "URL";
    public static AtomicReference<ILoginHandler> loginHandler = new AtomicReference<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_startup);

        CustomTabsIntent intent = new CustomTabsIntent.Builder().build();
        intent.launchUrl(this, Uri.parse(getIntent().getStringExtra(URL)));
        startActivity(intent.intent);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        if(intent != null && intent.getData() != null) {
            Log.d("result:torus", Objects.requireNonNull(intent.getData()).toString());
            if(loginHandler != null && loginHandler.get() != null) {
                loginHandler.get().setResponse(intent.getData().toString());
                loginHandler.set(null);
                finish();
            }
        }
    }
}
