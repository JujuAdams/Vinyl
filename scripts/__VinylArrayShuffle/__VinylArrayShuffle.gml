// Feather disable all
function __VinylArrayShuffle(_array)
{
    array_sort(_array, function()
    {
        return sign(__VinylRandom(2) - 1);
    });
}
