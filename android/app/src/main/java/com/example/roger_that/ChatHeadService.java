package com.example.roger_that;

import android.app.Service;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.graphics.Point;
import android.os.IBinder;
import android.view.Display;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.RelativeLayout;

public class ChatHeadService extends Service {
    private WindowManager mWindowManager;
    private View mChatHeadView;
    String groupId;
    int mWidth;
    WindowManager.LayoutParams params;

    public ChatHeadService() {
//        Add the view to the window.
        params = new WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT);
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        groupId = intent.getStringExtra("groupId");
        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public void onCreate() {
        super.onCreate();

        mainWindow();
        closeButton();
        stickToWall();
        dragBehaviour();
    }


    private void dragBehaviour() {
        final CustomImageView chatHeadImage = mChatHeadView.findViewById(R.id.chat_head_profile_iv);
        chatHeadImage.setOnTouchListener(new View.OnTouchListener() {
            private int initialX;
            private int initialY;
            private float initialTouchX;
            private float initialTouchY;

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                switch (event.getAction()) {
                    case MotionEvent.ACTION_DOWN:
//                        remember the initial position.
                        initialX = params.x;
                        initialY = params.y;

//                        get the touch location
                        initialTouchX = event.getRawX();
                        initialTouchY = event.getRawY();
                        return true;


                    case MotionEvent.ACTION_UP:
                        int xDiff = (int) (event.getRawX() - initialTouchX);
                        int yDiff = (int) (event.getRawY() - initialTouchY);

                        if (xDiff == 0 && yDiff == 0) {
                            chatHeadImage.performClick();
                            Intent intent = new Intent(ChatHeadService.this, ChatHeadListService.class);
                            intent.putExtra("groupId", groupId);
                            intent.putExtra("x", params.x);
                            intent.putExtra("y", params.y);
                            startService(intent);
                        }

                        int middle = mWidth / 2;
                        float nearestXWall = params.x >= middle ? mWidth : 0;
                        params.x = (int) nearestXWall;
                        mWindowManager.updateViewLayout(mChatHeadView, params);

                        return true;
                    case MotionEvent.ACTION_MOVE:
//                        Calculate the X and Y coordinates of the view.
                        params.x = initialX + (int) (event.getRawX() - initialTouchX);
                        params.y = initialY + (int) (event.getRawY() - initialTouchY);

//                        Update the layout with new X & Y coordinate
                        mWindowManager.updateViewLayout(mChatHeadView, params);
                        return true;
                }
                return false;
            }
        });
    }

    private void stickToWall() {
        Display display = mWindowManager.getDefaultDisplay();
        final Point size = new Point();
        display.getSize(size);

        final RelativeLayout layout = mChatHeadView.findViewById(R.id.chat_head_root);
        ViewTreeObserver vto = layout.getViewTreeObserver();
        vto.addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                layout.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                int width = layout.getMeasuredWidth();
                //To get the accurate middle of the screen we subtract the width of the floating widget.
                mWidth = size.x - width;

            }
        });
    }

    private void closeButton() {
        ImageView closeButton = mChatHeadView.findViewById(R.id.close_btn);
        closeButton.setOnClickListener(v -> stopSelf());
    }

    private void mainWindow() {
        mChatHeadView = LayoutInflater.from(this).inflate(R.layout.layout_chat_head, null, false);

//        Specify the chat head position
        params.gravity = Gravity.TOP | Gravity.START;        //Initially view will be added to top-left corner
        params.x = 0;
        params.y = 100;

        //Add the view to the window
        mWindowManager = (WindowManager) getSystemService(WINDOW_SERVICE);
        mWindowManager.addView(mChatHeadView, params);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (mChatHeadView != null) mWindowManager.removeView(mChatHeadView);
    }
}