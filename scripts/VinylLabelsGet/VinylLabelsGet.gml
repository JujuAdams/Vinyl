/// Returns an array of labels for the given voice/pattern/asset
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param voice/pattern/asset

function VinylLabelsGet(_id)
{
    static _globalData = __VinylGlobalData();
    static _idToVoiceDict = _globalData.__idToVoiceDict;
    
    static _funcUnpackArray = function(_labelArray)
    {
        var _size = array_length(_labelArray);
        var _result = array_create(_size, undefined);
        
        var _i = 0;
        repeat(_size)
        {
            _result[@ _i] = _labelArray[_i].__name;
            ++_i;
        }
        
        return _result;
    }
    
    var _voice = _idToVoiceDict[? _id];
    if (is_struct(_voice)) return _funcUnpackArray(_voice.__labelArray);
    
    var _pattern = __VinylPatternGet(_id);
    if (is_struct(_pattern)) return _funcUnpackArray(_pattern.__labelArray);
    
    __VinylError("Given value cannot be resolved, must be a voice/pattern/asset (value=", _id, ")");
}