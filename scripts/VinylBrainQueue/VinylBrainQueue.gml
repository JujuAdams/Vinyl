/// @param soundArray
/// @param [behavior=DONT_LOOP]
/// @param [fadeInTime=0]

function VinylBrainQueue(_soundArray, _behavior = VINYL_QUEUE_DONT_LOOP, _fadeInTime = 0) : __VinylClassBrainInterface() constructor
{
    static _weakUpdateArray = __VinylSystem().__weakUpdateArray;
    
    __soundArray = variable_clone(_soundArray);
    __voice      = undefined;
    __loopQueue  = false;
    __behavior   = _behavior;
    __fadeInTime = _fadeInTime;
    
    __playType    = __VINYL_PLAY_NONE;
    __playEmitter = undefined;
    __playX       = undefined;
    __playY       = undefined;
    __playZ       = undefined;
    
    array_push(_weakUpdateArray, self)
    
    
    
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
    
    static SetSoundArray = function(_soundArray)
    {
        __soundArray = variable_clone(_soundArray);
        
        if ((__behavior == VINYL_QUEUE_LOOP_ON_LAST) && VinylGetAnyPlaying(__voice))
        {
            VinylSetLoop(__voice, (array_length(__soundArray) <= 0));
        }
        
        return self;
    }
    
    static GetSoundArray = function()
    {
        return variable_clone(__soundArray);
    }
    
    static SetBottom = function(_sound)
    {
        __soundArray[@ max(0, array_length(__soundArray)-1)] = variable_clone(_sound);
        
        return self;
    }
    
    static PushBottom = function(_sound)
    {
        array_push(__soundArray, variable_clone(_sound));
        
        return self;
    }
    
    static PushTop = function(_sound)
    {
        array_insert(__soundArray, 0, variable_clone(_sound));
        
        return self;
    }
    
    static GetContains = function(_sound)
    {
        return array_contains(__soundArray, _sound);
    }
    
    static Clear = function(_stopCurrent = false)
    {
        array_resize(__soundArray, 0);
        if (_stopCurrent) VinylStop(__voice);
        
        return self;
    }
    
    static SetBehavior = function(_behavior)
    {
        __behavior = _behavior;
        
        if (VinylGetAnyPlaying(__voice))
        {
            var _loop = (__behavior == VINYL_QUEUE_LOOP_ON_LAST)? (array_length(__soundArray) <= 0) : (__behavior == VINYL_QUEUE_LOOP_EACH);
            VinylSetLoop(__voice, _loop);
        }
        
        return self;
    }
    
    static GetBehavior = function()
    {
        return __behavior;
    }
    
    
    
    static __Update = function()
    {
        if ((__playType != __VINYL_PLAY_NONE) && (array_length(__soundArray) > 0) && VinylVoiceGetWillStop(__voice))
        {
            var _sound = array_shift(__soundArray);
            if (__loopQueue) array_push(__soundArray, _sound);
            
            var _gain = (__fadeInTime > 0)? 0 : 1;
            var _loop = (__behavior == VINYL_QUEUE_LOOP_ON_LAST)? (array_length(__soundArray) <= 1) : (__behavior == VINYL_QUEUE_LOOP_EACH);
            
            if (__playType == __VINYL_PLAY_OMNI)
            {
                __voice = _loop? VinylPlayLoopOmni(__soundArray[0], _gain) : VinylPlayOmni(__soundArray[0], _gain);
            }
            else if (__playType == __VINYL_PLAY_AT)
            {
                __voice = _loop? VinylPlayLoopAt(__soundArray[0], __playX, __playY, __playZ, _gain) : VinylPlayAt(__soundArray[0], __playX, __playY, __playZ, _gain);
            }
            else if (__playType == __VINYL_PLAY_ON)
            {
                __voice = _loop? VinylPlayLoopOn(__soundArray[0], __playEmitter, _gain) : VinylPlayOn(__soundArray[0], __playEmitter, _gain);
            }
            
            if (__fadeInTime > 0)
            {
                VinylSetGain(__voice, 1, __fadeInTime);
            }
        }
    }
    
    
    
    
    
    static __ImplPlayOmni = function(_gain_UNUSED, _pitch_UNUSED)
    {
        __playType = __VINYL_PLAY_OMNI;
        
        __loopQueue = false;
        
        __Update();
        
        return self;
    }
    
    static __ImplPlayLoopOmni = function(_gain_UNUSED, _pitch_UNUSED)
    {
        __playType = __VINYL_PLAY_OMNI;
        
        __loopQueue = true;
        
        __Update();
        
        return self;
    }
    
    static __ImplPlayAt = function(_x, _y, _z, _gain_UNUSED, _pitch_UNUSED)
    {
        __playType = __VINYL_PLAY_AT;
        __playX    = _x;
        __playY    = _y;
        __playZ    = _z;
        
        __loopQueue = false;
        
        __Update();
        
        return self;
    }
    
    static __ImplPlayLoopAt = function(_x, _y, _z, _gain_UNUSED, _pitch_UNUSED)
    {
        __playType = __VINYL_PLAY_AT;
        __playX    = _x;
        __playY    = _y;
        __playZ    = _z;
        
        __loopQueue = true;
        
        __Update();
        
        return self;
    }
    
    static __ImplPlayOn = function(_emitter, _gain_UNUSED, _pitch_UNUSED)
    {
        __playType    = __VINYL_PLAY_ON;
        __playEmitter = _emitter;
        
        __loopQueue = false;
        
        __Update();
        
        return self;
    }
    
    static __ImplPlayLoopOn = function(_emitter, _gain_UNUSED, _pitch_UNUSED)
    {
        __playType    = __VINYL_PLAY_ON;
        __playEmitter = _emitter;
        
        __loopQueue = true;
        
        __Update();
        
        return self;
    }
    
    static __ImplStop = function()
    {
        var _voice = __voice;
        __voice = undefined;
        return VinylStop(__voice);
    }
    
    static __ImplGetAnyPlaying = function()
    {
        return VinylGetAnyPlaying(__voice);
    }
    
    static __ImplGetAllPlaying = function()
    {
        return VinylGetAllPlaying(__voice);
    }
    
    static __ImplGetVoiceForFadeOut = function()
    {
        return __voice;
    }
    
    static __ImplSetLoop = function(_state)
    {
        __loopQueue = _state;
        
        return undefined;
    }
    
    static __ImplGetAnyLoop = function()
    {
        return __loopQueue;
    }
    
    static __ImplGetAllLoop = function()
    {
        return __loopQueue;
    }
    
    static __ImplPause = function()
    {
        return VinylPause(__voice);
    }
    
    static __ImplResume = function()
    {
        return VinylResume(__voice);
    }
    
    static __ImplGetAllPaused = function()
    {
        return VinylGetAllPaused(__voice);
    }
    
    static __ImplGetAnyPaused = function()
    {
        return VinylGetAnyPaused(__voice);
    }
}