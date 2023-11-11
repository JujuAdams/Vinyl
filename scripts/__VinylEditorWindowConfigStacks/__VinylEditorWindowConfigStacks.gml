// Feather disable all

function __VinylEditorWindowConfigStacks(_stateStruct)
{
    static _editor = __VinylGlobalData().__editor;
    if (not VinylEditorIsShowing()) return;
    
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
        
        var _selectedDict = __VinylEditorSharedSelector("Left Panel", 0.3*_width, _height, _stateStruct, "Stack", __VinylClassStackNew, _resourceDict, _resourceNameArray);
        
        ImGui.SameLine();
        
        ImGui.BeginChild("Right Pane", 0.7*_width - 7, _height);
            var _nameConflictPopup = false;
            
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

function __VinylClassStackNew() constructor
{
    duckedGain = 0;
    duckRate = VINYL_DEFAULT_DUCK_GAIN_RATE;
    pauseWhenDucked = true;
}