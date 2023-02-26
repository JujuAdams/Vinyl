function __VinylClassInstanceMulti() : __VinylClassInstanceCommon() constructor
{
    __StateReset();
    
    static __patternType = "multi";
    
    static toString = function()
    {
        if (__pattern == undefined)
        {
            return "<multi " + string(__id) + ">";
        }
        else
        {
            return "<multi " + string(__id) + " " + string(__pattern.__name) + ">";
        }
    }
    
    static __StateReset = function()
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (__id != undefined)) __VinylTrace("Resetting state for ", self);
        
        __StateResetCommon();
        
        __blendFactorLocal  = undefined;
        __blendFactorOutput = undefined;
        
        __sync        = false;
        __childArray  = [];
        __gainArray   = [];
        
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
            repeat(array_length(__childArray))
            {
                __childArray[_i].__LoopSet(_state);
                ++_i;
            }
        }
    }
    
    static __LoopPointsSet = function()
    {
        var _i = 0;
        repeat(array_length(__childArray))
        {
            __childArray[_i].__LoopPointsSet();
            ++_i;
        }
    }
    
    #endregion
    
    
    
    #region Playback
    
    static __IsPlaying = function()
    {
        if (array_length(__childArray) <= 0) return false;
        return __childArray[__shortestIndex].__IsPlaying();
    }
    
    static __Pause = function()
    {
        var _i = 0;
        repeat(array_length(__childArray))
        {
            __childArray[_i].__Pause();
            ++_i;
        }
    }
    
    static __PauseGet = function()
    {
        if (array_length(__childArray) <= 0) return false;
        return __childArray[__shortestIndex].__PauseGet();
    }
    
    static __Resume = function()
    {
        var _i = 0;
        repeat(array_length(__childArray))
        {
            __childArray[_i].__Resume();
            ++_i;
        }
    }
    
    static __Stop = function()
    {
        if (array_length(__childArray) <= 0) return;
        
        var _i = 0;
        repeat(array_length(__childArray))
        {
            __childArray[_i].__Stop();
            ++_i;
        }
        
        array_resize(__childArray, 0);
        
        __VINYL_RETURN_SELF_TO_POOL
    }
    
    static __LengthGet = function()
    {
        if (array_length(__childArray) <= 0) return 0;
        return __childArray[__shortestIndex].__LengthGet();
    }
    
    static __PositionSet = function(_position)
    {
        var _i = 0;
        repeat(array_length(__childArray))
        {
            __childArray[_i].__PositionSet(_position);
            ++_i;
        }
    }
    
    static __PositionGet = function()
    {
        var _i = 0;
        repeat(array_length(__childArray))
        {
            __childArray[_i].__PositionGet();
            ++_i;
        }
    }
    
    #endregion
    
    
    
    #region Multi
    
    static __MultiChannelCountGet = function(_asset)
    {
        return array_length(__childArray);
    }
    
    static __MultiGainSet = function(_index, _gain)
    {
        __blendFactorLocal = undefined;
        if (_gain != __gainArray[_index]) __gainArray[@ _index] = _gain;
    }
    
    static __MultiGainGet = function(_index)
    {
        return __gainArray[_index];
    }
    
    static __MultiBlendSet = function(_blendFactor)
    {
        if (_blendFactor != __blendFactorLocal)
        {
            __blendFactorLocal = _blendFactor;
            
            __ApplyBlendFactor();
            
            //Immediately update the gain too in case the blend was immediately after creation
            var _i = 0;
            repeat(array_length(__gainArray))
            {
                __childArray[_i].__GainSet(__gainArray[_i]);
                ++_i;
            }
        }
    }
    
    static __MultiBlendGet = function()
    {
        return __blendFactorOutput;
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
        var _newBlend = __blendFactorLocal ?? __pattern.__blendFactorLocal;
        if (_newBlend != __blendFactorOutput)
        {
            __blendFactorOutput = _newBlend;
            
            if (__blendFactorOutput == undefined)
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
                if (__pattern.__blendNormalize)
                {
                    var _scaled = clamp(__blendFactorOutput, 0, 1)*(array_length(__gainArray) - 1);
                }
                else
                {
                    var _scaled = clamp(__blendFactorOutput, 0, array_length(__gainArray) - 1);
                }
                
                var _i = 0;
                repeat(array_length(__gainArray))
                {
                    var _gain = max(0, 1 - abs(_i - _scaled));
                    __gainArray[@ _i] = _gain;
                    ++_i;
                }
            }
        }
    }
    
    #endregion
    
    
    
    static __Instantiate = function(_pattern, _parentInstance, _vinylEmitter, _assetArray, _loop, _gain, _pitch, _pan, _sync)
    {
        __StateSetCommon(_pattern, _parentInstance, _vinylEmitter, _loop, _gain, _pitch, _pan);
        
        __blendFactorLocal  = undefined;
        __blendFactorOutput = undefined;
        __sync              = _sync;
        
        //Make a local copy of the input asset array
        __assetArray = array_create(array_length(_assetArray), undefined);
        array_copy(__assetArray, 0, _assetArray, 0, array_length(_assetArray));
        __gainArray = array_create(array_length(_assetArray), 1);
        
        __ApplyBlendFactor();
        
        var _shortestLength = infinity;
        var _i = 0;
        repeat(array_length(_assetArray))
        {
            //Start an instance for this track
            var _asset = _assetArray[_i];
            var _instance = __VinylPatternGet(_asset).__Play(self, __initialEmitter, _asset, __initialLoop, __gainArray[_i], 1, __pan);
            __childArray[@ _i] = _instance;
            
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
    
    static __Migrate = function()
    {
        __pattern = __VinylPatternGet(__pattern.__name);
        __MigrateCommon();
        
        var _i = 0;
        repeat(array_length(__childArray))
        {
            __childArray[_i].__Migrate();
            ++_i;
        }
    }
    
    static __Tick = function(_deltaTimeFactor)
    {
        if ((__shortestIndex >= array_length(__childArray)) || !__childArray[__shortestIndex].__IsPlaying())
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Shortest instance for ", self, " is no longer playing, returning to pool");
            __VINYL_RETURN_SELF_TO_POOL
        }
        else
        {
            if (__sync)
            {
                var _shortestPosition = __childArray[__shortestIndex].__PositionGet();
                if (_shortestPosition != __shortestPrevPosition)
                {
                    if (_shortestPosition < __shortestPrevPosition)
                    {
                        //We've looped!
                        if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace(self, " shortest instance ", __childArray[__shortestIndex], " has looped, setting position for all other instances");
                        
                        var _i = 0;
                        repeat(array_length(__childArray))
                        {
                            var _instance = __childArray[_i];
                            _instance.__PositionSet(_shortestPosition);
                            ++_i;
                        }
                    }
                    
                    __shortestPrevPosition = _shortestPosition;
                }
            }
            
            __TickCommon(_deltaTimeFactor);
            
            if (__IsPlaying())
            {
                __ApplyBlendFactor();
                
                var _i = 0;
                repeat(array_length(__childArray))
                {
                    with(__childArray[_i])
                    {
                        __GainSet(other.__gainArray[_i]);
                        __Tick(_deltaTimeFactor);
                    }
                    
                    ++_i;
                }
            }
        }
    }
}