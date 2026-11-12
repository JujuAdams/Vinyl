/// Returns an array of voices currently being played. This will flatten arrays (i.e. remove any
/// array nesting). Where this is most useful is to return all voices being played by a logic.
/// 
/// @param voiceOrArray
/// @param [resultArray]

function VinylGetFlatVoiceArray(_voiceOrArray, _resultArray = [])
{
    if (is_array(_voiceOrArray))
    {
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            VinylGetFlatVoiceArray(_voiceOrArray[_i], _resultArray);
            ++_i;
        }
    }
    else if (is_struct(_voiceOrArray))
    {
        _voiceOrArray.ImplGetFlatVoiceArray(_resultArray);
    }
    else if (_voiceOrArray != undefined)
    {
        array_push(_resultArray, _voiceOrArray);
    }
    
    return _resultArray;
}