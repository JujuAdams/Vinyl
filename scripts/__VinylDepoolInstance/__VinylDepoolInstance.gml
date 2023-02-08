function __VinylDepoolInstance()
{
    static _id = int64(97000000);
    ++_id;
    
    static _basicPool = __VinylGlobalData().__basicPool;
    
    var _instance = array_pop(_basicPool);
    if (_instance == undefined)
    {
        __VinylTrace("No instances in pool, creating a new one");
        _instance = new __VinylClassBasicInstance();
    }
    
    _instance.__Depool(_id);
    return _id;
}