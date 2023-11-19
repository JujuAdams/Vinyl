// Feather disable all

function __VinylEditorWindowSoundTest(_stateStruct)
{
    static _editor = __VinylGlobalData().__editor;
    if (not VinylEditorIsShowing()) return;
    
    var _projectSoundArray = __VinylDocument().__ProjectGetSoundArray();
    
    ImGui.SetNextWindowSize(0.4*room_width, 0.6*room_height, ImGuiCond.Once);
    ImGui.SetNextWindowPos(0.3*room_width, 0.2*room_height, ImGuiCond.Once);
	
    //Allow the filter window to stay on top
    var _flags = __VinylEditorWindowGetOpen("__filter")? ImGuiWindowFlags.NoBringToFrontOnFocus : ImGuiWindowFlags.None;
    
    var ret = ImGui.Begin("Sound Test", __VinylEditorWindowGetOpen("__soundTest"), _flags, ImGuiReturnMask.Both);
    __VinylEditorWindowSetOpen("__soundTest", (ret & ImGuiReturnMask.Pointer));
    
    if (ret & ImGuiReturnMask.Return)
    {
        ImGui.BeginChild("Left Pane", 0.66*ImGui.GetContentRegionAvailX(), undefined, false);
        
    		if (ImGui.BeginTabBar("Tab Bar"))
            {
                if (ImGui.BeginTabItem("Assets"))
                {
                    ImGui.BeginChild("Left Pane", undefined, undefined, false);
                        
                        var _i = 0;
                        repeat(array_length(_projectSoundArray))
                        {
                            var _name = _projectSoundArray[_i];
                            if (ImGui.ArrowButton("##Play " + _name, ImGuiDir.Right))
                            {
                                VinylPlaySimple(asset_get_index(_name));
                            }
                            ImGui.SameLine();
                            ImGui.Text(_name);
                        
                            ++_i;
                        }
                        
                    ImGui.EndChild();
                    ImGui.EndTabItem();
                }
                
                if (ImGui.BeginTabItem("Patterns"))
                {
                    var _resourceDict = __VinylDocument().__data.patterns;
                    var _resourceNameArray = variable_struct_get_names(_resourceDict);
                    array_sort(_resourceNameArray, true);
                    
                    var _i = 0;
                    repeat(array_length(_resourceNameArray))
                    {
                        var _name = _resourceNameArray[_i];
                        if (ImGui.ArrowButton("##", ImGuiDir.Right))
                        {
                            VinylPlaySimple(asset_get_index(_name));
                        }
                        ImGui.SameLine();
                        ImGui.Text(_name);
                        
                        ++_i;
                    }
                    
                    ImGui.EndTabItem();
                }
                
                ImGui.EndTabBar();
            }
            
        ImGui.EndChild();
        
        ImGui.SameLine();
        
        ImGui.BeginChild("Right Pane", ImGui.GetContentRegionAvailX(), undefined, true);
            
            var _knobDict = __VinylDocument().__knobDict;
            var _knobNameArray = variable_struct_get_names(_knobDict);
            array_sort(_knobNameArray, true);
            
            var _i = 0;
            repeat(array_length(_knobNameArray))
            {
                var _knobName = _knobNameArray[_i];
                var _knob = _knobDict[$ _knobName];
                
                if (_knob.__unlimited)
                {
                    ImGui.Text(_knobName);
                    ImGui.SetNextItemWidth(ImGui.GetContentRegionAvailX());
                    
                    var _newValue = ImGui.InputFloat("##Knob Input " + _knobName, _knob.__valueInput, undefined, undefined, "%.2f");
                    if (_newValue != _knob.__valueInput)
                    {
                        _knob.__Set(_newValue);
                    }
                    
                    ImGui.NewLine();
                }
                else
                {
                    ImGui.Text(_knobName);
                    ImGui.SetNextItemWidth(ImGui.GetContentRegionAvailX());
                    
                    var _newValue = ImGui.SliderFloat("##Knob Slider " + _knobName, _knob.__valueInput, _knob.__inputRange[0], _knob.__inputRange[1], "%.2f");
                    if (_newValue != _knob.__valueInput)
                    {
                        _knob.__Set(_newValue);
                    }
                    ImGui.Text("= " + string_format(_knob.__valueOutput, 0, 2));
                    
                    ImGui.NewLine();
                }
                
                ++_i;
            }
            
        ImGui.EndChild();
    }
    
    ImGui.End();
}