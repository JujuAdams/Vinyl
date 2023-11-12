// Feather disable all

/// @param sourceStruct
/// @param selectionHandler
/// @param forceLookupDict
/// @param variableNameArray

function __VinylEditorApply(_sourceStruct, _selectionHandler, _forceLookupDict, _variableNameArray)
{
    _selectionHandler.__ForEachSelected(method(
    {
        __sourceStruct:      _sourceStruct,
        __forceLookupDict:   _forceLookupDict,
        __variableNameArray: _variableNameArray,
    },
    function(_name, _destination)
    {
        if (__forceLookupDict != undefined)
        {
            _destination = __forceLookupDict[$ _name];
        }
        
        var _variableNameArray = __variableNameArray;
        var _i = 0;
        repeat(array_length(_variableNameArray))
        {
            var _variableName = _variableNameArray[_i];
            _destination[$ _variableName] = variable_clone(__sourceStruct[$ _variableName]);
            ++_i;
        }
    }));
}