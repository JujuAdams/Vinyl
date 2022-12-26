/// Starts playing a sound and returns a Vinyl ID to identify the playback instance
/// Vinyl IDs are separate from GameMaker's native audio instances IDs and the two sets of
/// IDs cannot be used interchangeably
/// 
/// There is a perfomance overhead when creating and maintaining Vinyl audio instances. In
/// resource-constrained situations, you may want to consider using VinylPlaySimple() for some
/// of your audio
/// 
/// @param sound
/// @param [loop]
/// @param [gain=0dB]
/// @param [pitch=100%]

function VinylPlay(_sound, _loop = undefined, _gain = 0, _pitch = 100)
{
    var _id = __VinylDepoolInstance();
    global.__vinylIdToInstanceDict[? _id].__Play(_sound, _loop, _gain, _pitch);
    return _id;
}