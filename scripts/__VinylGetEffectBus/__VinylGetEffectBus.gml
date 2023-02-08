/// @param name

function __VinylGetEffectBus(_name)
{
    static _effectBusDict = __VinylGlobalData().__effectBusDict;
    
    var _busStruct = _effectBusDict[$ _name];
    return (_busStruct == undefined)? audio_bus_main : _busStruct.__bus;
}