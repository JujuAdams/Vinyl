// Feather disable all

function __VedClassModal() constructor
{
    static _system = __VedSystem();
    
    __firstRun = true;
    
    static __Update = function()
    {
        if (__firstRun)
        {
            __firstRun = false;
            __FirstTime();
        }
        
        __BuildUI();
    }
    
    static __FirstTime = function()
    {
        
    }
    
    static __BuildUI = function()
    {
        if (__firstRun)
        {
            __firstRun = false;
            
            ImGui.OpenPopup("Close Editor?");
            ImGui.SetNextWindowPos(window_get_width()/2, window_get_height ()/2, ImGuiCond.Appearing, 0.5, 0.5);
        }
        
        if (ImGui.BeginPopupModal("Close Editor?", undefined, ImGuiWindowFlags.NoResize))
        {
            ImGui.Text("Are you sure you want to close the editor without saving?");
            
            ImGui.Separator();
            
            if (ImGui.Button("Lose all changes"))
            {
            	ImGui.CloseCurrentPopup();
                VedClose();
                return;
            }
            
            ImGui.SameLine();
            if (ImGui.Button("Keep working")) ImGui.CloseCurrentPopup();
            ImGui.EndPopup();	
        }
    }
}