// Feather disable all

function __VinylEditorWindowConfigAssets__OLD(_stateStruct)
{
    static _editor = __VinylGlobalData().__editor;
    if (not VinylEditorIsShowing()) return;
    
    ImGui.SetNextWindowSize(0.6*room_width, 0.8*room_height, ImGuiCond.Once);
    ImGui.SetNextWindowPos(0.2*room_width, 0.1*room_height, ImGuiCond.Once);
	
    var ret = ImGui.Begin("Assets", __VinylEditorWindowGetOpen("__configAssets"), undefined, ImGuiReturnMask.Both);
    __VinylEditorWindowSetOpen("__configAssets", (ret & ImGuiReturnMask.Pointer));
    
    if (ret & ImGuiReturnMask.Return)
    {
		var _width  = ImGui.GetContentRegionAvailX();
		var _height = ImGui.GetContentRegionAvailY();
        
        ImGui.BeginChild("Left Pane", 0.3*_width, _height);
            
            ImGui.Text("Filter");
            ImGui.SameLine();
            ImGui.Checkbox("##Filter", false);
            ImGui.SameLine();
            ImGui.Button("Edit...");
        
            ImGui.BeginChild("Asset List", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 70, true);
                ImGui.RadioButton("sndWhistle", false);
                ImGui.RadioButton("sndRocket", false);
                ImGui.RadioButton("sndNews", true);
                repeat(100) ImGui.RadioButton("???", false);
            ImGui.EndChild();
            
            ImGui.Text("Multiselect");
            ImGui.SameLine();
            ImGui.Checkbox("##Multiselect", false);
            ImGui.BeginDisabled(true);
                ImGui.SameLine();
                ImGui.Button("All");
                ImGui.SameLine();
                ImGui.Button("None");
            
                ImGui.Checkbox("See Selected", true);
                ImGui.Checkbox("See Unselected", true);
            ImGui.EndDisabled();
            
        ImGui.EndChild();
        
            ImGui.SameLine();
            ImGui.BeginChild("Right Pane", 0.75*_width, _height);
            ImGui.TextUnformatted("sndNews");
            ImGui.SameLine();
            ImGui.TextUnformatted("(source = project)");
        
            ImGui.BeginChild("Right Inner Pane", 0.7*_width, ImGui.GetContentRegionAvailY(), false);
        
                ImGui.BeginChild("Vinyl Properties", 0.66*_width, 520, true);
                    ImGui.Checkbox("Randomize Gain", false);
                    ImGui.Text("Gain");
                    ImGui.SameLine();
                    ImGui.SetNextItemWidth(0.3*_width);
                    ImGui.SliderFloat("##Gain", 0.6, 0, 2, "%.2f");
                    ImGui.SameLine();
                    ImGui.Text("Knob");
                    ImGui.SameLine();
                    ImGui.Checkbox("##Min Gain Knob Checkbox", false);
                    ImGui.SameLine();
                    ImGui.SetNextItemWidth(0.15*_width);
                    ImGui.InputTextWithHint("##Min Gain Knob", "e.g. @spookiness", "");
                    
                    ImGui.NewLine();
                    ImGui.NewLine();
                    
                    ImGui.Checkbox("Randomize Pitch", true);
                    ImGui.Text("Min Pitch");
                    ImGui.SameLine();
                    ImGui.SetNextItemWidth(0.3*_width);
                    ImGui.SliderFloat("##Min Pitch", 0.9, 0, 2, "%.2f");
                    ImGui.SameLine();
                    ImGui.Text("Knob");
                    ImGui.SameLine();
                    ImGui.Checkbox("##Min Pitch Knob Checkbox", false);
                    ImGui.SameLine();
                    ImGui.SetNextItemWidth(0.15*_width);
                    ImGui.BeginDisabled(true);
                        ImGui.InputTextWithHint("##Min Pitch Knob", "e.g. @spookiness", "");
                    ImGui.EndDisabled();
        
                    ImGui.Text("Max Pitch");
                    ImGui.BeginDisabled(false);
                        ImGui.SameLine();
                        ImGui.SetNextItemWidth(0.3*_width);
                        ImGui.SliderFloat("##Max Pitch", 1.1, 0, 2, "%.2f");
                        ImGui.SameLine();
                        ImGui.Text("Knob");
                        ImGui.SameLine();
                        ImGui.Checkbox("##Max Pitch Knob Checkbox", false);
                        ImGui.SameLine();
                        ImGui.SetNextItemWidth(0.15*_width);
                        ImGui.BeginDisabled(true);
                            ImGui.InputTextWithHint("##Max Pitch Knob", "e.g. @spookiness", "");
                        ImGui.EndDisabled();
                    ImGui.EndDisabled();
                    
                    ImGui.NewLine();
                    ImGui.NewLine();
                    
                    ImGui.Text("Label(s)");
                    ImGui.SameLine();
                    if (ImGui.BeginCombo("##Label", "", ImGuiComboFlags.None))
                    {
                        ImGui.Button("Add New");
                        repeat(10)
                        {
                            ImGui.Checkbox("A", false);
                            ImGui.Checkbox("B", false);
                            ImGui.Checkbox("C", false);
                            ImGui.Checkbox("D", false);
                            ImGui.Checkbox("E", false);
                        }
                        
                        ImGui.EndCombo();
                    }
                    ImGui.SameLine();
                    ImGui.Button("Clear");
                    
                    ImGui.NewLine();
                    ImGui.NewLine();
                    
                    ImGui.Text("Loop");
                    ImGui.SameLine();
                    ImGui.SetNextItemWidth(0.25*_width);
                    if (ImGui.BeginCombo("##Loop", "Off", ImGuiComboFlags.None))
                    {
                        ImGui.Selectable("Off", true);
                        ImGui.Selectable("On", false);
                        ImGui.Selectable("Inherit From Label(s)", false);
                        ImGui.EndCombo();
                    }
                    
                    ImGui.Text("Loop Points");
                    ImGui.SameLine();
                    ImGui.Checkbox("##Loop Points", false);
                    ImGui.BeginDisabled(true);
                        ImGui.SameLine();
                        ImGui.Text("Start");
                        ImGui.SameLine();
                        ImGui.SetNextItemWidth(0.1*_width);
                        ImGui.InputFloat("##Loop Point Start", 0, 0,0, "%.4f");
                        ImGui.SameLine();
                        ImGui.Text("End");
                        ImGui.SameLine();
                        ImGui.SetNextItemWidth(0.1*_width);
                        ImGui.InputFloat("##Loop Point End", 0, 0,0, "%.4f");
                    ImGui.EndDisabled();
                    
                    ImGui.NewLine();
                    ImGui.NewLine();
                    
                    ImGui.Text("Persistent");
                    ImGui.SameLine();
                    ImGui.SetNextItemWidth(0.25*_width);
                    if (ImGui.BeginCombo("##Persistent", "Off", ImGuiComboFlags.None))
                    {
                        ImGui.Selectable("Off", true);
                        ImGui.Selectable("On", false);
                        ImGui.Selectable("Inherit From Label(s)", false);
                        ImGui.EndCombo();
                    }
                    
                    ImGui.NewLine();
                    ImGui.NewLine();
                    
                    ImGui.Text("Stack");
                    ImGui.SameLine();
                    ImGui.SetNextItemWidth(0.33*_width);
                    if (ImGui.BeginCombo("##Stack", "", ImGuiComboFlags.None))
                    {
                        ImGui.Selectable("Inherit From Label(s)", false);
                        ImGui.Separator();
                        ImGui.Selectable("Music", false);
                        ImGui.EndCombo();
                    }
                    ImGui.SameLine();
                    ImGui.Button("Clear");
                    
                    ImGui.Text("Stack Priority");
                    ImGui.SameLine();
                    ImGui.SetNextItemWidth(0.1*_width);
                    ImGui.InputInt("##Stack Priority", 0);
                    
                    ImGui.NewLine();
                    ImGui.NewLine();
                    
                    ImGui.Text("Transpose");
                    ImGui.SameLine();
                    ImGui.SetNextItemWidth(0.25*_width);
                    if (ImGui.BeginCombo("##Transpose Checkbox", "Off", ImGuiComboFlags.None))
                    {
                        ImGui.Selectable("Off", true);
                        ImGui.Selectable("On - Use value", false);
                        ImGui.Selectable("On - Use knob", false);
                        ImGui.Selectable("Inherit From Label(s)", false);
                        ImGui.EndCombo();
                    }
                    ImGui.SameLine();
                    ImGui.BeginDisabled(true);
                        ImGui.SameLine();
                        ImGui.SetNextItemWidth(0.3*_width);
                        ImGui.SliderInt("##Transpose", 0, -24, 24);
                    ImGui.EndDisabled();
                    
                    ImGui.Text("BPM");
                    ImGui.SameLine();
                    ImGui.Checkbox("##BPM Checkbox", false);
                    ImGui.SameLine();
                    ImGui.BeginDisabled(true);
                        ImGui.SetNextItemWidth(0.1*_width);
                        ImGui.InputInt("##BPM", 120);
                    ImGui.EndDisabled();
                    
                ImGui.EndChild();
                
                ImGui.NewLine();
        
                ImGui.BeginChild("GameMaker Native Properties", 0.66*_width, 150, true);
                        
                    ImGui.TextUnformatted("Audiogroup");
                    ImGui.SameLine();
                    if (ImGui.BeginCombo("##Audiogroup", "Default", ImGuiComboFlags.None))
                    {
                        ImGui.Selectable("Default", true);
                        ImGui.Selectable("agBaddies", false);
                        ImGui.Selectable("agFX", false);
                        ImGui.EndCombo();
                    }
                    
                    ImGui.RadioButton("WAV", true);
                    ImGui.RadioButton("OGG - Decompress during playback", false);
                    ImGui.RadioButton("OGG - Decompress when loaded and store in RAM", false);
                    ImGui.RadioButton("OGG - Stream from disk (exports .ogg files in game directory)", false);
                    
                ImGui.EndChild();
        
            ImGui.EndChild();
        
        ImGui.EndChild();
    }
    
    ImGui.End();
}