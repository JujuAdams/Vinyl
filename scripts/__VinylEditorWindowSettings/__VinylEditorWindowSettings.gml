// Feather disable all

function __VinylEditorWindowSettings(_stateStruct)
{
    static _editor = __VinylGlobalData().__editor;
    if (not VinylEditorIsShowing()) return;
    
    ImGui.SetNextWindowSize(room_width/2, room_height/2, ImGuiCond.Once);
    ImGui.SetNextWindowPos(room_width/4, room_height/4, ImGuiCond.Once);
	
    var ret = ImGui.Begin("Global Settings", __VinylEditorWindowGetOpen("__settings"), undefined, ImGuiReturnMask.Both);
    __VinylEditorWindowSetOpen("__settings", (ret & ImGuiReturnMask.Pointer));
    
    if (ret & ImGuiReturnMask.Return)
    {
        __VinylGlobalSettingSet("username", ImGui.InputText("Username", __VinylGlobalSettingGet("username")));
        
        if (ImGui.IsItemEdited())
        {
            show_debug_message("Username changed");
        }
        
        ImGui.NewLine();
        
        __VinylGlobalSettingSet("showGainsInDecibels", ImGui.Checkbox("Shows gains in dB", __VinylGlobalSettingGet("showGainsInDecibels")));
        __VinylGlobalSettingSet("showPitchInPercent", ImGui.Checkbox("Shows pitch in %", __VinylGlobalSettingGet("showPitchInPercent")));
        
        __VinylGlobalSettingSet("maximumSnapshots", ImGui.InputInt("Maximum Snapshots", __VinylGlobalSettingGet("maximumSnapshots")));
        
        if (ImGui.Button("Clear Temp Data"))
        {
            show_debug_message("Clear temp data");
        }
        
        __VinylGlobalSettingSet("refreshProjectOnRefocus", ImGui.Checkbox("Refresh project on refocus", __VinylGlobalSettingGet("refreshProjectOnRefocus")));
        __VinylGlobalSettingSet("defaultAutogenerateMacros", ImGui.Checkbox("\"Autogenerate Macros\" default", __VinylGlobalSettingGet("defaultAutogenerateMacros")));
        __VinylGlobalSettingSet("defaultMacroScriptName", ImGui.InputText("\"Macro Script Name\" default", __VinylGlobalSettingGet("defaultMacroScriptName")));
    }
    
    ImGui.End();
}