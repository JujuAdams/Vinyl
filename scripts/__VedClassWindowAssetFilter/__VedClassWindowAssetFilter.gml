// Feather disable all

function __VedClassWindowAssetFilter() : __VedClassWindow() constructor
{
    __handle = "Asset Filter";
    
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
            
        }
        
        ImGui.End();
    }
}