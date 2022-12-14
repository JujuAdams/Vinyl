/// @param sound
/// @param [loops=false]
/// @param [gain=1]
/// @param [pitch=1]

function VinylPlay(_sound, _loops = false, _gain = 1, _pitch = 1)
{
    if (array_length(global.__vinylPool) > 0)
    {
        var _instance = global.__vinylPool[0];
        array_delete(global.__vinylPool, 0, 1);
    }
    else
    {
        var _instance = new __VinylClassInstance();
    }
    
    array_push(global.__vinylPlaying, _instance);
}