// Feather disable all

function __VedClassModalCreateProject() : __VedClassModal() constructor
{
    __handle = "Create Project";
    
    static __FirstTime = function()
    {
        ImGui.OpenPopup(__handle);
        ImGui.SetNextWindowPos(window_get_width()/2, window_get_height ()/2, ImGuiCond.Appearing, 0.5, 0.5);
    }
    
    static __BuildUI = function()
    {
        if (ImGui.BeginPopupModal(__handle, undefined, ImGuiWindowFlags.NoResize))
        {
            ImGui.Text(string_concat("No Vinyl project was found for \"", __path, "\".\nWould you like to create one?"));
            
            ImGui.Separator();
            
            if (ImGui.Button("Create Vinyl Project"))
            {
                __Close();
                __VedCreate(__path);
            }
            
            ImGui.SameLine();
            if (ImGui.Button("Abort Connection")) __Close();
            
            ImGui.EndPopup();
        }
    }
}