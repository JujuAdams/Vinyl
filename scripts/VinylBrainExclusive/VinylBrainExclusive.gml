/// @param fadeTime

function VinylBrainExclusive(_fadeTime) : VinylBrainVoicedConstructor(false) constructor
{
    __fadeTime = _fadeTime;
    
    static Push = function(_voice)
    {
        if (VinylGetAllStopped(_voice)) return;
        
        VinylFadeOut(__voice, __fadeTime);
        __voice = _voice;
        
        return self;
    }
}