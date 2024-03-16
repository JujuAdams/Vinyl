// Feather disable all

function __VedClassWindowLog() : __VedClassWindow() constructor
{
    __handle = "Log";
    
    static __Update = function()
    {
        __BuildUI();
    }
    
    static __BuildUI = function()
    {
        var _string = _system.__logHistoricString;
        
        ImGui.SetNextWindowSize(0.6*room_width, 0.8*room_height, ImGuiCond.Once);
        ImGui.SetNextWindowPos(0.2*room_width, 0.1*room_height, ImGuiCond.Once);
	    
        var _return = ImGui.Begin(__handle, not __closed, ImGuiWindowFlags.None, ImGuiReturnMask.Both);
        __closed = ((_return & ImGuiReturnMask.Pointer) <= 0);
        
        if (_return & ImGuiReturnMask.Return)
        {
            var _width  = ImGui.CalcTextWidth(_string);
            var _height = ImGui.CalcTextHeight(_string);
            _height += 18;
            
            ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, 0, 0); //Make align with text height
            ImGui.PushStyleColor(ImGuiCol.FrameBg, c_black, 0); //Remove text input box
            
            ImGui.InputTextMultiline("##Copyable Text", _string, _width, _height, ImGuiInputTextFlags.ReadOnly | ImGuiInputTextFlags.NoHorizontalScroll);
            
            ImGui.PopStyleColor();
            ImGui.PopStyleVar();
        }
        
        ImGui.End();
    }
}