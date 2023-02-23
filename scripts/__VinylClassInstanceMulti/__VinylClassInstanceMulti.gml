function __VinylClassInstanceMulti() : __VinylClassInstanceCommon() constructor
{
    __StateReset();
    
    static __patternType = "multi";
    
    static toString = function()
    {
        return "<multi inst " + string(__id) + ">";
    }
    
    static __StateReset = function()
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (__id != undefined)) __VinylTrace("Resetting state for ", self);
        
        __StateResetCommon();
        
        __blendFactor   = undefined;
        __sync          = false;
        __instanceArray = [];
        __gainArray     = [];
        
        __shortestIndex        = 0;
        __shortestPrevPosition = 0;
    }
    
    
    
    #region Loop
    
    static __LoopSet = function(_state)
    {
        if (__loop != _state)
        {
            __loop = _state;
            
            var _i = 0;
            repeat(array_length(__instanceArray))
            {
                __instanceArray[_i].__LoopSet(_state);
                ++_i;
            }
        }
    }
    
    static __LoopPointsSet = function()
    {
        var _i = 0;
        repeat(array_length(__instanceArray))
        {
            __instanceArray[_i].__LoopPointsSet();
            ++_i;
        }
    }
    
    #endregion
    
    
    
    #region Playback
    
    static __IsPlaying = function()
    {
        if (array_length(__instanceArray) <= 0) return false;
        return __instanceArray[__shortestIndex].__IsPlaying();
    }
    
    static __Pause = function()
    {
        var _i = 0;
        repeat(array_length(__instanceArray))
        {
            __instanceArray[_i].__Pause();
            ++_i;
        }
    }
    
    static __Resume = function()
    {
        var _i = 0;
        repeat(array_length(__instanceArray))
        {
            __instanceArray[_i].__Resume();
            ++_i;
        }
    }
    
    static __Stop = function()
    {
        if (array_length(__instanceArray) <= 0) return;
        
        var _i = 0;
        repeat(array_length(__instanceArray))
        {
            __instanceArray[_i].__Stop();
            ++_i;
        }
        
        array_resize(__instanceArray, 0);
        
        __VINYL_RETURN_SELF_TO_POOL
    }
    
    static __LengthGet = function()
    {
        if (array_length(__instanceArray) <= 0) return 0;
        return __instanceArray[__shortestIndex].__LengthGet();
    }
    
    static __PositionSet = function(_position)
    {
        var _i = 0;
        repeat(array_length(__instanceArray))
        {
            __instanceArray[_i].__PositionSet(_position);
            ++_i;
        }
    }
    
    static __PositionGet = function()
    {
        var _i = 0;
        repeat(array_length(__instanceArray))
        {
            __instanceArray[_i].__PositionGet();
            ++_i;
        }
    }
    
    #endregion
    
    
    
    #region Multi
    
    static __MultiChannelCountGet = function(_asset)
    {
        return array_length(__instanceArray);
    }
    
    static __MultiGainSet = function(_index, _gain)
    {
        __blendFactor = undefined;
        
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
            
            __ApplyBlendFactor();
            
            //Immediately update the gain too
            var _i = 0;
            repeat(array_length(__gainArray))
            {
                __instanceArray[_i].__GainSet(__gainOutput*__gainArray[_i]);
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
    
    static __ApplyBlendFactor = function()
    {
        if (__blendFactor == undefined)
        {
            var _i = 0;
            repeat(array_length(__gainArray))
            {
                __gainArray[@ _i] = 1;
                ++_i;
            }
        }
        else
        {
            var _blendFactor = __blendFactor*(array_length(__gainArray) - 1);
            
            var _i = 0;
            repeat(array_length(__gainArray))
            {
                var _gain = max(0, 1 - abs(_i - _blendFactor));
                __gainArray[@ _i] = _gain;
                ++_i;
            }
        }
    }
    
    #endregion
    
    
    
    static __Play = function(_pattern, _emitter, _assetArray, _loop, _gain, _pitch, _pan, _blendFactor, _sync)
    {
        __StateSetCommon(_pattern, _emitter, _loop, _gain, _pitch, _pan);
        __blendFactor = _blendFactor;
        __sync        = _sync;
        __ApplyBlendFactor();
        
        var _shortestLength = infinity;
        var _i = 0;
        repeat(array_length(_assetArray))
        {
            //Start an instance for this track
            var _asset = _assetArray[_i];
            var _instance = __VinylPatternGet(_asset).__Play(__gmEmitter, _asset, __loop, __gainOutput, __pitchOutput, __pan);
            __instanceArray[@ _i] = _instance;
            
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
}