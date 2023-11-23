// Feather disable all

function __VinylCompiledSoundArrayEnsure()
{
    static _array = __VinylGlobalData().__compiledSoundArray;
    
    //Build an array of all audio asset names on demand
    if (array_length(_array) <= 0)
    {
        var _j = 0;
        repeat(1000000)
        {
            if (not audio_exists(_j)) break;
            array_push(_array, audio_get_name(_j));
            ++_j;
        }
    }
    
    return _array;
}