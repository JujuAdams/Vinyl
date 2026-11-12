/// Tracks the progress of a voice and provides an interface for tracking beats relative to the
/// playing time for the voice.
/// 
/// @param voice
/// @param bpm
/// @param beginOnBeat

function VinylLogicBPM(_voice, _bpm, _beginOnBeat) : VinylLogicParentConstructor(false) constructor
{
    __voice = _voice;
    __bpm   = _bpm;
    
    __beatThisStep = _beginOnBeat;
    __beatIndex    = 0;
    __beatDistance = 0;
    
    array_push(__VinylSystem().__strongUpdateArray, function()
    {
        //Self-destruct if the sound is no longer playing
        if (VinylGetStopped(__voice))
        {
            return false;
        }
        
        if ((__bpm == undefined) || (__bpm <= 0))
        {
            __beatThisStep = false;
            __beatIndex    = 0;
            __beatDistance = 0;
        }
        else
        {
            var _beat = VinylGetTrackPosition(__voice) * (__bpm / 60);
            var _beatIndex = floor(_beat);
            
            __beatThisStep = (__beatIndex != _beatIndex);
            __beatIndex    = _beatIndex;
            __beatDistance = -((((_beat - _beatIndex) + 0.5) mod 1) - 0.5);
        }
        
        return true;
    });
    
    static GetVoice = function()
    {
        return __voice;
    }
    
    static GetBPM = function()
    {
        return __bpm;
    }
    
    static GetBeatThisStep = function()
    {
        return __beatThisStep;
    }
    
    static GetBeatCount = function()
    {
        return __beatIndex;
    }
    
    static GetBeatDistance = function()
    {
        return __beatDistance;
    }
    
    static GetPitchForBPM = function(_newBPM)
    {
        if ((__bpm == undefined) || (__bpm <= 0))
        {
            return 1;
        }
        else
        {
            return _newBPM / __bpm;
        }
    }
}