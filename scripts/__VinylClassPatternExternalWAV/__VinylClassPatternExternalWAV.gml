// Feather disable all

/// @param buffer
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

function __VinylClassPatternExternalWAV(_buffer, _path, _patternName, _sound, _gain, _pitch, _loop, _mixName, _duckerName, _duckPrio, _emitterAlias, _metadata) : __VinylClassPatternExternal(_path, _patternName, _sound, _gain, _pitch, _loop, _mixName, _duckerName, _duckPrio, _emitterAlias, _metadata) constructor
{
    __buffer = _buffer;
    
    
    
    static __Free = function()
    {
        __FreeCommon();
        
        if (__sound != undefined)
        {
            audio_free_buffer_sound(__sound);
            __sound = undefined;
        }
        
        if (__buffer != undefined)
        {
            buffer_delete(__buffer);
            __buffer = undefined;
        }
    }
}