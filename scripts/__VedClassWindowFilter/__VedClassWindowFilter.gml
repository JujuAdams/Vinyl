// Feather disable all

function __VedClassWindowFilter() : __VedClassWindow() constructor
{
    __handle = "Filter";
    
    __filter = undefined;
    
    static __Update = function()
    {
        __BuildUI();
    }
    
    static __BuildUI = function()
    {
        ImGui.SetNextWindowSize(0.4*room_width, 0.32*room_height, ImGuiCond.Once);
        ImGui.SetNextWindowPos(0.3*room_width, 0.34*room_height, ImGuiCond.Once);
	    
        var _return = ImGui.Begin(__handle, not __closed, ImGuiWindowFlags.None, ImGuiReturnMask.Both);
        __closed = ((_return & ImGuiReturnMask.Pointer) <= 0);
        
        if (_return & ImGuiReturnMask.Return)
        {
            if (__filter != undefined) __filter.__BuildUI();
        }
        
        ImGui.End();
    }
}