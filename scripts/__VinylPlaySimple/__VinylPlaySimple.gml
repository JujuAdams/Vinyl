/// @param sound
/// @param gain
/// @param pitchLo
/// @param pitchHi
/// @param labelArray

function __VinylPlaySimple(_sound, _gain, _pitchLo, _pitchHi, _labelArray)
{
    var _randomPitchParam = __VinylRandom(1);
    var _pitch = lerp(_pitchLo, _pitchHi, _randomPitchParam);
    
    var _i = 0;
    repeat(array_length(_labelArray))
    {
        var _label = _labelArray[_i];
        
        _gain *= _label.__gainOutput;
        var _labelPitch = lerp(_label.__configPitchLo, _label.__configPitchHi, _randomPitchParam);
        _pitch *= _labelPitch*_label.__pitchOutput;
        
        ++_i;
    }
    
    var _instance = audio_play_sound(_sound, 1, false, __VinylCurveAmplitude(_gain), 0, _pitch);
    
    if (VINYL_DEBUG_LEVEL >= 1)
    {
        __VinylTrace("Playing ", audio_get_name(_sound), ", gain=", _gain, ", pitch=", _pitch, ", label=", __VinylDebugLabelNames(__labelArray), " (GMinst=", _instance, ")");
    }
    
    return _instance;
}