package ${YYAndroidPackageName}; /* this class will reside in Runner's package namespace */

import java.lang.String;
import android.util.Log;

import android.content.Intent;
import android.content.res.Configuration;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuItem;
import android.app.Dialog;
import android.view.MotionEvent;

import org.screwyoyo.faudiogms.FAudioGMSNative;
import org.libsdl.app.SDLActivity;
import org.libsdl.app.SDL;
import org.libsdl.app.SDLAudioManager;
import com.yoyogames.runner.RunnerJNILib;

import android.content.res.AssetManager;

public class FAudioGMSBridge extends FAudioGMSNative implements IExtensionBase
{
    public SDLActivity sdl;
    public boolean handlenativepause; /* automatically pause all sounds on onPause or not? */
    public boolean paused; /* are we currently paused */

    public FAudioGMSBridge()
    {
        super();
        handlenativepause = true; /* set this to false if you wish to handle pauses manually */
        paused = false; /* this one must be false at initialization */
        SDL.setContext(RunnerJNILib.GetApplicationContext());
        sdl = new SDLActivity();
    }

    public void Init()
    {
        SDL.setContext(RunnerJNILib.GetApplicationContext());
        sdl.onCreate(null);
    }

    public void onStart()
    {
        SDL.setContext(RunnerJNILib.GetApplicationContext());
        sdl.onStart();
    }

    public void onRestart()
    {
        onStart();
    }

    public void onStop()
    {
        sdl.onStop();
    }

    public void onDestroy()
    {
        sdl.onDestroy();
    }

    public void onPause()
    {
        sdl.onPause();
        if (handlenativepause && !paused)
        {
            paused = true;
            FAudioGMS_PauseAll();
        }
    }

    public void onResume()
    {
        sdl.onResume();
        if (handlenativepause && paused)
        {
            paused = false;
            FAudioGMS_ResumeAll();
        }
    }

    public void onWindowFocusChanged(boolean hasFocus)
    {
        sdl.onWindowFocusChanged(hasFocus);
    }

    public void onConfigurationChanged(Configuration newConfig)
    {
        sdl.onConfigurationChanged(newConfig);
    }

    public void onRequestPermissionsResult(int requestCode,String permissions[], int[] grantResults)
    {
        sdl.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    public Dialog onCreateDialog(int id)
    {
        return null;
    }

    public boolean onTouchEvent(final MotionEvent event)
    {
        return false;
    }

    public boolean onGenericMotionEvent(MotionEvent event)
    {
        return false;
    }

    public boolean dispatchKeyEvent(KeyEvent event)
    {
        return false;
    }

    public boolean dispatchGenericMotionEvent(MotionEvent event)
    {
        return false;
    }

    public boolean performClick()
    {
        return false;
    }

    public void onNewIntent(android.content.Intent newIntent)
    {

    }

    public void onActivityResult(int requestCode, int resultCode, Intent data){}
    public boolean onKeyLongPress(int keyCode, KeyEvent event){return false;}
    public boolean onCreateOptionsMenu( Menu menu ){return false;}
	public boolean onOptionsItemSelected( MenuItem item ){return false;}

    public boolean onKeyDown( int keyCode, KeyEvent event )
    { return false;}
    public boolean onKeyUp( int keyCode, KeyEvent event ){return false;}
}
