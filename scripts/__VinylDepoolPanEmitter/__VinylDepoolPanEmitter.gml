function __VinylDepoolPanEmitter()
{
    static _id = int64(99000000);
    ++_id;
    
    static _panEmitterPool = __VinylGlobalData().__panEmitterPool;
    
    var _panEmitter = array_pop(_panEmitterPool);
    if (_panEmitter == undefined)
    {
        __VinylTrace("No pan emitters in pool, creating a new one");
        _panEmitter = new __VinylClassPanEmitter();
    }
    
    _panEmitter.__Depool(_id);
    return _panEmitter;
}