package com.example.roger_that;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.IBinder;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ListView;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import java.io.File;
import java.util.ArrayList;
import java.util.Objects;

public class ChatHeadListService extends Service {
    private WindowManager mWindowManager;
    private View mChatHeadListView;
    WindowManager.LayoutParams params;
    ArrayList<String> list;
    File[] files;

    public ChatHeadListService() {
        // Add the view to the window.
        params = new WindowManager.LayoutParams(WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT, WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE, PixelFormat.TRANSLUCENT);
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        String groupId = intent.getStringExtra("groupId");
        int y = intent.getIntExtra("y", 100);
        int x = intent.getIntExtra("x", 0);

        mainWindow(x, y);
        closeButton();
        createList(groupId);

        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public void onCreate() {
        super.onCreate();
    }

    private void createList(String groupId) {
        final ListView listView = mChatHeadListView.findViewById(R.id.chat_action);
        list = new ArrayList<>();
        String path = Objects.requireNonNull(getExternalFilesDir(null)).getPath() + "/" + groupId + "/";

        files = new File(path).listFiles();
        for (File file : files) {
            if (file.isFile()) {
                list.add(file.getName());
            }
        }

        final ArrayAdapter<String> adapter = new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, list);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener((adapterView, view, position, id) -> {
            onListItemClick(position);
            stopSelf();
        });
    }

    private void mainWindow(int x, int y) {
        mChatHeadListView = LayoutInflater.from(this).inflate(R.layout.layout_chat_list, null, false);

        // Specify the chat head position
        params.gravity = Gravity.TOP | Gravity.START; // Initially view will be added to top-left corner
        params.x = x;
        params.y = y;

        // Add the view to the window
        mWindowManager = (WindowManager) getSystemService(WINDOW_SERVICE);
        mWindowManager.addView(mChatHeadListView, params);
    }

    private void closeButton() {
        ImageView _closeButton = mChatHeadListView.findViewById(R.id.close_btn);
        _closeButton.setOnClickListener(v -> {
            startService(new Intent(ChatHeadListService.this, ChatHeadService.class));
            stopSelf();
        });
    }

    private void onListItemClick(int position) {
        NotificationCompat.Builder builder = new NotificationCompat.Builder(getApplicationContext(), "M_CH_ID")
                .setContentTitle("test").setContentText("content").setSmallIcon(R.mipmap.ic_launcher)
                .setAutoCancel(true).setDefaults(Notification.FLAG_ONLY_ALERT_ONCE);
        NotificationManager manager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        MediaPlayer mediaPlayer = MediaPlayer.create(this, Uri.fromFile(files[position]));
        mediaPlayer.start();
        manager.notify(1, builder.build());
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (mChatHeadListView != null)
            mWindowManager.removeView(mChatHeadListView);
    }
}
