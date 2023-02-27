/// @param name
/// @param priority

function VinylStackGet(_name, _priority)
{
    static _globalData = __VinylGlobalData();
    
    var _stack = _globalData.__stackDict[$ _name];
    if (!is_struct(_stack))
    {
        __VinylTrace("Warning! Stack \"", _name, "\" not recognised");
        return;
    }
    
    return _stack.__Get(_priority);
}