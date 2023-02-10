/// @param name

function __VinylEffectChainGetEmitter(_name)
{
    static _effectChainDict = __VinylGlobalData().__effectChainDict;
    
    var _effectChainStruct = _effectChainDict[$ _name];
    return (_effectChainStruct == undefined)? undefined : _effectChainStruct.__emitter;
}