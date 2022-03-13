/// @param source

function VinylLoop(_source)
{
    return new __VinylPatternLoop(_source);
}



/// @param intro
/// @param loop
/// @param outro
function __VinylPatternLoop(_source) constructor
{
    __VINYL_PATTERN_COMMON
    __instanceConstructor = __VinyInstanceLoop;
    
    __source = __VinylPatternizeSource(_source);
    
    
    
    #region Public Methods
    
    static SourceGet = function()
    {
        return __source;
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static toString = function()
    {
        return "Loop [ " + string(__source) + " ]";
    }
    
    #endregion
    
    
    
    if (VINYL_DEBUG) __VinylTrace("Created pattern ", self);
}