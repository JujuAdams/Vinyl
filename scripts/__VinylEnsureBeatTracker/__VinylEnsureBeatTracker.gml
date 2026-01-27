// Feather disable all

/// @param voice
/// @param beginOnBeat

function __VinylEnsureBeatTracker(_voice, _beginOnBeat)
{
    static _nullTracker       = __VinylSystem().__nullTracker;
    static _voiceToTrackerMap = __VinylSystem().__voiceToTrackerMap;
    
    if (not VinylIsPlaying(_voice))
    {
        return _nullTracker;
    }
    
    var _voiceStruct = __VinylEnsureSoundVoice(_voice);
    
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceSound))
    {
        return _nullTracker;
    }
    
    var _trackerStruct = _voiceToTrackerMap[? _voice];
    if (_trackerStruct == undefined)
    {
        _trackerStruct = new __VinylClassBeatTracker(_voice, _voiceStruct, _beginOnBeat);
        _voiceToTrackerMap[? _voice] = _trackerStruct;
    }
    
    return _trackerStruct;
}