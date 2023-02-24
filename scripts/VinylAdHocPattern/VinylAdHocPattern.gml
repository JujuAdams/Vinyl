/// @param name
/// @param dataStruct

function VinylAdHocPattern(_name, _dataStruct)
{
    static _globalData = __VinylGlobalData();
    
    if (!variable_struct_exists(_dataStruct, "type")) __VinylError("Data struct doesn't have a \"type\" property");
    
    var _constructor = __VinylConvertPatternNameToConstructor(_name, _dataStruct[$ "type"]);
    var _newPattern = new _constructor(_name, true);
    _newPattern.__Initialize(_dataStruct, undefined, _globalData.__labelDict);
    
    return _newPattern;
}