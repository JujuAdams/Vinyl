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
                ImGui.TextColored("Juju Adams\n" + __VED_VERSION + "\n" + __VED_DATE, #ff7f00);
            
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

            if (ImGui.Button("Project"))
            {
                __VedWindowOpenSingle(__VedClassWindowProject);
            }
            
            if (ImGui.Button("Config"))
            {
                __VedWindowOpenSingle(__VedClassWindowConfig);
            }
            
            ImGui.SameLine(undefined, 50);

            if (ImGui.Button("Now Playing"))
            {
                __VedWindowOpenSingle(__VedClassWindowNowPlaying);
            }
            
            ImGui.PopStyleColor();
        ImGui.EndMainMenuBar();
        
        ImGui.SetNextWindowPos(0, room_height - 28);
        ImGui.SetNextWindowSize(room_width, 28, ImGuiCond.Always);
        ImGui.Begin("Status Bar", true, ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize);
        
        ImGui.SmallButton("Log");
        ImGui.SameLine(undefined, 20);
        
        var _drawDuration = 800;
        var _logArray = _system.__logArray;
        var _length = array_length(_logArray);
        if (_length <= 0)
        {
            ImGui.Text(floor((current_time mod (_drawDuration-1)) / (_drawDuration/4))*".");
        }
        else
        {
            if (_length > 4) array_delete(_logArray, 0, _length-2);
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