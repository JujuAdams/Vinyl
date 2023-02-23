/// @param name
/// @param dataStruct

function VinylAdHocPattern(_name, _dataStruct)
{
    static _globalData = __VinylGlobalData();
    
    if (!variable_struct_exists(_dataStruct, "type")) __VinylError("Data struct doesn't have a \"type\" property");
    
    var _struct = (__VinylConvertPatternNameToConstructor(_name, _dataStruct[$ "type"]))(_name, true);
    _struct.__Initialize(_dataStruct, undefined, _globalData.__labelDict);
    
    return _struct;
}