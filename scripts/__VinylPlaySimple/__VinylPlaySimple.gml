// Feather disable all
/// @param sound
/// @param gainLo
/// @param gainHi
/// @param pitchLo
/// @param pitchHi
/// @param labelArray
/// @param effectChainName

function __VinylPlaySimple(_sound, _gainLo, _gainHi, _pitchLo, _pitchHi, _labelArray, _effectChainName)
{
    static _effectChainDict = __VinylGlobalData().__effectChainDict;
    
    var _randomGainParam = __VinylRandom(1);
    var _gain = lerp(_gainLo, _gainHi, _randomGainParam);
    
    var _randomPitchParam = __VinylRandom(1);
    var _pitch = lerp(_pitchLo, _pitchHi, _randomPitchParam);
    
    var _i = 0;
    repeat(array_length(_labelArray))
    {
        var _label = _labelArray[_i];
        
        var _gainPitch = lerp(_label.__configGainLo, _label.__configGainHi, _randomGainParam);
        _gain *= _gainPitch*_label.__gainOutput;
        var _labelPitch = lerp(_label.__configPitchLo, _label.__configPitchHi, _randomPitchParam);
        _pitch *= _labelPitch*_label.__pitchOutput;
        
        ++_i;
    }
    
    //Determine the emitter we should play this sound on
    var _effectChainStruct = _effectChainDict[$ _effectChainName];
    var _effectChainEmitter = (_effectChainStruct == undefined)? undefined : _effectChainStruct.__emitter;
    
    var _actualSound = __VinylAssetResolve(_sound);
    if (_actualSound < 0)
    {
        __VinylTrace("Warning! Could not find valid asset for sound ", (is_string(_sound)? "\"" + _sound + "\"" : _sound));
        return -1;
    }
    
    if (_effectChainEmitter == undefined)
    {
        var _instance = audio_play_sound(_actualSound, 1, false, __VinylCurveAmplitude(_gain), 0, _pitch);
    }
    else
    {
        var _instance = audio_play_sound_on(_effectChainEmitter, _actualSound, false, 1, __VinylCurveAmplitude(_gain), 0, _pitch);
    }
    
    if (VINYL_DEBUG_LEVEL >= 1)
    {
        __VinylTrace("Playing ", VinylAssetGetName(_actualSound), ", gain=", _gain, ", pitch=", _pitch, ", effect chain=", _effectChainName, ", label=", __VinylDebugLabelNames(__labelArray), " (GMinst=", _instance, ")");
    }
    
    return _instance;
}
