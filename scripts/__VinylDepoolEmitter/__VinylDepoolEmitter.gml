function __VinylDepoolEmitter()
{
    static _emitterPool = __VinylGlobalData().__emitterPool;
    
    var _emitter = array_pop(_emitterPool);
    if (_emitter == undefined)
    {
        __VinylTrace("No emitters in pool, creating a new one");
        _emitter = audio_emitter_create();
    }
    
    return _emitter;
}