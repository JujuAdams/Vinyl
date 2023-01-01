function __VinylDepoolEmitter()
{
    var _emitter = array_pop(global.__vinylEmitterPool);
    if (_emitter == undefined)
    {
        __VinylTrace("No emitters in pool, creating a new one");
        _emitter = audio_emitter_create();
    }
    
    return _emitter;
}