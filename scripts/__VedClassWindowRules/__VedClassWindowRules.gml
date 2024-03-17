// Feather disable all

function __VedClassWindowRules() : __VedClassWindow() constructor
{
    __handle = "Rules";
    
    static __Update = function()
    {
        __BuildUI();
    }
    
    static __BuildUI = function()
    {
        ImGui.SetNextWindowSize(0.6*room_width, 0.8*room_height, ImGuiCond.Once);
        ImGui.SetNextWindowPos(0.2*room_width, 0.1*room_height, ImGuiCond.Once);
	    
        var _return = ImGui.Begin(__handle, not __closed, ImGuiWindowFlags.None, ImGuiReturnMask.Both);
        __closed = ((_return & ImGuiReturnMask.Pointer) <= 0);
        
        if (_return & ImGuiReturnMask.Return)
        {
            if (ImGui.BeginTabBar("Rules Tab Bar"))
            {
                var _return = ImGui.BeginTabItem("Tab 1");
                if (_return & ImGuiReturnMask.Return)
                {
                    ImGui.Text("Tab 1");
                    ImGui.EndTabItem();
                }
                
                var _return = ImGui.BeginTabItem("Tab 2");
                if (_return & ImGuiReturnMask.Return)
                {
                    ImGui.Text("Tab 2");
                    ImGui.EndTabItem();
                }
                
                ImGui.EndTabBar();
            }
        }
        
        ImGui.End();
    }
}