function __VinylClassInstanceBasic() : __VinylClassInstanceCommon() constructor
{
    __ResetState();
    
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
    
    static __ResetState = function()
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (__id != undefined)) __VinylTrace("Resetting state for ", self);
        
        __ResetStateCommon();
        
        __patternName = undefined;
        __instance    = undefined;
    }
    
    static __Play = function(_emitter, _sound, _loop, _gain, _pitch, _pan)
    {
        static _poolPanEmitter = __globalData.__poolPanEmitter;
        
        //Set the state
        __patternName = _sound;
        __loop        = _loop ?? __GetLoopFromLabel();
        __pan         = _pan;
        __gainInput   = _gain;
        __pitchInput  = _pitch;
        
        __gainTarget  = __gainInput;
        __pitchTarget = __pitchInput;
        
        __randomPitchParam = __VinylRandom(1);
        
        __ApplyLabel(true);
        
        //Determine which emitter to use given the input arguments
        var _effectChainName = __VinylPatternGetEffectChain(__patternName);
        var _usedEmitter = undefined;
        if (_emitter != undefined)
        {
            //Playback on a normal emitter
            _usedEmitter = _emitter.__GetEmitter();
        
            //Add this instance to the emitter's array
            array_push(_emitter.__emitter.__instanceIDArray, __id);
        }
        else
        {
            if (__pan == undefined)
            {
                //Standard playback
                //Only use an emitter if the effect chain demands it
                var _usedEmitter = __VinylEffectChainGetEmitter(_effectChainName);
            }
            else
            {
                //Playback on a pan emitter
                __panEmitter = _poolPanEmitter.__Depool();
                __panEmitter.__Pan(__pan);
                __panEmitter.__Bus(_effectChainName);
                
                _usedEmitter = __panEmitter.__emitter;
            }
        }
        
        __instance = new __VinylClassInstanceGameMaker(); //TODO - Pool GameMaker instance wrappers
        __instance.__Play(_usedEmitter, __patternName, __loop, __gainOutput, __pitchOutput);
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " hosting ", __instance);
    }
    
    static __Tick = function(_deltaTimeFactor)
    {
        if ((__instance == undefined) || !__instance.__IsPlaying())
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