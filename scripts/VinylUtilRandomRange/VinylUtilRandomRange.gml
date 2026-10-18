/// @param min
/// @param max

function VinylUtilRandomRange(_min, _max)
{
    return _min + VinylUtilRandom(_max - _min);
}