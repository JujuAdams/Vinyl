/// Autogenerated on 2024-03-18 21:41:54 by Vinyl Editor 6.0.0, 2024-03-14

function __VinylGenPlay()
{
    static _data = undefined;
    
    if (_data == undefined)
    {
        _data = {};
        
        struct_set_from_hash(_data, vinFootsteps, function(_loop, _gainLocal, _pitchLocal)
        {
            static _soundArray = [sndBleep0, sndBleep1, sndBleep2, sndBleep3];
            static _playIndex = infinity;
            
            if (_playIndex >= 4)
            {
                _playIndex = 0;
                var _last = _soundArray[3];
                array_delete(_soundArray, 3, 1);
                __VinylArrayShuffle(_soundArray);
                array_insert(_soundArray, 2, _last);
                
                show_debug_message(_soundArray);
            }
            
            var _sound = _soundArray[_playIndex];
            ++_playIndex;
            
            var _gainPattern  = __VinylRandomRange(0.74, 1.11);
            var _pitchPattern = 1;
            var _voice = audio_play_sound(_sound, 0, false, _gainLocal*_gainPattern, 0, _pitchLocal*_pitchPattern);
            
            if (VINYL_LIVE_EDIT)
            {
                __VinylVoiceTrack(_voice, _gainLocal, _pitchLocal, _gainPattern, _pitchPattern).__pattern = vinrhrht;
            }
            else
            {
                __VinylVoiceTrack(_voice, _gainLocal, _pitchLocal, _gainPattern, _pitchPattern);
            }
            
            return _voice;
        });

        struct_set_from_hash(_data, vinrhrht, function(_loop, _gainLocal, _pitchLocal)
        {
            return -1;
        });

    }
    
    return _data;
}

