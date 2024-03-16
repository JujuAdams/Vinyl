// Feather disable all

function __VedClassWindowDesktop() : __VedClassWindow() constructor
{
    static __Update = function()
    {
        __BuildUI();
    }
    
    static __BuildUI = function()
    {
        ImGui.BeginMainMenuBar();
            if (ImGui.BeginMenu("Vinyl"))
            {
                ImGui.TextColored("Vinyl " + __VED_VERSION + "\n" + __VED_DATE, #ff7f00);
            
                ImGui.Separator();
                
            	if (ImGui.MenuItem("Save"))
                {
                    VedSave();
            	}
                
            	if (ImGui.MenuItem("Load..."))
                {
                    var _yyPath = get_open_filename("GameMaker Project (*.yyp)|*.yyp", "");
                    if (_yyPath != "")
                    {
                        var _extension = filename_ext(_yyPath);
                        if (_extension != ".yyp")
                        {
                            __VedWarning("GameMaker project extension invalid");
                            __VedModalOpen(__VedClassModalOperationFailed).__path = _yyPath;
                            return;
                        }
                        
                        if (not file_exists(_yyPath))
                        {
                            __VedWarning("GameMaker project doesn't exist");
                            __VedModalOpen(__VedClassModalOperationFailed).__path = _yyPath;
                            return;
                        }
                        
                        VedLoad(_yyPath);
                    }
            	}
            
                ImGui.Separator();
                
            	if (ImGui.MenuItem("GitHub (URL)"))
                {
                    url_open("https://www.github.com/jujuadams/Vinyl");
            	}
                
            	if (ImGui.MenuItem("Documentation (URL)"))
                {
                    url_open("https://www.jujuadams.com/Vinyl");
            	}
                
                ImGui.Separator();
	
            	if (ImGui.MenuItem("Close Editor")) __VedModalOpen(__VedClassModalCloseProject);
                
            	ImGui.EndMenu();
            }
            
            ImGui.PushStyleColor(ImGuiCol.Button, c_white, 0);
            ImGui.SameLine(undefined, 50);

            if (ImGui.Button("Sounds"))
            {
                __VedWindowOpenSingle(__VedClassWindowProject);
            }

            if (ImGui.Button("Audio Groups"))
            {
                //__VedWindowOpenSingle(__VedClassWindowAudioGroups);
            }
            
            if (ImGui.Button("Asset Tags"))
            {
                //__VedWindowOpenSingle(__VedClassWindowAssetTags);
            }
            
            ImGui.PopStyleColor();
        ImGui.EndMainMenuBar();
        
        ImGui.SetNextWindowPos(0, room_height - 28);
        ImGui.SetNextWindowSize(room_width, 28, ImGuiCond.Always);
        ImGui.Begin("Status Bar", true, ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize);
        
        ImGui.SmallButton("Log");
        ImGui.SameLine(undefined, 20);
        
        var _drawDuration = 600;
        var _logArray = _system.__logArray;
        var _length = array_length(_logArray);
        if (_length <= 0)
        {
            ImGui.Text(floor((current_time mod (_drawDuration-1)) / (_drawDuration/4))*".");
        }
        else
        {
            if (_length > 10)
            {
                array_insert(_logArray, 0, {
                    __createTime: current_time,
                    __drawTime: undefined,
                    __string: string_concat("(Skipping ", _length-4, " messages)"),
                });
                
                array_delete(_logArray, 1, _length-4);
            }
            
            repeat(array_length(_logArray))
            {
                var _log = _logArray[0];
                
                var _drawTime = _log.__drawTime;
                if (_drawTime == undefined)
                {
                    _log.__drawTime = current_time;
                    ImGui.Text(_log.__string);
                    break;
                }
                else if (_drawTime + _drawDuration >= current_time)
                {
                    ImGui.Text(_log.__string);
                    break;
                }
                
                array_delete(_logArray, 0, 1);
            }
        }
        
        ImGui.End();
    }
}