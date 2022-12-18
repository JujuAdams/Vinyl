function __VinylTick()
{
    //Move instances returning to the pool back into the pool
    var _returnSize = array_length(global.__vinylPoolReturn);
    if (_returnSize > 0)
    {
        var _poolSize = array_length(global.__vinylPool);
        array_resize(global.__vinylPool, _poolSize + _returnSize);
        array_copy(global.__vinylPool, _poolSize, global.__vinylPoolReturn, 0, _returnSize);
        array_resize(global.__vinylPoolReturn, 0);
        
        if (VINYL_DEBUG) __VinylTrace("Returned ", _returnSize, " instance(s) to pool, ", _poolSize + _returnSize, " instances now in pool");
    }
    
    //Update labels
    var _i = 0;
    repeat(array_length(global.__vinylLabelOrder))
    {
        global.__vinylLabelOrder[_i].__Tick();
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
            _instance.__Tick();
            ++_i;
        }
    }
}