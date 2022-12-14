/// @param vinylID

function VinylStop(_id)
{
	var _instance = global.__vinylInstances[? _id];
	if (_instance == undefined) return;
    return _instance.__Stop();
}