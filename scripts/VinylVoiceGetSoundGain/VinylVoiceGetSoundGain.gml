/// @param voice

function VinylVoiceGetSoundGain(_voice)
{
    static _soundDefMap = __VinylSystem().__soundDefMap;
    
    //TODO
    
    if ((_voice == undefined) || (_voice < 0) || (not audio_is_playing(_voice)))
    {
        return 1;
    }
    
    var _soundDef = _soundDefMap[? audio_sound_get_asset(_voice)];
    return (_soundDef == undefined)? 1 : _soundDef.__gain;
}