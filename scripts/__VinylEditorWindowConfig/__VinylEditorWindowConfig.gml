// Feather disable all

function __VinylEditorWindowConfig(_stateStruct)
{
    static _editor = __VinylGlobalData().__editor;
    if (not VinylEditorIsShowing()) return;
    
    ImGui.SetNextWindowSize(0.7*room_width, 0.8*room_height, ImGuiCond.Once);
    ImGui.SetNextWindowPos(0.15*room_width, 0.1*room_height, ImGuiCond.Once);
	
    var ret = ImGui.Begin("Config", __VinylEditorWindowGetOpen("__config"), undefined, ImGuiReturnMask.Both);
    __VinylEditorWindowSetOpen("__config", (ret & ImGuiReturnMask.Pointer));
    
    if (ret & ImGuiReturnMask.Return)
    {
		if (ImGui.BeginTabBar("Tab Bar"))
        {
            if (ImGui.BeginTabItem("Sounds"))
            {
                _editor.__windowStates.__filter.__target = _stateStruct.__tabSounds.__filter;
                __VinylEditorWindowConfigSounds(_stateStruct);
                ImGui.EndTabItem();
            }
            
            if (ImGui.BeginTabItem("Labels"))
            {
                _editor.__windowStates.__filter.__target = undefined;
                ImGui.EndTabItem();
            }
                
            if (ImGui.BeginTabItem("Patterns"))
            {
                _editor.__windowStates.__filter.__target = undefined;
                __VinylEditorWindowConfigPatterns(_stateStruct);
                ImGui.EndTabItem();
            }
            
            if (ImGui.BeginTabItem("Stacks"))
            {
                _editor.__windowStates.__filter.__target = undefined;
                ImGui.EndTabItem();
            }
            
            if (ImGui.BeginTabItem("Effect Chains"))
            {
                _editor.__windowStates.__filter.__target = undefined;
                ImGui.EndTabItem();
            }
            
            if (ImGui.BeginTabItem("Knobs"))
            {
                _editor.__windowStates.__filter.__target = undefined;
                ImGui.EndTabItem();
            }
            
            ImGui.EndTabBar();
        }
    }
    
    ImGui.End();
}