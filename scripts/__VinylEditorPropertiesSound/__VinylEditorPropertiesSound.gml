// Feather disable all

function __VinylEditorPropertiesSound(_soundName, _soundData)
{
    //Now do the actual table
    if (ImGui.BeginTable("Table", 3, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY, undefined, 520))
    {
        //Set up our columns with fixed widths so we get a nice pretty layout
        ImGui.TableSetupColumn("Name", ImGuiTableColumnFlags.WidthFixed, 100);
        ImGui.TableSetupColumn("Value", ImGuiTableColumnFlags.WidthStretch, 1);
        ImGui.TableSetupColumn("Option", ImGuiTableColumnFlags.WidthFixed, 150);
        
        __VinylEditorPropWidgetGain(_soundName, _soundData, undefined, 0, 1, 2);
        
        ImGui.EndTable();
    }
    
    if (false) {
    ImGui.BeginChild("Vinyl Properties", _width, 520, true);
    
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
    }
    
    ImGui.NewLine();
    
    var _width = ImGui.GetContentRegionAvailX();
    ImGui.BeginChild("GameMaker Native Properties", _width, 150, true);
    
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
}