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
        __FreeCommon();
        
        if (__sound != undefined)
        {
            audio_destroy_stream(__sound);
            __sound = undefined;
        }
    }
}