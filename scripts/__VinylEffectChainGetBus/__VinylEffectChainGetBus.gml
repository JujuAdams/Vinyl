/// @param name

function __VinylEffectChainGetBus(_name)
{
    static _effectChainDict = __VinylGlobalData().__effectChainDict;
    
    var _busStruct = _effectChainDict[$ _name];
    return (_busStruct == undefined)? audio_bus_main : _busStruct.__bus;
}