// Feather disable all

/// Returns the track position for a Vinyl voice, in seconds. This will return the underlying
/// track position for the currently playing GameMaker voice and will not, for example, track how
/// long a looping sound has been playing or how far into an HLT voice playback is. If you target a
/// Blend pattern then the track position will be returned for the audio playing for index 0.
///
/// @param voice

function VinylGetTrackPosition(_voice)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    if ((_voice == undefined) || ((_voice <= 0xFFFFFFFF) && (not audio_is_playing(_voice))))
    {
        return 0;
    }
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    return (_voiceStruct == undefined)? audio_sound_get_track_position(_voice) : _voiceStruct.__GetTrackPosition();
}