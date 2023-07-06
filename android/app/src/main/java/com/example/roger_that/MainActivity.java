package com.example.roger_that;

import android.content.Intent;
import android.net.Uri;
import android.provider.Settings;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.roger_that";
    private static final int CODE_DRAW_OVER_OTHER_APP_PERMISSION = 2084;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("openFloatingOverlay")) {
                        String groupId = call.argument("groupId");
                        result.success(openFloatingOverlay(groupId));
                    } else {
                        result.notImplemented();
                    }
                });
    }

    private boolean initializeView(String groupId) {
        Intent intent = new Intent(this, ChatHeadService.class);
        intent.putExtra("groupId", groupId);
        startService(intent);
        return true;
    }

    private boolean openFloatingOverlay(String groupId) {
        if (!Settings.canDrawOverlays(this)) {
            Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                    Uri.parse("package:" + getPackageName()));
            startActivityForResult(intent, CODE_DRAW_OVER_OTHER_APP_PERMISSION);
        }
        return initializeView(groupId);
    }

}
