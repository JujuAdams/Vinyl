/// @param sound
/// @param [loop=false]
/// @param [gain=+0db]
/// @param [freq=1]

function VinylPlay(_sound, _loop = false, _gain = 0, _freq = 1)
{
	var _id = __VinylDepoolInstance();
	global.__vinylIdToInstanceDict[? _id].__Play(_sound, _loop, _gain, _freq);
	return _id;
}