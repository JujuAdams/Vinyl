/// @param min
/// @param max

function VinylRandomRange(_min, _max)
{
    return _min + VinylRandom(_max - _min);
}