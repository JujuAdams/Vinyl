/// @param name

function __VinylEffectChainGetEmitter(_name)
{
    static _effectChainDict = __VinylGlobalData().__effectChainDict;
    
    var _busStruct = _effectChainDict[$ _name];
    return (_busStruct == undefined)? undefined : _busStruct.__emitter;
}