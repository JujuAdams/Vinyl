// Feather disable all

/// Returns the final output pitch for a voice. If the voice doesn't exist then this function will
/// return `1`.
/// 
/// @param voice

function VinylGetFinalPitch(_voice)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    if (_voiceStruct == undefined)
    {
        return ((_voice != undefined) && (real(_voice) < __VINYL_ABSTRACT_VOICE))? audio_sound_get_pitch(_voice) : 1;
    }
    else
    {
        return _voiceStruct.__GetFinalPitch();
    }
}