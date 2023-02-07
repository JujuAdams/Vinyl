/// Starts playing a sound and returns a Vinyl ID to identify the playback instance
/// 
/// Vinyl IDs are separate from GameMaker's native audio instances IDs and the two sets of
/// IDs cannot be used interchangeably
/// 
/// There is a perfomance overhead when creating and maintaining Vinyl audio instances. In
/// resource-constrained situations, you may want to consider using VinylPlaySimple() for some
/// of your audio
/// 
/// @param sound
/// @param [loop]
/// @param [gain=1]
/// @param [pitch=1]
/// @param [pan]

function VinylPlay(_sound, _loop = undefined, _gain = 1, _pitch = 1, _pan)
{
    static _idToInstanceDict = __VinylGlobalData().__idToInstanceDict;
    
    var _id = __VinylDepoolInstance();
    
    if (_pan == undefined)
    {
        _idToInstanceDict[? _id].__Play(_sound, _loop, _gain, _pitch);
    }
    else
    {
        _idToInstanceDict[? _id].__PlayPan(_sound, _loop, _gain, _pitch, _pan ?? 0);
    }
    
    return _id;
}