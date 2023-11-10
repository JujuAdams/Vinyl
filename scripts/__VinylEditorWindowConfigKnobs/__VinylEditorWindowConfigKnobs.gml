// Feather disable all

function __VinylEditorWindowConfigKnobs(_stateStruct)
{
    static _editor = __VinylGlobalData().__editor;
    if (not VinylEditorIsShowing()) return;
    
    ImGui.SetNextWindowSize(room_width/2, room_height/2, ImGuiCond.Once);
    ImGui.SetNextWindowPos(room_width/4, room_height/4, ImGuiCond.Once);
	
    var ret = ImGui.Begin("Knobs", __VinylEditorWindowGetOpen("__configKnobs"), undefined, ImGuiReturnMask.Both);
    __VinylEditorWindowSetOpen("__configKnobs", (ret & ImGuiReturnMask.Pointer));
    
    ImGui.End();
}