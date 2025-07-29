// Feather disable all

/// @param voice

function VinylGetEmitter(_voice)
{
    static _voiceToStructMap  = __VinylSystem().__voiceToStructMap;
    static _voiceToEmitterMap = __VinylSystem().__voiceToEmitterMap;
    
    var _emitter = _voiceToEmitterMap[? _voice];
    if (_emitter != undefined)
    {
        return _emitter;
    }
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    if (_voiceStruct != undefined)
    {
        return _voiceStruct.__GetEmitter();
    }
    
    return undefined;
}