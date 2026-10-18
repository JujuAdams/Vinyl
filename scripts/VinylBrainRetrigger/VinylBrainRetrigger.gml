/// @param sound
/// @param minDelay
/// @param maxDelay
/// @param [playImmediate=false]

function VinylBrainRetrigger(_sound, _minDelay, _maxDelay, _playImmediate = false) : __VinylClassBrainInterface() constructor
{
    array_push(__VinylSystem().__weakUpdateArray, weak_ref_create(self));
    
    __sound         = _sound;
    __minDelay      = _minDelay;
    __maxDelay      = _maxDelay;
    __playImmediate = _playImmediate;
    
    __voice = -1;
    __loop = true;
    __nextPlay = infinity;
    
    __playType    = __VINYL_PLAY_NONE;
    __playEmitter = undefined;
    __playX       = undefined;
    __playY       = undefined;
    __playZ       = undefined;
    
    
    
    static __Update = function()
    {
        if (current_time >= __nextPlay)
        {
            if (__playType == __VINYL_PLAY_OMNI)
            {
                __voice = VinylPlayOmni(__sound, false);
            }
            else if (__playType == __VINYL_PLAY_AT)
            {
                __voice = VinylPlayAt(__sound, __playX, __playY, __playZ, false);
            }
            else if (__playType == __VINYL_PLAY_ON)
            {
                __voice = VinylPlayOn(__sound, __playEmitter, false);
            }
            
            if (__loop)
            {
                __nextPlay = current_time + __VinylRandomRange(__minDelay, __maxDelay) / 1000;
            }
            else
            {
                __nextPlay = infinity;
            }
        }
    }
    
    static __ImplPlayOmni = function(_loop, _gain_UNUSED, _pitch_UNUSED)
    {
        __playType = __VINYL_PLAY_OMNI;
        
        __loop = _loop;
        
        if (__playImmediate)
        {
            __nextPlay = -infinity;
            __Update();
        }
        else
        {
            __nextPlay = current_time + __VinylRandomRange(__minDelay, __maxDelay) / 1000;
            __voice = -1;
        }
        
        return __voice;
    }
    
    static __ImplPlayAt = function(_x, _y, _z, _loop, _gain_UNUSED, _pitch_UNUSED)
    {
        __playType = __VINYL_PLAY_AT;
        __playX    = _x;
        __playY    = _y;
        __playZ    = _z;
        
        __loop = _loop;
        
        if (__playImmediate)
        {
            __nextPlay = -infinity;
            __Update();
        }
        else
        {
            __nextPlay = current_time + __VinylRandomRange(__minDelay, __maxDelay) / 1000;
            __voice = -1;
        }
        
        return __voice;
    }
    
    static __ImplPlayOn = function(_emitter, _loop, _gain_UNUSED, _pitch_UNUSED)
    {
        __playType    = __VINYL_PLAY_ON;
        __playEmitter = _emitter;
        
        __loop = _loop;
        
        if (__playImmediate)
        {
            __nextPlay = -infinity;
            __Update();
        }
        else
        {
            __nextPlay = current_time + __VinylRandomRange(__minDelay, __maxDelay) / 1000;
            __voice = -1;
        }
        
        return __voice;
    }
}