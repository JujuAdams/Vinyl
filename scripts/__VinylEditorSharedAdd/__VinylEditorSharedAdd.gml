// Feather disable all

/// @param document
/// @param resourceTypeName
/// @param constructor

function __VinylEditorSharedAdd(_document, _resourceTypeName, _constructor)
{
    var _index = 1;
    var _newName = _resourceTypeName + " " + string(_index);
    while(variable_struct_exists(_resourceDict, _newName))
    {
        ++_index;
        _newName = _resourceTypeName + " " + string(_index);
    }
    
    _resourceDict[$ _newName] = new _constructor();
    return _newName;
}