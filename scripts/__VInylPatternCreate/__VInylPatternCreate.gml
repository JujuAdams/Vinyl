/// @param name
/// @param data
/// @param adHoc

function __VInylPatternCreate(_patternName, _patternData, _adHoc)
{
    if (!variable_struct_exists(_patternData, "type")) __VinylError("Pattern \"", _patternName, "\" doesn't have a \"type\" property");
    
    var _constructor = __VinylConvertPatternNameToConstructor(_patternName, _patternData.type);
    var _newPattern = new _constructor(_patternName, _adHoc);
    _newPattern.__Initialize(_patternData);
    _newPattern.__Store();
    
    return _newPattern;
}