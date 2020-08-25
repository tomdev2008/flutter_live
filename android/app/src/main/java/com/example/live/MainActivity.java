package com.example.live;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    //通讯名称,回到手机桌面
    private final String chanel = "android/back/desktop";

    //返回手机桌面事件
    static final String eventBackDesktop = "backDesktop";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), chanel).setMethodCallHandler(
                (methodCall, result) -> {
                    if (methodCall.method.equals(eventBackDesktop)) {
                        result.success(true);
                        moveTaskToBack(false);
                    }
                }
        );
    }
}
