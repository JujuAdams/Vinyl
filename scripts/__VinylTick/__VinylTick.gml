function __VinylTick()
{
    var _deltaTime = (delta_time / (game_get_speed(gamespeed_fps)*game_get_speed(gamespeed_microseconds)));
    
    //Move instances returning to the pool back into the pool
    var _returnSize = array_length(global.__vinylPoolReturn);
    if (_returnSize > 0)
    {
        var _poolSize = array_length(global.__vinylBasicPool);
        array_resize(global.__vinylBasicPool, _poolSize + _returnSize);
        array_copy(global.__vinylBasicPool, _poolSize, global.__vinylPoolReturn, 0, _returnSize);
        array_resize(global.__vinylPoolReturn, 0);
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Returned ", _returnSize, " instance(s) to pool, ", _poolSize + _returnSize, " instances now in pool");
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
    repeat(array_length(global.__vinylPlaying))
    {
        var _instance = global.__vinylPlaying[_i];
        if (_instance.__pooled)
        {
            array_delete(global.__vinylPlaying, _i, 1);
        }
        else
        {
            _instance.__Tick(_deltaTime);
            ++_i;
        }
    }
}