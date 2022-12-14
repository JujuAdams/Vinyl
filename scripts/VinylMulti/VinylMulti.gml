/// @param source
/// @param ...

function VinylMulti()
{
    __VINYL_COLLECT_ARGUMENTS_INTO_SOURCE_ARRAY
    return new __VinylPatternMulti(_argumentArray);
}

/// @param source
/// @param ...
function __VinylPatternMulti(_sources) constructor
{
    __VINYL_PATTERN_COMMON
    __instanceConstructor = __VinylInstanceMulti;
    
    __sources        = _sources;
    __synchronize    = false;
    __blendParam     = undefined;
    __blendAnimCurve = undefined;
    __blendGains     = array_create(array_length(__sources), 0);
    
    __VinylBlendUpdate();
    
    
    
    #region Public Methods
    
    static SynchronizeSet = function(_state)
    {
        __synchronize = _state;
        return self;
    }
    
    static SynchronizeGet = function()
    {
        return __synchronize;
    }
    
    static BlendSet = function(_param, _animCurve = undefined)
    {
        if (__blendAnimCurve != _animCurve)
        {
            var _channelCount = array_length(animcurve_get(_animCurve).channels);
            if (_channelCount < array_length(__sources)) __VinylError("Channel count in animation curve ", _animCurve, " (", _channelCount, ") is smaller than source count (", array_length(__sources));
            if (_channelCount > array_length(__sources)) __VinylTrace("Warning! Channel count in animation curve ", _animCurve, " (", _channelCount, ") is greater than source count (", array_length(__sources));
        }
        
        __blendParam     = _param;
        __blendAnimCurve = _animCurve;
        
        __VinylBlendUpdate();
        
        return self;
    }
    
    static BlendReset = function()
    {
        __blendParam     = undefined;
        __blendAnimCurve = undefined;
        __blendGains     = array_create(array_length(__sources), 0);
        
        return self;
    }
    
    static BlendGet = function()
    {
        return {
            parameter : __blendParam,
            animCurve : __blendAnimCurve,
        };
    }
    
    static BlendGainGet = function(_index)
    {
        if (!is_array(__blendGains)) return 0.0;
        if ((_index < 0) || (_index >= array_length(__blendGains))) __VinylError("Index provided (", _index, ") is invalid (0 <= index <= ", array_length(__blendGains) - 1, ")");
        return __blendGains[_index];
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static toString = function()
    {
        return "Multi " + string(__sources);
    }
    
    #endregion
    
    
    
    if (VINYL_DEBUG) __VinylTrace("Created pattern ", self);
}