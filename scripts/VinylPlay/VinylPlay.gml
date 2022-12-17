/// @param sound
/// @param [loop=false]
/// @param [gain=+0db]
/// @param [pitch=1]

function VinylPlay(_sound, _loop = false, _gain = 0, _pitch = 1)
{
	var _id = __VinylDepoolInstance();
	global.__vinylIdToInstanceDict[? _id].__Play(_sound, _loop, _gain, _pitch);
	return _id;
}