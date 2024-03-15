// Feather disable all

function __VedClassModalIdentifyProject() : __VedClassModal() constructor
{
    __handle = "Identify Project";
    
    static __FirstTime = function()
    {
        ImGui.OpenPopup(__handle);
        ImGui.SetNextWindowPos(window_get_width()/2, window_get_height ()/2, ImGuiCond.Appearing, 0.5, 0.5);
    }
    
    static __BuildUI = function()
    {
        if (ImGui.BeginPopupModal(__handle, undefined, ImGuiWindowFlags.NoResize))
        {
            ImGui.Text(string_concat("Please identify the GameMaker project file associated with this game.\n(Expected ident=\"", __receivedIdent, "\")"));
            
            ImGui.Separator();
            
            if (ImGui.Button("Open File Browser"))
            {
                var _path = get_open_filename("GameMaker Project (*.yyp)|*.yyp", "");
                if (_path != "")
                {
                    __Close();
                    
                    var _foundIdent = "1";
                    if (_foundIdent == __receivedIdent)
                    {
                        __VedModalOpen(__VedClassModalIdentifyProjectSuccess);
                    }
                    else
                    {
                        __VedModalOpen(__VedClassModalIdentifyProjectFailed).__receivedIdent = __receivedIdent;
                    }
                }
            }
            
            ImGui.SameLine();
            if (ImGui.Button("Abort Connection")) __Close();
            
            ImGui.EndPopup();
        }
    }
}