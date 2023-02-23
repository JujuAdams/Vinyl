function __VinylClassInstanceQueue() : __VinylClassInstanceCommon() constructor
{
    __StateReset();
    
    static __patternType = "queue";
    
    static toString = function()
    {
        return "<queue inst " + string(__id) + ">";
    }
    
    static __StateReset = function()
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (__id != undefined)) __VinylTrace("Resetting state for ", self);
        
        __StateResetCommon();
        
        __index      = 0;
        __instance   = undefined;
        __assetArray = [];
        __behavior   = 0;
        __emitter    = undefined;
    }
    
    
    
    #region Gain
    
    static __GainSet = function(_gain)
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot set gain for ", self, ", it is set to shut down");
            return;
        }
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace(self, " gain=", _gain);
        }
        
        __gainTarget = _gain;
        __gainRate   = infinity;
        
        //Don't propagate gain immediately
    }
    
    static __GainTargetSet = function(_targetGain, _rate, _stopAtSilence = false)
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot set gain target for ", self, ", it is set to shut down");
            return;
        }
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace(self, " gain target=", _targetGain, ", rate=", _rate, "/s, stop at silence=", _stopAtSilence? "true" : "false");
        }
        
        __gainTarget = _targetGain;
        __gainRate   = _rate;
        __shutdown   = _stopAtSilence;
        
        //Don't propagate gain immediately
    }
    
    #endregion
    
    
    
    #region Pitch
    
    static __PitchSet = function(_pitch)
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot set pitch for ", self, ", it is set to shut down");
            return;
        }
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace(self, " pitch=", _pitch);
        }
        
        __pitchTarget = _pitch;
        __pitchRate   = infinity;
        
        //Don't propagate pitch immediately
    }
    
    static __PitchTargetSet = function(_targetPitch, _rate)
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot set pitch target for ", self, ", it is set to shut down");
            return;
        }
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace(self, " pitch target=", _targetPitch, ", rate=", _rate, "/s");
        }
        
        __pitchTarget = _targetPitch;
        __pitchRate   = _rate;
        
        //Don't propagate pitch immediately
    }
    
    #endregion
    
    
    
    #region Queue
    
    static __QueuePush = function(_asset, _dontRepeatLast)
    {
        if (_dontRepeatLast && (array_length(__assetArray) > 0) && (__assetArray[array_length(__assetArray)-1] == _asset)) return;
        array_push(__assetArray, _asset);
    }
    
    static __QueueBehaviorSet = function(_behavior)
    {
        __behavior = _behavior;
    }
    
    static __QueueBehaviorGet = function()
    {
        return __behavior;
    }
    
    #endregion
    
    
    
    static __Play = function(_pattern, _emitter, _assetArray, _loop, _gain, _pitch, _pan, _behavior)
    {
        __index = 0;
        
        __StateSetCommon(_pattern, _emitter, _loop, _gain, _pitch, _pan);
        __behavior = _behavior;
        
        //Make a local copy of the input asset array
        __assetArray = array_create(array_length(_assetArray), undefined);
        array_copy(__assetArray, 0, _assetArray, 0, array_length(_assetArray));
        
        if (array_length(__assetArray) > 0)
        {
            var _asset = __assetArray[__index];
            __instance = __VinylPatternGet(_asset).__Play(__gmEmitter, _asset, __loop, __gainOutput, __pitchOutput, __pan);
        }
    }
    
    static __Tick = function(_deltaTimeFactor)
    {
        if (!__instance.__IsPlaying())
        {
            if (__behavior == 0) //Play the queue in its entirety once, popping assets off the queue as they finish
            {
                array_delete(__assetArray, __index, 1);
                
                if (array_length(__assetArray) <= 0)
                {
                    if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " asset queue is empty, returning to pool");
                    __VINYL_RETURN_SELF_TO_POOL
                    return;
                }
                
                __index = __index mod array_length(__assetArray);
            }
            else if (__behavior == 1) //Repeat the queue from the start once complete
            {
                if (array_length(__assetArray) <= 0)
                {
                    if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " asset queue is empty, returning to pool");
                    __VINYL_RETURN_SELF_TO_POOL
                    return;
                }
                
                __index = (__index + 1) mod array_length(__assetArray);
            }
            else if (__behavior == 2) //Repeat the last asset in the queue (popping assets once finished)
            {
                if (array_length(__assetArray) > 1)
                {
                    array_delete(__assetArray, __index, 1);
                    __index = __index mod array_length(__assetArray);
                }
            }
            
            var _asset = __assetArray[__index];
            __instance = __VinylPatternGet(_asset).__Play(__gmEmitter, _asset, __loop, __gainOutput, __pitchOutput, __pan);
        }
        else
        {
            var _delta = clamp(__gainTarget - __gainInput, -_deltaTimeFactor*__gainRate, _deltaTimeFactor*__gainRate);
            if (_delta != 0)
            {
                __gainInput  += _delta;
                __gainOutput += _delta;
                __outputChanged = true;
                
                if (__shutdown && (_delta <= 0) && ((__gainInput <= 0) || (__gainOutput <= 0)))
                {
                    __Stop();
                    return;
                }
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
            
            __instance.__Tick(_deltaTimeFactor);
        }
    }
}