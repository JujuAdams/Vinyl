/// @param labelName

function VinylLabelInstancesGet(_id)
{
	var _label = global.__vinylLabelDict[$ _id];
	return is_struct(_label)? _label.__audioArray : [];
}