/// Returns the sound asset being used for a voice. If an array of voices is provided then this
/// function will return an array of assets, one for each voice.
/// 
/// @param voice

function VinylGetAsset(_voiceOrArray)
{
    if (is_array(_voiceOrArray))
    {
        var _array = array_create(array_length(_voiceOrArray));
        
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            _array[@ _i] = VinylGetAsset(_voiceOrArray[_i]);
            ++_i;
        }
        
        return _array;
    }
    else if (is_struct(_voiceOrArray))
    {
        return _voiceOrArray.ImplGetAsset();
    }
    else if (_voiceOrArray != undefined)
    {
        if (audio_is_playing(_voiceOrArray))
        {
            return audio_sound_get_asset(_voiceOrArray);
        }
    }
    
    return undefined;
}