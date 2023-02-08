function __VinylDepoolEmitter()
{
    static _id = int64(98000000);
    ++_id;
    
    static _emitterPool = __VinylGlobalData().__emitterPool;
    
    var _emitter = array_pop(_emitterPool);
    if (_emitter == undefined)
    {
        __VinylTrace("No emitters in pool, creating a new one");
        _emitter = new __VinylClassEmitter();
    }
    
    _emitter.__Depool(_id);
    return _emitter;
}