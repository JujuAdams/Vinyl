// Feather disable all

/// @param emitter
/// @param alias

function VinylRegisterEmitter(_emitter, _alias)
{
    static _emitterMap = __VinylSystem().__emitterMap;
    
    _emitterMap[? _alias] = _emitter;
}