/// @param sound
/// @param [loops=false]
/// @param [gain=+0db]
/// @param [freqCoeff=1]

function VinylPlay(_sound, _loops = false, _gain = 0, _freqCoeff = 1)
{
	var _id = __VinylDepoolInstance();
	global.__vinylInstanceIDs[? _id].__Play(_sound, _loops, _gain, _freqCoeff);
	return _id;
}