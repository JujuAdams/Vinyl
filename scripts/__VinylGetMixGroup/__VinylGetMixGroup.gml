/// @param mixGroupIndex

function __VinylGetMixGroup(_mixGroupIndex)
{
    static _mixGroupArray = __VinylSystem().__mixGroupArray;
    if (not is_numeric(_mixGroupIndex)) return undefined;
    return ((_mixGroupIndex < 0) || (_mixGroupIndex > array_length(_mixGroupArray)-1))? undefined : _mixGroupArray[_mixGroupIndex];
}