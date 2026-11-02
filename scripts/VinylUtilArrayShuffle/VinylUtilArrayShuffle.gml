/// Utility function that shuffles an array without using GameMaker's native PRNG. As such,
/// shuffling an array using this function won't impact procedural generation (etc.) which uses
/// GameMaker's native random functions.
/// 
/// @param array

function VinylUtilArrayShuffle(_array)
{
    var _i = array_length(_array) - 1;
    repeat(_i)
    {
        var _index = VinylUtilIRandom(_i);
        
        var _oldValue = _array[_index];
        _array[@ _index] = _array[_i];
        _array[@ _i    ] = _oldValue;
        
        --_i;
    }
}