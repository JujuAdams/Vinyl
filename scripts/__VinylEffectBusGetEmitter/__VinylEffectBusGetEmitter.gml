/// @param name

function __VinylEffectBusGetEmitter(_name)
{
    static _effectBusDict = __VinylGlobalData().__effectBusDict;
    
    var _busStruct = _effectBusDict[$ _name];
    return (_busStruct == undefined)? undefined : _busStruct.__emitter;
}