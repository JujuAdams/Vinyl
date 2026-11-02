/// Utility function that returns a random number between `min` and `max` without using GameMaker's
/// native PRNG. As such, shuffling an array using this function won't impact procedural generation
/// (etc.) which uses GameMaker's native random functions. `value` must be a positive integer.
/// 
/// @param min
/// @param max

function VinylUtilRandomRange(_min, _max)
{
    return _min + VinylUtilRandom(_max - _min);
}