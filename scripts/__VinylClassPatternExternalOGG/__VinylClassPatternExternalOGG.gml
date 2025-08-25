// Feather disable all

/// @param path
/// @param patternName
/// @param sound
/// @param gain
/// @param pitch
/// @param loop
/// @param mix
/// @param ducker
/// @param duckPriority
/// @param emitterAlias
/// @param metadata

function __VinylClassPatternExternalOGG(_path, _patternName, _sound, _gain, _pitch, _loop, _mixName, _duckerName, _duckPrio, _emitterAlias, _metadata) : __VinylClassPatternExternal(_path, _patternName, _sound, _gain, _pitch, _loop, _mixName, _duckerName, _duckPrio, _emitterAlias, _metadata) constructor
{
    static __Free = function()
    {
        //FIXME - Call this at some point
        //        Don't forget to also clean up voices that use this pattern
        
        if (__sound != undefined)
        {
            audio_destroy_stream(__sound);
            __sound = undefined;
        }
    }
}