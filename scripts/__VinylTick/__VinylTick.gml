function __VinylTick()
{
    var _deltaTime = (delta_time / (game_get_speed(gamespeed_fps)*game_get_speed(gamespeed_microseconds)));
    
    //Move instances returning to the pool back into the pool
    var _returnSize = array_length(global.__vinylBasicPoolReturn);
    if (_returnSize > 0)
    {
        var _poolSize = array_length(global.__vinylBasicPool);
        array_resize(global.__vinylBasicPool, _poolSize + _returnSize);
        array_copy(global.__vinylBasicPool, _poolSize, global.__vinylBasicPoolReturn, 0, _returnSize);
        array_resize(global.__vinylBasicPoolReturn, 0);
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Returned ", _returnSize, " instance(s) to pool, ", _poolSize + _returnSize, " instances now in pool");
    }
    
    //Move emitters returning to the pool back into the pool
    var _returnSize = array_length(global.__vinylEmitterPoolReturn);
    if (_returnSize > 0)
    {
        var _poolSize = array_length(global.__vinylEmitterPool);
        array_resize(global.__vinylEmitterPool, _poolSize + _returnSize);
        array_copy(global.__vinylEmitterPool, _poolSize, global.__vinylEmitterPoolReturn, 0, _returnSize);
        array_resize(global.__vinylEmitterPoolReturn, 0);
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Returned ", _returnSize, " emitter(s) to pool, ", _poolSize + _returnSize, " emitters now in pool");
    }
    
    //Update labels
    var _i = 0;
    repeat(array_length(global.__vinylLabelOrder))
    {
        global.__vinylLabelOrder[_i].__Tick(_deltaTime);
        ++_i;
    }
    
    //Update instances
    var _i = 0;
    repeat(array_length(global.__vinylBasicPlaying))
    {
        var _instance = global.__vinylBasicPlaying[_i];
        if (_instance.__pooled)
        {
            array_delete(global.__vinylBasicPlaying, _i, 1);
        }
        else
        {
            _instance.__Tick(_deltaTime);
            ++_i;
        }
    }
    
    var _map = audio_listener_get_data(0);
    ds_map_destroy(_map);
}