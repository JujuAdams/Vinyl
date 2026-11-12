/// Constructor. Manages playables organised as a "Head loop tail". This is also known as "intro
/// loop outro". The head will be played first, if specified, then the loop sound will be played.
/// When you'd like the loop to stop, call `VinylSetLoop(logic, false)` targeting the logic. Once
/// the loop sound has stopped, the tail will play.
/// 
/// This logic is considered a playable and can be nested inside of other logic structs. Similarly,
/// each of the playables for this logic (head, loop, tail) can be any other form of playable. This
/// means you could use a queue logic for the loop playable.
/// 
/// @param [head]
/// @param loop
/// @param [tail]

function VinylLogicHLT(_head, _loop, _tail) : VinylLogicVoicedConstructor(true) constructor
{
    VinylAssertPlayable(_loop);
    
    __head = _head;
    __loop = _loop;
    __tail = _tail;
    
    __voice = undefined;
    __stage = 0;
    
    __gain  = 1;
    __pitch = 1;
    
    __playType    = __VINYL_PLAY_NONE;
    __playEmitter = undefined;
    __playX       = undefined;
    __playY       = undefined;
    __playZ       = undefined;
    
    
    
    
    
    static ImplUpdate = function()
    {
        if ((__playType != __VINYL_PLAY_NONE) && VinylGetWillStop(__voice))
        {
            var _funcPlay = function(_playable, _loop)
            {
                if (__playType == __VINYL_PLAY)
                {
                    __voice = VinylPlay(_playable, _loop, __gain, __pitch);
                }
                else if (__playType == __VINYL_PLAY_AT)
                {
                    __voice = VinylPlayAt(_playable, __playX, __playY, __playZ, _loop, __gain, __pitch);
                }
                else if (__playType == __VINYL_PLAY_ON)
                {
                    __voice = VinylPlayOn(_playable, __playEmitter, _loop, __gain, __pitch);
                }
                else
                {
                    __VinylError($"Play type `{__playType}` unhandled");
                }
            }
            
            if ((__stage == 0) && (__head != undefined))
            {
                _funcPlay(__head, false);
                __stage = 1;
            }
            else if (__stage <= 1)
            {
                _funcPlay(__loop, true);
                __stage = 2;
            }
            else if (__stage == 2)
            {
                if (__tail != undefined)
                {
                    _funcPlay(__tail, false);
                    __stage = 3;
                }
                else
                {
                    __stage = 4;
                }
            }
            else if (__stage == 3)
            {
                __stage = 4;
            }
        }
    }
    
    static ImplPlay = function(_loop_UNUSED, _gain, _pitch)
    {
        __playType = __VINYL_PLAY;
        
        __stage = 0;
        
        __gain  = _gain;
        __pitch = _pitch;
        
        ImplUpdate();
        
        return self;
    }
    
    static ImplPlayAt = function(_x, _y, _z, _loop_UNUSED, _gain, _pitch)
    {
        __playType = __VINYL_PLAY_AT;
        __playX    = _x;
        __playY    = _y;
        __playZ    = _z;
        
        __stage = 0;
        
        __gain  = _gain;
        __pitch = _pitch;
        
        ImplUpdate();
        
        return self;
    }
    
    static ImplPlayOn = function(_emitter, _loop_UNUSED, _gain, _pitch)
    {
        __playType    = __VINYL_PLAY_ON;
        __playEmitter = _emitter;
        
        __stage = 0;
        
        __gain  = _gain;
        __pitch = _pitch;
        
        ImplUpdate();
        
        return self;
    }
    
    static ImplStop = function()
    {
        VinylStop(__voice);
        __stage = 4;
    }
    
    static ImplGetPlaying = function()
    {
        return ((__stage != 0) && (__stage != 4));
    }
    
    static ImplGetAllPlaying = function()
    {
        return ((__stage != 0) && (__stage != 4));
    }
    
    static ImplGetWillStop = function()
    {
        if ((__stage == 0) || (__stage == 4))
        {
            return true;
        }
        
        if (__tail == undefined)
        {
            if (__stage == 2)
            {
                return VinylGetWillStop(__voice);
            }
        }
        else
        {
            if (__stage == 3)
            {
                return VinylGetWillStop(__voice);
            }
        }
        
        return false;
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