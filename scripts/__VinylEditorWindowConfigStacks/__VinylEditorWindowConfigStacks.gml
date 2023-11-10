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
                var _index = 1;
                var _newName = "Stack " + string(_index);
                while(variable_struct_exists(_resourceDict, _newName))
                {
                    ++_index;
                    _newName = "Stack " + string(_index);
                }
                
                
                
                _resourceDict[$ _newName] = {
                    duckedGain: 0,
                    duckRate: VINYL_DEFAULT_DUCK_GAIN_RATE,
                    pauseWhenDucked: true,
                };
                
                
                
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
            }
            
            ImGui.SameLine(undefined, 120);
            ImGui.BeginDisabled(variable_struct_names_count(_selectedDict) <= 0);
                if (ImGui.Button("Delete"))
                {
                    if ((variable_struct_names_count(_selectedDict) > 0) && (array_length(_resourceNameArray) > 0))
                    {
                        var _deleted = false;
                        var _nextSelected = undefined;
                        
                        var _i = 0;
                        repeat(array_length(_resourceNameArray))
                        {
                            var _name = _resourceNameArray[_i];
                            if (variable_struct_exists(_selectedDict, _name))
                            {
                                if ((not _deleted) && (_nextSelected == undefined) && (_i > 0))
                                {
                                    _nextSelected = _resourceNameArray[_i-1];
                                }
                                
                                _deleted = true;
                                
                                variable_struct_remove(_resourceDict, _name);
                                array_delete(_resourceNameArray, _i, 1);
                            }
                            else
                            {
                                ++_i;
                            }
                        }
                        
                        _stateStruct.__selectedDict = {};
                        _selectedDict = _stateStruct.__selectedDict;
                        
                        if (_nextSelected != undefined)
                        {
                            _selectedDict[$ _nextSelected] = true;
                            _stateStruct.__lastSelected = _nextSelected;
                        }
                        else if (array_length(_resourceNameArray) > 0)
                        {
                            _selectedDict[$ _resourceNameArray[0]] = true;
                            _stateStruct.__lastSelected = _resourceNameArray[0];
                        }
                    }
                }
            ImGui.EndDisabled();
            
            ImGui.BeginChild("List", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 30, true);
            
            var _i = 0;
            repeat(array_length(_resourceNameArray))
            {
                var _name = _resourceNameArray[_i];
                
                if (_stateStruct.__multiselect)
                {
                    var _state = _selectedDict[$ _name] ?? false;
                    var _newState = ImGui.Checkbox(_name, _state);
                    if (_newState != _state)
                    {
                        if (_newState)
                        {
                            _selectedDict[$ _name] = true;
                            _stateStruct.__lastSelected = _name;
                        }
                        else
                        {
                            variable_struct_remove(_selectedDict, _name);
                        }
                    }
                }
                else
                {
                    if (ImGui.RadioButton(_name, _selectedDict[$ _name] ?? false))
                    {
                        _stateStruct.__selectedDict = {};
                        _selectedDict = _stateStruct.__selectedDict;
                        
                        _selectedDict[$ _name] = true;
                        _stateStruct.__lastSelected = _name;
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
                    _stateStruct.__selectedDict = {};
                    _selectedDict = _stateStruct.__selectedDict;
                    
                    var _lastSelected = _stateStruct.__lastSelected;
                    if ((_lastSelected != undefined) && variable_struct_exists(_resourceDict, _lastSelected))
                    {
                        _selectedDict[$ _lastSelected] = true;
                    }
                    else
                    {
                        _stateStruct.__lastSelected = undefined;
                    }
                }
            }
            
            ImGui.BeginDisabled(not _stateStruct.__multiselect);
                ImGui.SameLine();
                
                if (ImGui.Button("All"))
                {
                    _stateStruct.__selectedDict = {};
                    _selectedDict = _stateStruct.__selectedDict;
                    
                    var _i = 0;
                    repeat(array_length(_resourceNameArray))
                    {
                        _selectedDict[$ _resourceNameArray[_i]] = true;
                        ++_i;
                    }
                }
                
                ImGui.SameLine();
                
                if (ImGui.Button("None"))
                {
                    _stateStruct.__selectedDict = {};
                    _stateStruct.__lastSelected = undefined;
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
                        if (variable_struct_exists(_resourceDict, _newName))
                        {
                            _nameConflictPopup = true;
                            _stateStruct.__popupData = {
                                __name: _newName,
                            };
                        }
                        else
                        {
                            variable_struct_remove(_resourceDict, _selectedName);
                            _resourceDict[$ _newName] = _resourceData;
                            
                            _stateStruct.__selectedDict = {};
                            _selectedDict = _stateStruct.__selectedDict;
                            
                            _selectedDict[$ _newName] = true;
                            _stateStruct.__lastSelected = _newName;
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
    
            if (_nameConflictPopup) ImGui.OpenPopup("Name Conflict");
            ImGui.SetNextWindowPos(window_get_width()/2, window_get_height()/2, ImGuiCond.Appearing, 0.5, 0.5);
            if (ImGui.BeginPopupModal("Name Conflict", undefined, ImGuiWindowFlags.NoResize))
            {
                ImGui.Text("\"" + string(_stateStruct.__popupData.__name) + "\" already exists.");
                
                ImGui.Separator();
                
                if (ImGui.Button("Got it!")) ImGui.CloseCurrentPopup();
                ImGui.EndPopup();
            }
            
        ImGui.EndChild();
    }
    
    ImGui.End();
}