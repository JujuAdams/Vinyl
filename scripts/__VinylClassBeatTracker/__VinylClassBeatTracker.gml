// Feather disable all

/// @param voice
/// @param voiceStruct

function __VinylClassBeatTracker(_voice, _voiceStruct) constructor
{
    static _voiceToTrackerMap = __VinylSystem().__voiceToTrackerMap;
    
    __voice       = _voice;
    __voiceStruct = _voiceStruct;
    
    __beatThisStep = false;
    __beatIndex    = 0;
    __beatDistance = 0;
    
    
    
    __timeSource = time_source_create(time_source_global, 1, time_source_units_frames, function()
    {
        var _voiceStruct = __voiceStruct;
        
        //Self-destruct if the sound is no longer playing
        if (not _voiceStruct.__IsPlaying())
        {
            time_source_stop(__timeSource);
            time_source_destroy(__timeSource);
            return;
        }
        
        var _bpm = _voiceStruct.__GetBPM();
        if (_bpm == undefined)
        {
            __beatThisStep = false;
            __beatIndex    = 0;
            __beatDistance = 0;
            return;
        }
        
        var _gmVoice = _voiceStruct.__GetGameMakerVoice(); //The GameMaker voice can change
        var _time = audio_sound_get_track_position(_gmVoice);
        
        var _secondsPerBeat = 60 / _bpm;
        
        var _beat = _time / _secondsPerBeat;
        var _beatIndex = floor(_beat);
        
        __beatThisStep = (__beatIndex != _beatIndex);
        __beatIndex    = _beatIndex;
        __beatDistance = -((((_beat - _beatIndex) + 0.5) mod 1) - 0.5);
        
    },
    [], -1);
    
    time_source_start(__timeSource);
}