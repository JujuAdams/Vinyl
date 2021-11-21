package org.libsdl.app;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import android.content.Context;
import android.os.Build;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.util.Log;
import android.view.InputDevice;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;


public class SDLControllerManager {

    public static native int nativeSetupJNI();

    public static native int nativeAddJoystick(int device_id, String name, String desc,
                                               int vendor_id, int product_id,
                                               boolean is_accelerometer, int button_mask,
                                               int naxes, int nhats, int nballs);
    public static native int nativeRemoveJoystick(int device_id);
    public static native int nativeAddHaptic(int device_id, String name);
    public static native int nativeRemoveHaptic(int device_id);
    public static native int onNativePadDown(int device_id, int keycode);
    public static native int onNativePadUp(int device_id, int keycode);
    public static native void onNativeJoy(int device_id, int axis,
                                          float value);
    public static native void onNativeHat(int device_id, int hat_id,
                                          int x, int y);

    private static final String TAG = "SDLControllerManager";

    public static void initialize() {
    }

    // Joystick glue code, just a series of stubs that redirect to the SDLJoystickHandler instance
    public static boolean handleJoystickMotionEvent(MotionEvent event) {
    return false;
    }

    /**
     * This method is called by SDL using JNI.
     */
    public static void pollInputDevices() {
    }

    /**
     * This method is called by SDL using JNI.
     */
    public static void pollHapticDevices() {
    }

    /**
     * This method is called by SDL using JNI.
     */
    public static void hapticRun(int device_id, float intensity, int length) {
    }

    /**
     * This method is called by SDL using JNI.
     */
    public static void hapticStop(int device_id){
    }

    // Check if a given device is considered a possible SDL joystick
    public static boolean isDeviceSDLJoystick(int deviceId) {
        return false;
    }
}

class SDLJoystickHandler {
    /**
     * Handles given MotionEvent.
     * @param event the event to be handled.
     * @return if given event was processed.
     */
    public boolean handleMotionEvent(MotionEvent event) {
        return false;
    }

    /**
     * Handles adding and removing of input devices.
     */
    public void pollInputDevices() {
    }
}
