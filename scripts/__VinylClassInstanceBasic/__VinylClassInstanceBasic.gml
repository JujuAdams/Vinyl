function __VinylClassInstanceBasic() : __VinylClassInstanceCommon() constructor
{
    __StateReset();
    
    static __patternType = "basic";
    
    static toString = function()
    {
        if (__patternName == undefined)
        {
            return "<basic inst " + string(__id) + ">";
        }
        else
        {
            return "<basic inst " + string(__id) + " " + string(audio_get_name(__patternName)) + ">";
        }
    }
    
    static __StateReset = function()
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (__id != undefined)) __VinylTrace("Resetting state for ", self);
        
        __StateResetCommon();
    }
    
    static __Play = function(_pattern, _emitter, _sound, _loop, _gain, _pitch, _pan)
    {
        __StateSetCommon(_pattern, _emitter, _loop, _gain, _pitch, _pan);
        
        __instance = new __VinylClassInstanceGameMaker(); //TODO - Pool GameMaker instance wrappers
        __instance.__Play(__gmEmitter, __patternName, __loop, __gainOutput, __pitchOutput);
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " hosting ", __instance);
    }
    
    static __Tick = function(_deltaTimeFactor)
    {
        if (!__instance.__IsPlaying())
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " has stopped played, returning to pool");
            __VINYL_RETURN_SELF_TO_POOL
        }
        else
        {
            var _delta = clamp(__gainTarget - __gainInput, -_deltaTimeFactor*__gainRate, _deltaTimeFactor*__gainRate);
            if (_delta != 0)
            {
                __gainInput  += _delta;
                __gainOutput += _delta;
                __outputChanged = true;
            }
            
            if (__shutdown && (_delta <= 0) && ((__gainInput <= 0) || (__gainOutput <= 0)))
            {
                __Stop();
                return;
            }
            
            var _delta = clamp(__pitchTarget - __pitchInput, -_deltaTimeFactor*__pitchRate, _deltaTimeFactor*__pitchRate);
            if (_delta != 0)
            {
                __pitchInput  += _delta;
                __pitchOutput += _delta;
                __outputChanged = true;
            }
            
            if (__outputChanged)
            {
                __outputChanged = false;
                __instance.__GainSet(__gainOutput);
                __instance.__PitchSet(__pitchOutput);
            }
        }
    }
}