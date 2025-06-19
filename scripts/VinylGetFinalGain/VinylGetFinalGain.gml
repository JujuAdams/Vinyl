// Feather disable all

/// Returns the final output gain for a voice.
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