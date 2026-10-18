/// @param playableArray
/// @param [behavior=DONT_LOOP]
/// @param [fadeInTime=0]
/// @param [playCallback]

function VinylBrainQueue(_playableArray, _behavior = VINYL_QUEUE_DONT_LOOP, _fadeInTime = 0, _playCallback = undefined) : VinylBrainCommonConstructor(true) constructor
{
    __playableArray = variable_clone(_playableArray);
    __voice         = undefined;
    __loopQueue     = false;
    __behavior      = _behavior;
    __fadeInTime    = _fadeInTime;
    __playCallback  = _playCallback;
    
    __playType    = __VINYL_PLAY_NONE;
    __playEmitter = undefined;
    __playX       = undefined;
    __playY       = undefined;
    __playZ       = undefined;
    
    
    
    static GetVoice = function()
    {
        return __voice;
    }
    
    static SetFadeIn = function(_time)
    {
        __fadeInTime = _time;
        
        return self;
    }
    
    static GetFadeIn = function()
    {
        return __fadeInTime;
    }
    
    static SetPlayableArray = function(_playableArray)
    {
        VinylAssertPlayable(_playableArray);
        
        __playableArray = variable_clone(_playableArray);
        
        if ((__behavior == VINYL_QUEUE_LOOP_ON_LAST) && VinylGetAnyPlaying(__voice))
        {
            VinylSetLoop(__voice, (array_length(__playableArray) <= 0));
        }
        
        return self;
    }
    
    static GetPlayableArray = function()
    {
        return variable_clone(__playableArray);
    }
    
    static SetBottom = function(_playable)
    {
        __playableArray[@ max(0, array_length(__playableArray)-1)] = variable_clone(_playable);
        
        return self;
    }
    
    static PushBottom = function(_playable)
    {
        array_push(__playableArray, variable_clone(_playable));
        
        return self;
    }
    
    static PushTop = function(_playable)
    {
        array_insert(__playableArray, 0, variable_clone(_playable));
        
        return self;
    }
    
    static GetContains = function(_playable)
    {
        return array_contains(__playableArray, _playable);
    }
    
    static Clear = function(_stopCurrent = false)
    {
        array_resize(__playableArray, 0);
        if (_stopCurrent) VinylStop(__voice);
        
        return self;
    }
    
    static SetBehavior = function(_behavior)
    {
        __behavior = _behavior;
        
        if (VinylGetAnyPlaying(__voice))
        {
            var _loop = (__behavior == VINYL_QUEUE_LOOP_ON_LAST)? (array_length(__playableArray) <= 0) : (__behavior == VINYL_QUEUE_LOOP_EACH);
            VinylSetLoop(__voice, _loop);
        }
        
        return self;
    }
    
    static GetBehavior = function()
    {
        return __behavior;
    }
    
    
    
    static ImplUpdate = function()
    {
        if ((__playType != __VINYL_PLAY_NONE) && (array_length(__playableArray) > 0) && VinylGetWillStop(__voice))
        {
            var _playable = array_shift(__playableArray);
            if (__loopQueue) array_push(__playableArray, _playable);
            
            var _gain = (__fadeInTime > 0)? 0 : 1;
            var _loop = (__behavior == VINYL_QUEUE_LOOP_ON_LAST)? (array_length(__playableArray) <= 1) : (__behavior == VINYL_QUEUE_LOOP_EACH);
            
            if (__playType == __VINYL_PLAY_OMNI)
            {
                __voice = VinylPlayOmni(__playableArray[0], _loop, _gain);
            }
            else if (__playType == __VINYL_PLAY_AT)
            {
                __voice = VinylPlayAt(__playableArray[0], __playX, __playY, __playZ, _loop, _gain);
            }
            else if (__playType == __VINYL_PLAY_ON)
            {
                __voice = VinylPlayOn(__playableArray[0], __playEmitter, _loop, _gain);
            }
            else
            {
                __VinylError($"Play type `{__playType}` unhandled");
            }
            
            if (__fadeInTime > 0)
            {
                VinylSetGain(__voice, 1, __fadeInTime);
            }
            
            if (is_callable(__playCallback))
            {
                __playCallback(self, __voice);
            }
        }
    }
    
    
    
    
    
    static ImplPlayOmni = function(_loop, _gain_UNUSED, _pitch_UNUSED)
    {
        __playType = __VINYL_PLAY_OMNI;
        
        __loopQueue = _loop;
        
        ImplUpdate();
        
        return self;
    }
    
    static ImplPlayAt = function(_x, _y, _z, _loop, _gain_UNUSED, _pitch_UNUSED)
    {
        __playType = __VINYL_PLAY_AT;
        __playX    = _x;
        __playY    = _y;
        __playZ    = _z;
        
        __loopQueue = _loop;
        
        ImplUpdate();
        
        return self;
    }
    
    static ImplPlayOn = function(_emitter, _loop, _gain_UNUSED, _pitch_UNUSED)
    {
        __playType    = __VINYL_PLAY_ON;
        __playEmitter = _emitter;
        
        __loopQueue = _loop;
        
        ImplUpdate();
        
        return self;
    }
    
    static ImplStop = function()
    {
        var _voice = __voice;
        __voice = undefined;
        return VinylStop(_voice);
    }
    
    static ImplGetAnyPlaying = function()
    {
        return VinylGetAnyPlaying(__voice);
    }
    
    static ImplGetAllPlaying = function()
    {
        return VinylGetAllPlaying(__voice);
    }
    
    static ImplGetVoiceForFadeOut = function()
    {
        return __voice;
    }
    
    static ImplGetTrackPosition = function()
    {
        return VinylGetTrackPosition(__voice);
    }
    
    static ImplSetLoop = function(_state)
    {
        __loopQueue = _state;
        
        return undefined;
    }
    
    static ImplGetAnyLoop = function()
    {
        return __loopQueue;
    }
    
    static ImplGetAllLoop = function()
    {
        return __loopQueue;
    }
    
    static ImplPause = function()
    {
        return VinylPause(__voice);
    }
    
    static ImplResume = function()
    {
        return VinylResume(__voice);
    }
    
    static ImplGetAllPaused = function()
    {
        return VinylGetAllPaused(__voice);
    }
    
    static ImplGetAnyPaused = function()
    {
        return VinylGetAnyPaused(__voice);
    }
}