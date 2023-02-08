/// @param name

function __VinylGetEffectBusEmitter(_name)
{
    var _busStruct = __effectBusDict[$ _name];
    return (_busStruct == undefined)? undefined : _busStruct.__emitter;
}