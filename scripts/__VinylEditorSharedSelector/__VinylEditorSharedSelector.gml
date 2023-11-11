// Feather disable all

/// @param childID
/// @param width
/// @param height
/// @param stateStruct
/// @param resourceName
/// @param constructor
/// @param resourceDict
/// @param resourceNameArray

function __VinylEditorSharedSelector(_id, _width, _height, _stateStruct, _resourceName, _constructor, _resourceDict, _resourceNameArray)
{
    var _selectedDict = _stateStruct.__selectedDict;
    
    ImGui.BeginChild(_id, _width, _height);
        
        if (ImGui.Button("Add"))
        {
            _selectedDict = __VinylMultiselectAdd(_stateStruct, _resourceDict, _resourceName, _constructor);
        }
        
        ImGui.SameLine(undefined, 120);
        ImGui.BeginDisabled(variable_struct_names_count(_selectedDict) <= 0);
            if (ImGui.Button("Delete"))
            {
                _selectedDict = __VinylMultiselectDelete(_stateStruct, _resourceDict, _resourceNameArray);
            }
        ImGui.EndDisabled();
        
        ImGui.BeginChild("List", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 30, true);
        
        var _i = 0;
        repeat(array_length(_resourceNameArray))
        {
            var _name = _resourceNameArray[_i];
            
            if (_stateStruct.__multiselect)
            {
                var _state = __VinylMultiselectIsSelected(_stateStruct, _name);
                var _newState = ImGui.Checkbox(_name, _state);
                if (_newState != _state)
                {
                    _selectedDict = __VinylMultiselectSelect(_stateStruct, _name, _state);
                }
            }
            else
            {
                if (ImGui.RadioButton(_name, __VinylMultiselectIsSelected(_stateStruct, _name)))
                {
                    _selectedDict = __VinylMultiselectSelectExclusive(_stateStruct, _name);
                }
            }
            
            ++_i;
        }
        
        ImGui.EndChild();
        
        ImGui.Text("Multiselect");
        ImGui.SameLine();
        
        var _newMultiselect = ImGui.Checkbox("##Multiselect", _stateStruct.__multiselect);
        if (_newMultiselect != _stateStruct.__multiselect)
        {
            _stateStruct.__multiselect = _newMultiselect;
            if (not _newMultiselect)
            {
                _selectedDict = __VinylMultiselectSelectLast(_stateStruct, _resourceDict);
            }
        }
        
        ImGui.BeginDisabled(not _stateStruct.__multiselect);
            ImGui.SameLine();
            
            if (ImGui.Button("All"))
            {
                _selectedDict = __VinylMultiselectSelectAll(_stateStruct, _resourceNameArray);
            }
            
            ImGui.SameLine();
            
            if (ImGui.Button("None"))
            {
                _selectedDict = __VinylMultiselectSelectNone(_stateStruct);
            }
            
        ImGui.EndDisabled();
        
    ImGui.EndChild();
    
    return _selectedDict;
}