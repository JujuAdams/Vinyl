// Feather disable all

/// @param x
/// @param y
/// @param z
/// @param effectBus

function __VinylClassVolatileEmitter(_x, _y, _z, _effectBus) constructor
{
    static _volatileEmitterArray = __VinylSystem().__volatileEmitterArray;
    
    array_push(_volatileEmitterArray, self);
    
    __x = _x;
    __y = _y;
    __z = _z;
    
    __emitter = audio_emitter_create();
    audio_emitter_position(__emitter, _x, _y, _z);
    
    if (_effectBus != undefined)
    {
        audio_emitter_bus(__emitter, _effectBus);
    }
    
    __voice = undefined;
}