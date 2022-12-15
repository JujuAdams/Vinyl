/// @param sound
/// @param [loops=false]
/// @param [gain=+0db]
/// @param [freq=1]

function VinylPlay(_sound, _loops = false, _gain = 0, _freq = 1)
{
	var _id = __VinylDepoolInstance();
	global.__vinylIdToInstanceDict[? _id].__Play(_sound, _loops, _gain, _freq);
	return _id;
}