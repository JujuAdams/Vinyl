/// @param name

function __VinylEnsureEffectBus(_name)
{
    static _globalData     = __VinylGlobalData();
    static _effectBusDict  = _globalData.__effectBusDict;
    static _effectBusArray = _globalData.__effectBusArray;
    
    var _effectBusStruct = _effectBusDict[$ _name];
    if (!is_struct(_effectBusStruct))
    {
        _effectBusStruct = new __VinylClassBus(_name);
        _effectBusDict[$ _name] = _effectBusStruct;
        array_push(_effectBusArray, _effectBusStruct);
    }
    
    return _effectBusStruct;
}