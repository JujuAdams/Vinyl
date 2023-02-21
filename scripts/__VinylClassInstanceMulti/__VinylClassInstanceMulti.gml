function __VinylClassInstanceMulti() : __VinylClassInstanceCommon() constructor
{
    __ResetState();
    
    static __patternType = "multi";
    
    static toString = function()
    {
        return "<multi inst " + string(__id) + ">";
    }
    
    static __ResetState = function()
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (__id != undefined)) __VinylTrace("Resetting state for ", self);
        
        __ResetStateCommon();
        
        __blendFactor   = undefined;
        __sync          = false;
        __instanceArray = [];
        __gainArray     = [];
        
        __shortestIndex        = 0;
        __shortestPrevPosition = 0;
    }
    
    static __Play = function(_emitter, _assetArray, _loop, _gain, _pitch, _pan)
    {
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
        
        var _shortestLength = infinity;
        var _i = 0;
        repeat(array_length(_assetArray))
        {
            //Start an instance for this track
            var _asset = _assetArray[_i];
            var _instance = __VinylPatternGet(_asset).__Play(__emitter, _asset, __loop, __gainOutput, __pitchOutput, __pan);
            __instanceArray[@ _i] = _instance;
            
            //Set the gain too
            __gainArray[@ _i] = 1;
            
            //And then find the shortest instance and use that for syncing purposes
            var _length = _instance.__LengthGet();
            if (_length < _shortestLength)
            {
                _shortestLength = _length;
                
                __shortestIndex        = _i;
                __shortestPrevPosition = _instance.__PositionGet();
            }
            
            ++_i;
        }
    }
    
    static __Tick = function(_deltaTimeFactor)
    {
        if (!__instanceArray[__shortestIndex].__IsPlaying())
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Shortest instance for ", self, " is no longer playing, returning to pool");
            __VINYL_RETURN_SELF_TO_POOL
        }
        else
        {
            if (__sync)
            {
                var _shortestPosition = __instanceArray[__shortestIndex].__PositionGet();
                if (_shortestPosition != __shortestPrevPosition)
                {
                    if (_shortestPosition < __shortestPrevPosition)
                    {
                        //We've looped!
                        if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace(self, " shortest instance ", __instanceArray[__shortestIndex], " has looped, setting position for all other instances");
                        var _i = 0;
                        repeat(array_length(__instanceArray))
                        {
                            var _instance = __instanceArray[_i];
                            _instance.__PositionSet(_shortestPosition);
                            ++_i;
                        }
                    }
                    
                    __shortestPrevPosition = _shortestPosition;
                }
            }
            
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
                
                var _i = 0;
                repeat(array_length(__instanceArray))
                {
                    var _instance = __instanceArray[_i];
                    _instance.__GainSet(__gainOutput*__gainArray[_i]);
                    _instance.__PitchSet(__pitchOutput);
                    _instance.__Tick(_deltaTimeFactor);
                    ++_i;
                }
            }
            else
            {
                var _i = 0;
                repeat(array_length(__instanceArray))
                {
                    __instanceArray[_i].__Tick(_deltaTimeFactor);
                    ++_i;
                }
            }
        }
    }
    
    static __MultiChannelCountGet = function(_asset)
    {
        return array_length(__instanceArray);
    }
    
    static __MultiGainSet = function(_index, _gain)
    {
        if (_gain != __gainArray[_index])
        {
            __gainArray[@ _index] = _gain;
            __outputChanged = true;
        }
    }
    
    static __MultiGainGet = function(_index)
    {
        return __gainArray[_index];
    }
    
    static __MultiBlendSet = function(_blendFactor)
    {
        if (_blendFactor != __blendFactor)
        {
            __blendFactor = _blendFactor
            __outputChanged = true;
            
            _blendFactor *= array_length(__gainArray) - 1;
            
            var _i = 0;
            repeat(array_length(__gainArray))
            {
                var _gain = max(0, 1 - abs(_i - _blendFactor));
                __gainArray[@ _i] = _gain;
                
                //Immediately update the gain too
                __instanceArray[_i].__GainSet(__gainOutput*_gain);
                
                ++_i;
            }
        }
    }
    
    static __MultiBlendGet = function()
    {
        return __blendFactor;
    }
    
    static __MultiSyncSet = function(_state)
    {
        __sync = _state;
    }
    
    static __MultiSyncGet = function()
    {
        return __sync;
    }
    
    static __LoopSet = function(_state)
    {
        var _i = 0;
        repeat(array_length(__instanceArray))
        {
            __instanceArray[_i].__LoopSet(_state);
            ++_i;
        }
    }
}