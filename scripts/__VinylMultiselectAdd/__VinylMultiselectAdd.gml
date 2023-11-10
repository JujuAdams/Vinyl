// Feather disable all

/// @param stateDict
/// @param resourceDict
/// @param constructor

function __VinylMultiselectAdd(_stateStruct, _resourceDict, _constructor)
{
    var _selectedDict = _stateStruct.__selectedDict;
    
    var _index = 1;
    var _newName = "Stack " + string(_index);
    while(variable_struct_exists(_resourceDict, _newName))
    {
        ++_index;
        _newName = "Stack " + string(_index);
    }
    
    _resourceDict[$ _newName] = new _constructor();
    
    if (_stateStruct.__multiselect)
    {
        _selectedDict[$ _newName] = true;
        _stateStruct.__lastSelected = _newName;
    }
    else
    {
        _stateStruct.__selectedDict = {};
        _selectedDict = _stateStruct.__selectedDict;
        
        _selectedDict[$ _newName] = true;
        _stateStruct.__lastSelected = _newName;
    }
    
    return _selectedDict;
}

function __VinylClassStackNew() constructor
{
    duckedGain = 0;
    duckRate = VINYL_DEFAULT_DUCK_GAIN_RATE;
    pauseWhenDucked = true;
}