// Feather disable all

function __VinylEditorWindowConfigKnobs(_stateStruct)
{
    static _editor = __VinylGlobalData().__editor;
    if (not VinylEditorIsShowing()) return;
    
    var _document = __VinylDocument();
    var _resourceDict = _document.__data.knobs;
    
    var _resourceNameArray = variable_struct_get_names(_resourceDict);
    array_sort(_resourceNameArray, true);
    
    ImGui.SetNextWindowSize(room_width/2, room_height/2, ImGuiCond.Once);
    ImGui.SetNextWindowPos(room_width/4, room_height/4, ImGuiCond.Once);
	
    var ret = ImGui.Begin("Knobs", __VinylEditorWindowGetOpen("__configKnobs"), undefined, ImGuiReturnMask.Both);
    __VinylEditorWindowSetOpen("__configKnobs", (ret & ImGuiReturnMask.Pointer));
    
    if (ret & ImGuiReturnMask.Return)
    {
		var _width  = ImGui.GetContentRegionAvailX();
		var _height = ImGui.GetContentRegionAvailY();
        
        var _selectedDict = __VinylEditorSharedSelector("Left Panel", 0.3*_width, _height, _stateStruct, __VINYL_OPTION_KNOB, __VinylClassKnobNew, _resourceDict, _resourceNameArray);
        
        ImGui.SameLine();
        
        ImGui.BeginChild("Right Pane", 0.7*_width - 7, _height);
            var _nameConflictPopup = false;
            
            switch(variable_struct_names_count(_selectedDict))
            {
                case 0:
                    if (array_length(_resourceNameArray) > 0)
                    {
                        ImGui.Text("Select a knob from the menu on the left");
                    }
                    else
                    {
                        ImGui.Text("Add a new knob from the menu on the left");
                    }
                break;
                
                case 1:
                    var _selectedName = variable_struct_get_names(_selectedDict)[0];
                    var _resourceData = _resourceDict[$ _selectedName];
                    
                    var _newName = ImGui.InputText("##Resource Name", _selectedName);
                    if (ImGui.IsItemDeactivatedAfterEdit() && (_newName != _selectedName))
                    {
                        if (__VinylMultiselectExists(_resourceDict, _newName))
                        {
                            _nameConflictPopup = true;
                            _stateStruct.__popupData = {
                                __name: _newName,
                            };
                        }
                        else
                        {
                            _selectedDict = __VinylMultiselectRename(_stateStruct, _resourceDict, _selectedName, _newName);
                        }
                    }
                    
                    ImGui.BeginChild("Right Inner Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY(), true);
                        
                        ImGui.NewLine();
                        
                        ImGui.Text("Input Range");
                        ImGui.SameLine();
                        
                        var _array = variable_clone(_resourceData.inputRange);
                        ImGui.InputFloat2("##Input Range", _array);
                        if (ImGui.IsItemDeactivatedAfterEdit())
                        {
                            if (_array[0] > _array[1])
                            {
                                var _temp = _array[1];
                                _array[1] = _array[0];
                                _array[0] = _temp;
                            }
                            
                            _document.__Write(_resourceData, "inputRange", _array);
                        }
                        
                        ImGui.NewLine();
                        
                        ImGui.Text("Output Range");
                        ImGui.SameLine();
                        
                        var _array = variable_clone(_resourceData.outputRange);
                        ImGui.InputFloat2("##Output Range", _array);
                        if (ImGui.IsItemDeactivatedAfterEdit())
                        {
                            if (_array[0] > _array[1])
                            {
                                var _temp = _array[1];
                                _array[1] = _array[0];
                                _array[0] = _temp;
                            }
                            
                            _document.__Write(_resourceData, "outputRange", _array);
                            
                            _document.__Write(_resourceData, "defaultValue",
                                              clamp(_resourceData.defaultValue, _resourceData.outputRange[0], _resourceData.outputRange[1]));
                        }
                        
                        ImGui.NewLine();
                        
                        ImGui.Text("Default Value");
                        ImGui.SameLine();
                        
                        var _newValue = ImGui.InputFloat("##Default Value", _resourceData.defaultValue);
                        if (ImGui.IsItemDeactivatedAfterEdit())
                        {
                            _document.__Write(_resourceData, "defaultValue",
                                              clamp(_newValue, _resourceData.outputRange[0], _resourceData.outputRange[1]));
                        }
                    ImGui.EndChild();
                break;
                
                default:
                    ImGui.Text("Cannot modify multiple knobs");
                break;
            }
            
            __VinylEditorSharedNameConflictPopup(_nameConflictPopup, _stateStruct.__popupData[$ "__name"]);
            
        ImGui.EndChild();
    }
    
    ImGui.End();
}