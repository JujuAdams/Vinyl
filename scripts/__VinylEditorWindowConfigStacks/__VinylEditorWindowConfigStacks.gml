// Feather disable all

function __VinylEditorWindowConfigStacks(_stateStruct)
{
    static _editor = __VinylGlobalData().__editor;
    if (not VinylEditorIsShowing()) return;
    
    var _nameConflictPopup = false;
    
    var _selectedDict = _stateStruct.__selectedDict;
    
    var _document = __VinylDocument();
    
    var _resourceDict = _document.__data.stacks;
    var _resourceNameArray = variable_struct_get_names(_resourceDict);
    array_sort(_resourceNameArray, true);
    
    ImGui.SetNextWindowSize(room_width/2, room_height/2, ImGuiCond.Once);
    ImGui.SetNextWindowPos(room_width/4, room_height/4, ImGuiCond.Once);
	
    var ret = ImGui.Begin("Stacks", _stateStruct.__open, undefined, ImGuiReturnMask.Both);
    _stateStruct.__open = (ret & ImGuiReturnMask.Pointer);
    
    if (ret & ImGuiReturnMask.Return)
    {
		var _width  = ImGui.GetContentRegionAvailX();
		var _height = ImGui.GetContentRegionAvailY();
        
        ImGui.BeginChild("Left Pane", 0.3*_width, _height);
            
            if (ImGui.Button("Add"))
            {
                _selectedDict = __VinylMultiselectAdd(_stateStruct, _resourceDict, __VinylClassStackNew);
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
        
        ImGui.SameLine();
        
        ImGui.BeginChild("Right Pane", 0.7*_width - 7, _height);
            switch(variable_struct_names_count(_selectedDict))
            {
                case 0:
                    if (array_length(_resourceNameArray) > 0)
                    {
                        ImGui.Text("Select a stack from the menu on the left");
                    }
                    else
                    {
                        ImGui.Text("Add a new stack from the menu on the left");
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
                        ImGui.Text("Ducked Gain");
                        ImGui.SameLine();
                        
                        _document.__Write(_resourceData, "duckedGain",
                                          ImGui.SliderFloat("##Ducked Gain", _resourceData.duckedGain, 0, 1, "%.2f"));
                        
                        ImGui.NewLine();
                        
                        ImGui.Text("Duck Rate (gain/sec.)");
                        ImGui.SameLine();
                        
                        _document.__Write(_resourceData, "duckRate",
                                          ImGui.SliderFloat("##Duck Rate", _resourceData.duckRate, 0.1, 10, "%.2f"));
                       
                        ImGui.NewLine();
                        
                        ImGui.Text("Pause When Ducked");
                        ImGui.SameLine();
                        
                        _document.__Write(_resourceData, "pauseWhenDucked",
                                          ImGui.Checkbox("##Pause When Ducked", _resourceData.pauseWhenDucked));
                    ImGui.EndChild();
                break;
                
                default:
                    ImGui.Text("Cannot modify multiple stacks");
                break;
            }
            
            __VinylEditorSharedNameConflictPopup(_nameConflictPopup, _stateStruct.__popupData[$ "__name"]);
            
        ImGui.EndChild();
    }
    
    ImGui.End();
}