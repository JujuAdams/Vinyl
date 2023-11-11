// Feather disable all

function __VinylEditorSharedNameConflictPopup(_doPopup, _name)
{
    if (_doPopup) ImGui.OpenPopup("Name Conflict");
    ImGui.SetNextWindowPos(window_get_width()/2, window_get_height()/2, ImGuiCond.Appearing, 0.5, 0.5);
    if (ImGui.BeginPopupModal("Name Conflict", undefined, ImGuiWindowFlags.NoResize))
    {
        ImGui.Text("\"" + string(_name) + "\" already exists.");
        
        ImGui.Separator();
        
        if (ImGui.Button("Got it!")) ImGui.CloseCurrentPopup();
        ImGui.EndPopup();
    }
}