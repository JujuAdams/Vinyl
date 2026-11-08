/// Constructor. Creates a struct that can be used to control overlapping audio. This struct will
/// automatically stop a previous voice stored by the struct when a new voice is played and pushed
/// to the struct. If a fade time has been set then the old voice will be faded out (using
/// `VinylFadeOut()`).
/// 
/// Example:
///     ///Create Event
///     brain = new VinylBrainExclusive();
/// 
///     ///Step Event
///     if (keyboard_check_pressed(vk_space))
///     {
///         //The incoming voice will interrupt the existing voice (if one is playing)
///         brain.Push(VinylPlayOmni(sndExample));
///     }
/// 
/// Methods for this brain:
/// 
/// `.Push(voice)`
///     Pushes a voice to the brain, stopping the previous voice.
/// 
/// `.SetFadeTime(fadeTime)`
///     Sets the fade time for stopping a voice.
/// 
/// `.GetFadeTime()`
///     Returns the fade time for stopping a voice.
/// 
/// @param fadeTime

function VinylBrainExclusive(_fadeTime) : VinylBrainVoicedConstructor(false) constructor
{
    __fadeTime = max(0, _fadeTime);
    
    static Push = function(_voice)
    {
        if (VinylGetStopped(_voice)) return;
        
        VinylFadeOut(__voice, __fadeTime);
        __voice = _voice;
        
        return self;
    }
    
    static SetFadeTime = function(_fadeTime)
    {
        __fadeTime = max(0, _fadeTime);
    }
    
    static GetFadeTime = function()
    {
        return __fadeTime;
    }
}