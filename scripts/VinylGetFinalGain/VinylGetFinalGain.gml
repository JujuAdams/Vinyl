// Feather disable all

/// Returns the final output gain for a voice. This value will include the correction made for
/// `VINYL_MAX_VOICE_GAIN`. For example, if you set the maximum voice gain to `2` then the final
/// gain for voices will be halved to accommodate the greater gain range. If the voice doesn't
/// exist, this function will return `0`.
/// 
/// @param voice

function VinylGetFinalGain(_voice)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    if (_voiceStruct == undefined)
    {
        return ((_voice != undefined) && (real(_voice) < 0xFF00_0000_0000))? audio_sound_get_gain(_voice) : 0;
    }
    else
    {
        return _voiceStruct.__GetFinalGain();
    }
}