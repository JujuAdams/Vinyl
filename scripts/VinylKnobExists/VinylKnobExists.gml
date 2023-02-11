/// @param name

function VinylKnobExists(_name)
{
    static _globalData = __VinylGlobalData();
    return is_struct(_globalData.__knobDict[$ _name]);
}