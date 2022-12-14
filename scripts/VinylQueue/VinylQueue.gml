/// @param source
/// @param ...

function VinylQueue()
{
    __VINYL_COLLECT_ARGUMENTS_INTO_SOURCE_ARRAY
    return new __VinylPatternQueue(_argumentArray);
}

/// @param source
/// @param ...
function __VinylPatternQueue(_sources) constructor
{
    __VINYL_PATTERN_COMMON
    __instanceConstructor = __VinylInstanceQueue;
    
    __sources = _sources;
    __pop     = false;
    __popLast = false;
    
    
    
    #region Public Methods
    
    static PopSet = function(_pop, _popLast = _pop)
    {
        __pop     = _pop;
        __popLast = _popLast;
        return self;
    }
    
    static PopGet = function()
    {
        return {
            pop:     __pop,
            popLast: __popLast,
        };
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static toString = function()
    {
        return "Queue " + string(__sources);
    }
    
    #endregion
    
    
    
    if (VINYL_DEBUG) __VinylTrace("Created pattern ", self);
}