function __VinylCheckExclusivity(_sound)
{
    //Pre-check for label exclusivity
    //This stops us from depooling an instance if we cannot play it
    var _asset = global.__vinylAssetDict[$ _sound] ?? global.__vinylAssetDict.fallback;
    if (is_struct(_asset))
    {
        var _labelArray = _asset.__labelArray;
        var _i = 0;
        repeat(array_length(_labelArray))
        {
            if (!_labelArray[_i].__CheckExclusivity()) return false;
            ++_i;
        }
    }
    
    return true;
}