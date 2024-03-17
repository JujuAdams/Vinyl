// Feather disable all

function __VedClassWindowAbout() : __VedClassWindow() constructor
{
    __handle = "About";
    
    static __Update = function()
    {
        __BuildUI();
    }
    
    static __BuildUI = function()
    {
        ImGui.SetNextWindowSize(0.2*room_width, 0.38*room_height, ImGuiCond.Once);
        ImGui.SetNextWindowPos(0.4*room_width, 0.31*room_height, ImGuiCond.Once);
	    
        var _return = ImGui.Begin(__handle, not __closed, ImGuiWindowFlags.NoCollapse, ImGuiReturnMask.Both);
        __closed = ((_return & ImGuiReturnMask.Pointer) <= 0);
        
        if (_return & ImGuiReturnMask.Return)
        {
            var _funcCenteredTextColored = function(_string, _color)
            {
                var _windowWidth = ImGui.GetWindowWidth();
                var _textWidth = ImGui.CalcTextWidth(_string);
                
                ImGui.SetCursorPosX(0.5*(_windowWidth - _textWidth));
                ImGui.TextColored(_string, _color);
            }
            
            var _funcCenteredText = function(_string)
            {
                var _windowWidth = ImGui.GetWindowWidth();
                var _textWidth = ImGui.CalcTextWidth(_string);
                
                ImGui.SetCursorPosX(0.5*(_windowWidth - _textWidth));
                ImGui.Text(_string);
            }
            
            var _funcCenteredButton = function(_string, _function)
            {
                var _windowWidth = ImGui.GetWindowWidth();
                var _textWidth = ImGui.CalcTextWidth(_string) + 2*4;
                
                ImGui.SetCursorPosX(0.5*(_windowWidth - _textWidth));
                if (ImGui.Button(_string)) _function();
            }
            
            _funcCenteredTextColored("Vinyl " + __VED_VERSION + ", " + __VED_DATE, #ff7f00);
            _funcCenteredText("For GameMaker 2023.8");
            _funcCenteredText("By Juju Adams");
            _funcCenteredButton("Website", function() { url_open("https://www.jujuadams.com/") });
            ImGui.NewLine();
            _funcCenteredText("ImGui by Omar Cornut");
            _funcCenteredButton("Website", function() { url_open("https://www.miracleworld.net/") });
            ImGui.NewLine();
            _funcCenteredText("ImGui_GM extension by nommiin");
            _funcCenteredButton("GitHub", function() { url_open("https://github.com/nommiin/ImGui_GM/") });
            ImGui.NewLine();
            _funcCenteredText("Background shader by Xor");
            _funcCenteredButton("Shadertoy", function() { url_open("https://www.shadertoy.com/view/3sccD8/") });
        }
        
        ImGui.End();
    }
}