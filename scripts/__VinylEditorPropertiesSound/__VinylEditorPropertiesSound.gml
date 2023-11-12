// Feather disable all

function __VinylEditorPropertiesSound(_soundName, _soundData, _modified, _defaultData)
{
    if (not _modified)
    {
        _soundData = _defaultData;
        _defaultData = undefined;
    }
    
    ImGui.BeginDisabled(not _modified);
        //Now do the actual table
        if (ImGui.BeginTable("Vinyl Properties", 4, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY, undefined, 280))
        {
            //Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("Name",     ImGuiTableColumnFlags.WidthFixed, 100);
            ImGui.TableSetupColumn("Option",   ImGuiTableColumnFlags.WidthFixed, 125);
            ImGui.TableSetupColumn("Value",    ImGuiTableColumnFlags.WidthStretch, 1);
            ImGui.TableSetupColumn("All Same", ImGuiTableColumnFlags.WidthFixed, 30);
            
            __VinylEditorPropWidgetGain(       _soundName, _soundData, _defaultData, 0, 2, 1);
            __VinylEditorPropWidgetPitch(      _soundName, _soundData, _defaultData, 0, 2, 1);
            __VinylEditorPropWidgetLoop(       _soundName, _soundData, _defaultData, 0, 2, 1, true);
            __VinylEditorPropWidgetLabel(      _soundName, _soundData, _defaultData, 0, 2, 1);
            __VinylEditorPropWidgetStack(      _soundName, _soundData, _defaultData, 0, 2, 1);
            __VinylEditorPropWidgetEffectChain(_soundName, _soundData, _defaultData, 0, 2, 1);
            __VinylEditorPropWidgetPersistent( _soundName, _soundData, _defaultData, 0, 2, 1);
            __VinylEditorPropWidgetBPM(        _soundName, _soundData, _defaultData, 0, 2, 1);
            __VinylEditorPropWidgetTranspose(  _soundName, _soundData, _defaultData, 0, 2, 1);
            
            //TODO - Loop Points
            
            ImGui.EndTable();
        }
    ImGui.EndDisabled();
    
    ImGui.NewLine();
    
    if (ImGui.BeginTable("GameMaker Native Properties", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY, undefined, 280))
    {
        ImGui.TableSetupColumn("Vinyl", ImGuiTableColumnFlags.WidthStretch, 3);
        ImGui.TableSetupColumn("Project", ImGuiTableColumnFlags.WidthStretch, 3);
        ImGui.TableHeadersRow();
        
        
        
        
        ImGui.EndTable();
    }
    
    //var _width = ImGui.GetContentRegionAvailX();
    //ImGui.BeginChild("GameMaker Native Properties", _width, 130, true);
    //
    //    ImGui.TextUnformatted("Audiogroup");
    //    ImGui.SameLine();
    //    if (ImGui.BeginCombo("##Audiogroup", "Default", ImGuiComboFlags.None))
    //    {
    //        ImGui.Selectable("Default", true);
    //        ImGui.Selectable("agBaddies", false);
    //        ImGui.Selectable("agFX", false);
    //        ImGui.EndCombo();
    //    }
    //    
    //    ImGui.RadioButton("WAV", true);
    //    ImGui.RadioButton("OGG - Decompress during playback", false);
    //    ImGui.RadioButton("OGG - Decompress when loaded and store in RAM", false);
    //    ImGui.RadioButton("OGG - Stream from disk (exports .ogg files in game directory)", false);
    //    
    //ImGui.EndChild();
}