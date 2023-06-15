function __VinylArrayShuffle(_array)
{
    array_sort(_array, function()
    {
        return __VinylRandom(2) - 1;
    });
}