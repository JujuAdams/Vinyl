/// @param source
/// @param ...

function VinylMulti()
{
    switch(argument_count)
    {
        case 0: __VinylError("Unsupported number of arguments (0) for VinylMulti()\n(Should be at least 1)"); break;
        
        case 1: return new __VinylPatternMulti(argument[0]); break;
        case 2: return new __VinylPatternMulti(argument[0], argument[1]); break;
        case 3: return new __VinylPatternMulti(argument[0], argument[1], argument[2]); break;
        case 4: return new __VinylPatternMulti(argument[0], argument[1], argument[2], argument[3]); break;
        case 5: return new __VinylPatternMulti(argument[0], argument[1], argument[2], argument[3], argument[4]); break
        
        default: __VinylError("Unsupported number of arguments (", argument_count, ") for VinylMulti()\n(Please add another case to the switch statement)"); break;
    }
}

/// @param source
/// @param ...
function __VinylPatternMulti() constructor
{
    __VINYL_PATTERN_COMMON
    __instanceConstructor = __VinyInstanceMulti;
    
    __sources = array_create(argument_count, undefined);
    
    //Copy input sources into the actual array
    var _i = 0;
    repeat(argument_count)
    {
        __sources[@ _i] = __VinylPatternizeSource(argument[_i]);
        ++_i;
    }
    
    __synchronize    = false;
    __blendParam     = undefined;
    __blendAnimCurve = undefined;
    __blendGains     = undefined;
    
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
    
    static BlendSet = function()
    {
        var _oldAnimCurve = __blendAnimCurve;
        
        var _param     = argument[0];
        var _animCurve = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : undefined;
        
        if (_oldAnimCurve != _animCurve)
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
        __blendGains     = undefined;
        
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
        if (!is_array(__blendGains)) return 1.0;
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