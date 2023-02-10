/// @param name

function __VinylEffectChainGetBus(_name)
{
    static _effectChainDict = __VinylGlobalData().__effectChainDict;
    
    var _effectChainStruct = _effectChainDict[$ _name];
    return (_effectChainStruct == undefined)? audio_bus_main : _effectChainStruct.__bus;
}