/// Starts playing a sound and returns a Vinyl ID to identify the playback instance
/// 
/// @param sound
/// @param [loop]
/// @param [gain=+0db]
/// @param [pitch=1]

function VinylPlay(_sound, _loop = undefined, _gain = 0, _pitch = 1)
{
    var _id = __VinylDepoolInstance();
    global.__vinylIdToInstanceDict[? _id].__Play(_sound, _loop, _gain, _pitch);
    return _id;
}