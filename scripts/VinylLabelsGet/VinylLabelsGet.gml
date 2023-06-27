/// Returns an array of labels for the given voice/pattern/asset
/// 
///   N.B. Do not edit this array! Doing so will lead to undefined behaviour
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param voice/pattern/asset

function VinylLabelsGet(_id)
{
    static _globalData = __VinylGlobalData();
    static _idToVoiceDict = _globalData.__idToVoiceDict;
    
    var _voice = _idToVoiceDict[? _id];
    if (is_struct(_voice)) return _voice.__labelArray;
    
    var _pattern = __VinylPatternGet(_id);
    if (is_struct(_pattern)) return _pattern.__labelArray;
}