/// @param source
/// @param ...

function VinylQueue()
{
    switch(argument_count)
    {
        case 0: __VinylError("Unsupported number of arguments (0) for VinylQueue()\n(Should be at least 1)"); break;
        
        case 1: return new __VinylPatternQueue(argument[0]); break;
        case 2: return new __VinylPatternQueue(argument[0], argument[1]); break;
        case 3: return new __VinylPatternQueue(argument[0], argument[1], argument[2]); break;
        case 4: return new __VinylPatternQueue(argument[0], argument[1], argument[2], argument[3]); break;
        case 5: return new __VinylPatternQueue(argument[0], argument[1], argument[2], argument[3], argument[4]); break
        
        default: __VinylError("Unsupported number of arguments (", argument_count, ") for VinylQueue()\n(Please add another case to the switch statement)"); break;
    }
}

/// @param source
/// @param ...
function __VinylPatternQueue() constructor
{
    __VINYL_PATTERN_COMMON
    __instanceConstructor = __VinyInstanceQueue;
    
    __sources = array_create(argument_count, undefined);
    __pop     = false;
    __popLast = false;
    
    //Copy input sources into the actual array
    var _i = 0;
    repeat(argument_count)
    {
        __sources[@ _i] = __VinylPatternizeSource(argument[_i]);
        ++_i;
    }
    
    
    
    
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