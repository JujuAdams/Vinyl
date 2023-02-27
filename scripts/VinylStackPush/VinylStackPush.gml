/// @param name
/// @param priority
/// @param vinylID

function VinylStackPush(_name, _priority, _instance)
{
    static _globalData = __VinylGlobalData();
    
    var _stack = _globalData.__stackDict[$ _name];
    if (!is_struct(_stack))
    {
        __VinylTrace("Warning! Stack \"", _name, "\" not recognised");
        return;
    }
    
    return _stack.__Push(_priority, _instance);
}