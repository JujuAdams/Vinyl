// Feather disable all

function __VinylEditorWindowConfigPatterns(_stateStruct)
{
    static _editor = __VinylGlobalData().__editor;
    if (not VinylEditorIsShowing()) return;
    
    var _selectedDict = _stateStruct.__selectedDict;
    
    var _resourceTypeName = "Pattern";
    var _resourceConstructor = __VinylClassPatternNew;
    
    var _document = __VinylDocument();
    var _resourceDict = _document.__data.patterns;
    
    var _resourceNameArray = variable_struct_get_names(_resourceDict);
    array_sort(_resourceNameArray, true);
    
    ImGui.SetNextWindowSize(0.7*room_width, 0.6*room_height, ImGuiCond.Once);
    ImGui.SetNextWindowPos(0.15*room_width, 0.2*room_height, ImGuiCond.Once);
	
    var ret = ImGui.Begin("Patterns", __VinylEditorWindowGetOpen("__configPatterns"), undefined, ImGuiReturnMask.Both);
    __VinylEditorWindowSetOpen("__configPatterns", (ret & ImGuiReturnMask.Pointer));
    
    if (ret & ImGuiReturnMask.Return)
    {
		var _width  = ImGui.GetContentRegionAvailX();
		var _height = ImGui.GetContentRegionAvailY();
        
        ImGui.BeginChild("Left Pane", _width, _height);
            
            if (ImGui.Button("Add"))
            {
                _selectedDict = __VinylMultiselectAdd(_stateStruct, _resourceDict, _resourceTypeName, _resourceConstructor);
            }
            
            if (ImGui.BeginTable(_resourceTypeName + " Table", 4, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY, undefined, _height - 50))
            {
                ImGui.TableSetupColumn(_resourceTypeName, ImGuiTableColumnFlags.WidthStretch);
                ImGui.TableSetupColumn("Delete", ImGuiTableColumnFlags.WidthFixed, 70);
                ImGui.TableSetupColumn("Value", ImGuiTableColumnFlags.WidthFixed, 300);
                ImGui.TableSetupColumn("Knob", ImGuiTableColumnFlags.WidthFixed, 200);
                
                var _i = 0;
                repeat(array_length(_resourceNameArray))
                {
                    var _name = _resourceNameArray[_i];
                    __VinylEditorPropertiesPattern(_name, undefined, undefined, _name, _resourceDict[$ _name], _resourceConstructor);
                    ++_i;
                }
                
                ImGui.EndTable();
            }
            
            ImGui.Text("Multiselect");
            ImGui.SameLine();
        
            var _newMultiselect = ImGui.Checkbox("##Multiselect", _stateStruct.__multiselect);
            if (_newMultiselect != _stateStruct.__multiselect)
            {
                _stateStruct.__multiselect = _newMultiselect;
                if (not _newMultiselect)
                {
                    
                }
            }
        
            ImGui.BeginDisabled(not _stateStruct.__multiselect);
                ImGui.SameLine();
            
                if (ImGui.Button("All"))
                {
                    
                }
            
                ImGui.SameLine();
            
                if (ImGui.Button("None"))
                {
                    
                }
            
            ImGui.EndDisabled();
        
        ImGui.EndChild();
    }
        
    ImGui.End();
}