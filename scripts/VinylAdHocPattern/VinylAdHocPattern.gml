/// @param name
/// @param dataStruct

function VinylAdHocPattern(_name, _dataStruct)
{
    static _globalData = __VinylGlobalData();
    
    if (!variable_struct_exists(_dataStruct, "type"))
    {
        __VinylError("Data struct doesn't have a \"type\" property");
    }
    else
    {
        var _type = _dataStruct[$ "type"];
        if (_type == "basic")
        {
            var _struct = new __VinylClassPatternBasic(_name, true);
        }
        else if (_type == "shuffle")
        {
            var _struct = new __VinylClassPatternShuffle(_name, true);
        }
        else if (_type == "queue")
        {
            var _struct = new __VinylClassPatternQueue(_name, true);
        }
        else if (_type == "multi")
        {
            var _struct = new __VinylClassPatternMulti(_name, true);
        }
        else
        {
            __VinylError("Pattern type \"", _type, "\" not recognised");
        }
    }
    
    _struct.__Initialize(_dataStruct, undefined, _globalData.__labelDict);
    
    return _struct;
}