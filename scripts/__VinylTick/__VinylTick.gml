function __VinylTick()
{
    static _globalData           = __VinylGlobalData();
    static _basicPoolPlaying     = _globalData.__basicPoolPlaying;
    static _basicPool            = _globalData.__basicPool;
    static _basicPoolReturn      = _globalData.__basicPoolReturn;
    static _emitterActive        = _globalData.__emitterActive;
    static _emitterPool          = _globalData.__emitterPool;
    static _emitterPoolReturn    = _globalData.__emitterPoolReturn;
    static _panEmitterPool       = _globalData.__panEmitterPool;
    static _panEmitterPoolReturn = _globalData.__panEmitterPoolReturn;
    static _effectChainArray     = _globalData.__effectChainArray;
    
    var _deltaTime = (delta_time / (game_get_speed(gamespeed_fps)*game_get_speed(gamespeed_microseconds)));
    
    //Move instances returning to the pool back into the pool
    var _returnSize = array_length(_basicPoolReturn);
    if (_returnSize > 0)
    {
        var _poolSize = array_length(_basicPool);
        array_resize(_basicPool, _poolSize + _returnSize);
        array_copy(_basicPool, _poolSize,_basicPoolReturn, 0, _returnSize);
        array_resize(_basicPoolReturn, 0);
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Returned ", _returnSize, " instance(s) to pool, ", _poolSize + _returnSize, " instances now in pool");
    }
    
    //Move emitters returning to the pool back into the pool
    var _returnSize = array_length(_emitterPoolReturn);
    if (_returnSize > 0)
    {
        var _poolSize = array_length(_emitterPool);
        array_resize(_emitterPool, _poolSize + _returnSize);
        array_copy(_emitterPool, _poolSize, _emitterPoolReturn, 0, _returnSize);
        array_resize(_emitterPoolReturn, 0);
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Returned ", _returnSize, " emitter(s) to pool, ", _poolSize + _returnSize, " emitters now in pool");
    }
    
    //Move pan emitters returning to the pool back into the pool
    var _returnSize = array_length(_panEmitterPoolReturn);
    if (_returnSize > 0)
    {
        var _poolSize = array_length(_panEmitterPoolReturn);
        array_resize(_panEmitterPool, _poolSize + _returnSize);
        array_copy(_panEmitterPool, _poolSize, _panEmitterPoolReturn, 0, _returnSize);
        array_resize(_panEmitterPoolReturn, 0);
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Returned ", _returnSize, " pan emitter(s) to pool, ", _poolSize + _returnSize, " pan emitters now in pool");
    }
    
    //Update labels
    var _labelOrder = _globalData.__labelOrder; //Don't use a struct here because this struct can be recreated
    var _i = 0;
    repeat(array_length(_labelOrder))
    {
        _labelOrder[_i].__Tick(_deltaTime);
        ++_i;
    }
    
    //Update instances
    var _i = 0;
    repeat(array_length(_basicPoolPlaying))
    {
        var _instance = _basicPoolPlaying[_i];
        if (_instance.__pooled)
        {
            array_delete(_basicPoolPlaying, _i, 1);
        }
        else
        {
            _instance.__Tick(_deltaTime);
            ++_i;
        }
    }
    
    //Update emitters
    var _i = 0;
    repeat(array_length(_emitterActive))
    {
        var _emitter = _emitterActive[_i];
        if (_emitter.__pooled)
        {
            array_delete(_emitterActive, _i, 1);
        }
        else
        {
            _emitter.__Tick();
            ++_i;
        }
    }
}