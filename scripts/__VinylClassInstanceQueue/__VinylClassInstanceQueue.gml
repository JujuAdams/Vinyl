function __VinylClassInstanceQueue() : __VinylClassInstanceCommon() constructor
{
    __ResetState();
    
    static __patternType = "queue";
    
    static toString = function()
    {
        return "<queue inst " + string(__id) + ">";
    }
    
    static __ResetState = function()
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (__id != undefined)) __VinylTrace("Resetting state for ", self);
        
        __ResetStateCommon();
        
        __index      = 0;
        __instance   = undefined;
        __assetArray = [];
        __behavior   = 0;
        __emitter    = undefined;
    }
    
    static __Play = function(_emitter, _assetArray, _loop, _gain, _pitch, _pan)
    {
        __index = 0;
        
        //Set the state
        __loop        = _loop ?? __GetLoopFromLabel();
        __pan         = _pan;
        __gainInput   = _gain;
        __pitchInput  = _pitch;
        
        __gainTarget  = __gainInput;
        __pitchTarget = __pitchInput;
        
        __randomPitchParam = __VinylRandom(1);
        
        __ApplyLabel(true);
        
        //Determine which emitter to use given the input arguments
        var _effectChainName = undefined; //TODO
        if (_emitter != undefined)
        {
            //Playback on a normal emitter
            __emitter = _emitter;
        
            //Add this instance to the emitter's array
            array_push(__emitter.__emitter.__instanceIDArray, __id);
        }
        else
        {
            if (__pan == undefined)
            {
                //Standard playback
                //Only use an emitter if the effect chain demands it
                __emitter = __VinylEffectChainGetEmitter(_effectChainName);
            }
            else
            {
                //Playback on a pan emitter
                __panEmitter = _poolPanEmitter.__Depool();
                __panEmitter.__Pan(__pan);
                __panEmitter.__Bus(_effectChainName);
                
                __emitter = __panEmitter.__emitter;
            }
        }
        
        //Make a local copy of the input asset array
        __assetArray = array_create(array_length(_assetArray), undefined);
        array_copy(__assetArray, 0, _assetArray, 0, array_length(_assetArray));
        
        if (array_length(__assetArray) > 0)
        {
            var _asset = __assetArray[__index];
            __instance = __VinylPatternGet(_asset).__Play(__emitter, _asset, __loop, __gainOutput, __pitchOutput, __pan);
        }
    }
    
    static __Tick = function(_deltaTimeFactor)
    {
        if ((__instance == undefined) || !__instance.__IsPlaying())
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
            __instance = __VinylPatternGet(_asset).__Play(__emitter, _asset, __loop, __gainOutput, __pitchOutput, __pan);
        }
        else
        {
            var _delta = clamp(__gainTarget - __gainInput, -_deltaTimeFactor*__gainRate, _deltaTimeFactor*__gainRate);
            if (_delta != 0)
            {
                __gainInput  += _delta;
                __gainOutput += _delta;
                __outputChanged = true;
                
                if (__shutdown && (_delta < 0) && ((__gainInput <= 0) || (__gainOutput <= 0)))
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
        }
    }
    
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
}