function __VinylDepoolInstance()
{
    static _id = int64(99000000);
    ++_id;
    
    var _instance = array_pop(global.__vinylBasicPool);
    if (_instance == undefined)
    {
        __VinylTrace("No instances in pool, creating a new one");
        _instance = new __VinylClassBasicInstance();
    }
    
    _instance.__Depool(_id);
    return _id;
}