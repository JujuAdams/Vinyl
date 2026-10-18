/// @param playable
/// @param minDelay
/// @param maxDelay
/// @param [playImmediate=false]

function VinylBrainRetrigger(_playable, _minDelay, _maxDelay, _playImmediate = false) : VinylBrainVoicedConstructor(true) constructor
{
    VinylAssertPlayable(_playable);
    
    __playable      = _playable;
    __minDelay      = _minDelay;
    __maxDelay      = _maxDelay;
    __playImmediate = _playImmediate;
    
    __loop = true;
    __nextPlay = infinity;
    
    __gain  = 1;
    __pitch = 1;
    
    __playType    = __VINYL_PLAY_NONE;
    __playEmitter = undefined;
    __playX       = undefined;
    __playY       = undefined;
    __playZ       = undefined;
    
    
    
    
    
    static ImplUpdate = function()
    {
        if (__voice != undefined)
        {
            if (VinylGetAllStopped(__voice))
            {
                __voice = undefined;
                __nextPlay = __loop? (current_time + VinylUtilRandomRange(__minDelay, __maxDelay) / 1000) : infinity;
            }
        }
        else if (current_time >= __nextPlay)
        {
            if (__playType == __VINYL_PLAY_OMNI)
            {
                __voice = VinylPlayOmni(__playable, false, __gain, __pitch);
            }
            else if (__playType == __VINYL_PLAY_AT)
            {
                __voice = VinylPlayAt(__playable, __playX, __playY, __playZ, false, __gain, __pitch);
            }
            else if (__playType == __VINYL_PLAY_ON)
            {
                __voice = VinylPlayOn(__playable, __playEmitter, false, __gain, __pitch);
            }
            else if (__playType != __VINYL_PLAY_NONE)
            {
                __VinylError($"Play type `{__playType}` unhandled");
            }
        }
    }
    
    static ImplPlayOmni = function(_loop, _gain, _pitch)
    {
        __playType = __VINYL_PLAY_OMNI;
        
        __loop  = _loop;
        __gain  = _gain;
        __pitch = _pitch;
        
        if (__playImmediate)
        {
            __voice = undefined;
            __nextPlay = -infinity;
            ImplUpdate();
        }
        else
        {
            __nextPlay = current_time + VinylUtilRandomRange(__minDelay, __maxDelay) / 1000;
            __voice = -1;
        }
        
        return __voice;
    }
    
    static ImplPlayAt = function(_x, _y, _z, _loop, _gain, _pitch)
    {
        __playType = __VINYL_PLAY_AT;
        __playX    = _x;
        __playY    = _y;
        __playZ    = _z;
        
        __loop  = _loop;
        __gain  = _gain;
        __pitch = _pitch;
        
        if (__playImmediate)
        {
            __voice = undefined;
            __nextPlay = -infinity;
            ImplUpdate();
        }
        else
        {
            __nextPlay = current_time + VinylUtilRandomRange(__minDelay, __maxDelay) / 1000;
            __voice = -1;
        }
        
        return __voice;
    }
    
    static ImplPlayOn = function(_emitter, _loop, _gain, _pitch)
    {
        __playType    = __VINYL_PLAY_ON;
        __playEmitter = _emitter;
        
        __loop  = _loop;
        __gain  = _gain;
        __pitch = _pitch;
        
        if (__playImmediate)
        {
            __voice = undefined;
            __nextPlay = -infinity;
            ImplUpdate();
        }
        else
        {
            __nextPlay = current_time + VinylUtilRandomRange(__minDelay, __maxDelay) / 1000;
            __voice = -1;
        }
        
        return __voice;
    }
    
    static ImplStop = function()
    {
        VinylStop(__voice);
        __voice = undefined;
        __nextPlay = infinity;
    }
    
    static ImplSetGain = function(_gain, _time)
    {
        if (__gain <= 0)
        {
            VinylSetGain(__voice, _gain, _time);
        }
        else
        {
            __VinylMultiplyGain(__voice, _gain / __gain, _time);
        }
        
        __gain = _gain;
    }
    
    static ImplGetGain = function()
    {
        return VinylGetGain(__voice);
    }
    
    static ImplSetPitch = function(_pitch)
    {
        if (__pitch <= 0)
        {
            VinylSetPitch(__voice, _pitch);
        }
        else
        {
            __VinylMultiplyPitch(__voice, _pitch / __pitch);
        }
        
        __pitch = _pitch;
    }
    
    static ImplGetPitch = function()
    {
        return VinylGetPitch(__voice);
    }
}