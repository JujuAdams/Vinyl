/// @param name

function __VinylGetEffectBus(_name)
{
    var _busStruct = __effectBusDict[$ _name];
    return (_busStruct == undefined)? audio_bus_main : _busStruct.__bus;
}