// Feather disable all

function __VinylClassVolatileEmitter(_x, _y, _z) constructor
{
    static _volatileEmitterArray = __VinylSystem().__volatileEmitterArray;
    
    array_push(_volatileEmitterArray, self);
    
    __x = _x;
    __y = _y;
    __z = _z;
    
    __emitter = audio_emitter_create();
    audio_emitter_position(__emitter, _x, _y, _z);
    
    __voice = undefined;
}