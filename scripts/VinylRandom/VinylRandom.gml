/// @param source
/// @param ...

function VinylRandom()
{
    __VINYL_COLLECT_ARGUMENTS_INTO_SOURCE_ARRAY
    return new __VinylPatternRandom(_argumentArray);
}

/// @param source
/// @param ...
function __VinylPatternRandom(_sources) constructor
{
    __VINYL_PATTERN_COMMON
    __instanceConstructor = __VinylInstanceRandom;
    
    __sources               = _sources;
    __allowRepeat           = (array_length(__sources) <= 2);
    __globalLastIndexPlayed = undefined;
    
    
    
    #region Public Methods
    
    static AllowRepeatSet = function(_state)
    {
        __allowRepeat = _state;
        
        return self;
    }
    
    static AllowRepeatGet = function()
    {
        return __allowRepeat;
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static toString = function()
    {
        return "Random " + string(__sources);
    }
    
    #endregion
    
    
    
    if (VINYL_DEBUG) __VinylTrace("Created pattern ", self);
}