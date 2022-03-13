/// @param source

function VinylBasic(_asset)
{
    return new __VinylPatternBasic(_asset);
}

/// @param asset
function __VinylPatternBasic(_asset) constructor
{
    __VINYL_PATTERN_COMMON
    __instanceConstructor = __VinyInstanceBasic;
    
    if (!is_numeric(_asset) || !audio_exists(_asset))
    {
        __VinylError("Asset \"", _asset, "\" is invalid");
    }
    
    __asset     = _asset;
    __startTime = 0;
    __endTime   = audio_sound_length(__asset);
    __duration  = __endTime - __startTime;
    
    
    
    #region Public Methods
    
    static AssetGet = function()
    {
        return __asset;
    }
    
    static SectionSet = function(_startTime, _endTime)
    {
        __startTime = _startTime;
        __endTime   = (_endTime == undefined)? audio_sound_length(__asset) : _endTime;
        __duration  = __endTime - __startTime;
        
        return self;
    }
    
    static SectionGet = function()
    {
        return {
            startTime : __startTime,
            endTime   : __endTime,
            duration  : __duration,
        };
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static toString = function()
    {
        return audio_get_name(__asset) + " [" + string(__startTime) + "->" + string(__endTime) + "]";
    }
    
    #endregion
    
    
    
    if (VINYL_DEBUG) __VinylTrace("Created pattern for ", self);
}