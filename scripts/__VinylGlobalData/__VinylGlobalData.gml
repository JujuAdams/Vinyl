function __VinylGlobalData()
{
    static _struct = {
        __listenerX: 0,
        __listenerY: 0,
        
        __idToInstanceDict: ds_map_create(),
        
        __transposeSemitones: 0,
        
        __basicPoolPlaying: [],
        __basicPool:        [],
        __basicPoolReturn:  [],
        
        __emitterPool:       [],
        __emitterPoolReturn: [],
        
        __panEmitterActive:     [],
        __panEmitterPool:       [],
        __panEmitterPoolReturn: [],
    };
    
    return _struct;
}