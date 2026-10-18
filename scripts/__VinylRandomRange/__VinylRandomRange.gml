/// @param min
/// @param max

function __VinylRandomRange(_min, _max)
{
    return _min + __VinylRandom(_max - _min);
}