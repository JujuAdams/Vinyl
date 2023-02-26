/// Returns the loop state of a Vinyl instance
/// 
/// This function will return <undefined> if passed a label name as labels cannot have a "loop"
/// state in themselves. This function will further return <undefined> for audio played using
/// VinylPlaySimple()
/// 
/// @param vinylID

function VinylLoopGet(_id)
{
    static _idToInstanceDict = __VinylGlobalData().__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__LoopGet();
}