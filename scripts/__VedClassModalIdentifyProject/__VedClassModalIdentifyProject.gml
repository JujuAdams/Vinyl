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
                var _yyPath = get_open_filename("GameMaker Project (*.yyp)|*.yyp", "");
                if (_yyPath != "")
                {
                    var _extension = filename_ext(_yyPath);
                    if (_extension != ".yyp")
                    {
                        __VedWarning("GameMaker project extension invalid");
                        __VedModalOpen(__VedClassModalLoadFailed).__path = _yyPath;
                        return;
                    }
                    
                    if (not file_exists(_yyPath))
                    {
                        __VedWarning("GameMaker project doesn't exist");
                        __VedModalOpen(__VedClassModalLoadFailed).__path = _yyPath;
                        return;
                    }
                    
                    var _vinylPath = filename_dir(_yyPath) + "/" + __VED_PROJECT_FILENAME;
                    if (not file_exists(_vinylPath))
                    {
                        __VedWarning("Vinyl project doesn't exist");
                        __VedModalOpen(__VedClassModalLoadFailed).__path = _vinylPath;
                        return;
                    }
                    
                    var _buffer = buffer_load(_vinylPath);
                    var _string = buffer_read(_buffer, buffer_text);
                    buffer_delete(_buffer);
                    
                    var _json = undefined;
                    try
                    {
                        _json = json_stringify(_string);
                    }
                    catch(_error)
                    {
                        show_debug_message(_error);
                    }
                    
                    if (_json == undefined)
                    {
                        __VedWarning("Failed to parse Vinyl project");
                        __VedModalOpen(__VedClassModalLoadFailed).__path = _vinylPath;
                        return;
                    }
                    
                    var _foundIdent = _json[$ "ident"];
                    if (_foundIdent == __receivedIdent)
                    {
                        __Close();
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