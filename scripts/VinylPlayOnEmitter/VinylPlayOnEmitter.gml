/// Starts playing a sound and returns a Vinyl ID to identify the playback instance
/// 
/// Vinyl IDs are separate from GameMaker's native audio instances IDs and the two sets of
/// IDs cannot be used interchangeably
/// 
/// There is a perfomance overhead when creating and maintaining Vinyl audio instances. In
/// resource-constrained situations, you may want to consider using VinylPlaySimple() for some
/// of your audio
/// 
/// @param emitter
/// @param sound
/// @param [loop]
/// @param [gain=1]
/// @param [pitch=1]

function VinylPlayOnEmitter(_emitter, _sound, _loop = undefined, _gain = 1, _pitch = 1)
{
    static _idToInstanceDict = __VinylGlobalData().__idToInstanceDict;
    
    var _id = __VinylDepoolInstance();
    
    _idToInstanceDict[? _id].__PlayOnEmitter(_emitter, _sound, _loop, _gain, _pitch);
    
    return _id;
}