// Feather disable all

/// Sets the local gain for a voice. This is multipled with the sound/pattern gain set by the
/// corresponding setup function, the mix gain (if a mix is set for the voice), and the fade-out
/// gain to give the final playback gain for the voice.
/// 
/// @param voice
/// @param gain
/// @param [rateOfChange]

function VinylSetGain(_voice, _gain, _rateOfChange = infinity)
{
    static _voiceLookUpDict = __VinylSystem().__voiceLookUpDict;
    
    var _voiceStruct = struct_get_from_hash(_voiceLookUpDict, int64(_voice));
    if (_voiceStruct == undefined)
    {
        var _time = (game_get_speed(gamespeed_microseconds)/1000) * ((_gain - audio_sound_get_gain(_voice)) / _rateOfChange);
        return audio_sound_gain(_voice, _gain, _time);
    }
    else
    {
        return _voiceStruct.__SetLocalGain(max(0, _gain), max(0.001, _rateOfChange));
    }
}