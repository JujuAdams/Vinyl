/// @param vinylID/labelName
/// @param [rate=VINYL_DEFAULT_GAIN_RATE]

function VinylFadeOut(_id, _rate = VINYL_DEFAULT_GAIN_RATE)
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__FadeOut(_rate);
    
    if (_id == undefined) return;
    
    var _label = global.__vinylLabelDict[$ _id];
    if (is_struct(_label)) return _label.__FadeOut(_rate);
}